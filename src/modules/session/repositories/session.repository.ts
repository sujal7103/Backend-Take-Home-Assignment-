import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import {
  ConversationSession,
  ConversationSessionDocument,
  SessionStatus,
} from '../schemas/conversation-session.schema';
import { CreateSessionDto } from '../dto/create-session.dto';

@Injectable()
export class SessionRepository {
  private readonly logger = new Logger(SessionRepository.name);

  constructor(
    @InjectModel(ConversationSession.name)
    private sessionModel: Model<ConversationSessionDocument>,
  ) {}

  /**
   * Upsert a session - creates new or returns existing
   * Uses findOneAndUpdate with upsert for atomicity and idempotency
   */
  async upsertSession(
    createSessionDto: CreateSessionDto,
  ): Promise<ConversationSessionDocument> {
    const { sessionId, language, status, metadata } = createSessionDto;

    try {
      // Use findOneAndUpdate with upsert for atomic operation
      // This ensures idempotency - if session exists, it returns the existing one
      const session = await this.sessionModel.findOneAndUpdate(
        { sessionId },
        {
          $setOnInsert: {
            sessionId,
            language,
            status: status || SessionStatus.INITIATED,
            startedAt: new Date(),
            endedAt: null,
            metadata: metadata || {},
          },
        },
        {
          upsert: true, // Create if doesn't exist
          new: false, // Return the existing document if found (before update)
          setDefaultsOnInsert: true,
        },
      );

      // If session is null, it means it was just created, fetch it
      if (!session) {
        const newSession = await this.sessionModel.findOne({ sessionId }).exec();
        if (!newSession) {
          throw new Error(`Failed to create session ${sessionId}`);
        }
        return newSession;
      }

      return session;
    } catch (error) {
      this.logger.error(
        `Error upserting session ${sessionId}: ${error.message}`,
      );
      throw error;
    }
  }

  /**
   * Find a session by sessionId
   */
  async findBySessionId(
    sessionId: string,
  ): Promise<ConversationSessionDocument | null> {
    return this.sessionModel.findOne({ sessionId }).exec();
  }

  /**
   * Complete a session - idempotent operation
   * Uses findOneAndUpdate for atomicity
   */
  async completeSession(
    sessionId: string,
  ): Promise<ConversationSessionDocument> {
    const session = await this.sessionModel
      .findOneAndUpdate(
        { sessionId },
        {
          $set: {
            status: SessionStatus.COMPLETED,
            endedAt: new Date(),
          },
        },
        {
          new: true, // Return updated document
        },
      )
      .exec();

    if (!session) {
      throw new Error(`Session ${sessionId} not found`);
    }

    return session;
  }

  /**
   * Update session status
   */
  async updateStatus(
    sessionId: string,
    status: SessionStatus,
  ): Promise<ConversationSessionDocument> {
    const session = await this.sessionModel
      .findOneAndUpdate(
        { sessionId },
        { $set: { status } },
        { new: true },
      )
      .exec();

    if (!session) {
      throw new Error(`Session ${sessionId} not found`);
    }

    return session;
  }
}
