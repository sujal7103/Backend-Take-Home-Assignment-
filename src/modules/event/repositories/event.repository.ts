import { Injectable, Logger, ConflictException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import {
  ConversationEvent,
  ConversationEventDocument,
} from '../schemas/conversation-event.schema';
import { CreateEventDto } from '../dto/create-event.dto';

@Injectable()
export class EventRepository {
  private readonly logger = new Logger(EventRepository.name);

  constructor(
    @InjectModel(ConversationEvent.name)
    private eventModel: Model<ConversationEventDocument>,
  ) {}

  /**
   * Add an event to a session
   * Uses unique compound index (sessionId, eventId) to prevent duplicates
   * Throws ConflictException if duplicate eventId for same session
   */
  async addEvent(
    sessionId: string,
    createEventDto: CreateEventDto,
  ): Promise<ConversationEventDocument> {
    const { eventId, type, payload, timestamp } = createEventDto;

    try {
      const event = new this.eventModel({
        sessionId,
        eventId,
        type,
        payload,
        timestamp: timestamp ? new Date(timestamp) : new Date(),
      });

      return await event.save();
    } catch (error) {
      // MongoDB duplicate key error code
      if (error.code === 11000) {
        this.logger.warn(
          `Duplicate event ${eventId} for session ${sessionId}`,
        );
        // Return existing event for idempotency
        const existingEvent = await this.eventModel
          .findOne({ sessionId, eventId })
          .exec();
        if (existingEvent) {
          return existingEvent;
        }
      }

      this.logger.error(
        `Error adding event ${eventId} to session ${sessionId}: ${error.message}`,
      );
      throw error;
    }
  }

  /**
   * Find events by sessionId with pagination
   * Returns events ordered by timestamp (newest first)
   */
  async findEventsBySessionId(
    sessionId: string,
    page: number = 1,
    limit: number = 20,
  ): Promise<{ events: ConversationEventDocument[]; total: number }> {
    const skip = (page - 1) * limit;

    const [events, total] = await Promise.all([
      this.eventModel
        .find({ sessionId })
        .sort({ timestamp: -1 }) // Newest first
        .skip(skip)
        .limit(limit)
        .exec(),
      this.eventModel.countDocuments({ sessionId }).exec(),
    ]);

    return { events, total };
  }

  /**
   * Count events for a session
   */
  async countEventsBySessionId(sessionId: string): Promise<number> {
    return this.eventModel.countDocuments({ sessionId }).exec();
  }

  /**
   * Check if an event exists
   */
  async eventExists(sessionId: string, eventId: string): Promise<boolean> {
    const count = await this.eventModel
      .countDocuments({ sessionId, eventId })
      .exec();
    return count > 0;
  }
}
