import { Injectable, NotFoundException } from '@nestjs/common';
import { EventRepository } from '../repositories/event.repository';
import { SessionRepository } from '../../session/repositories/session.repository';
import { CreateEventDto } from '../dto/create-event.dto';
import { EventResponseDto } from '../dto/event-response.dto';

@Injectable()
export class EventService {
  constructor(
    private readonly eventRepository: EventRepository,
    private readonly sessionRepository: SessionRepository,
  ) {}

  /**
   * Add an event to a session
   * Validates that session exists before adding event
   * Idempotent - duplicate eventIds return existing event
   */
  async addEvent(
    sessionId: string,
    createEventDto: CreateEventDto,
  ): Promise<EventResponseDto> {
    // Verify session exists
    const session = await this.sessionRepository.findBySessionId(sessionId);

    if (!session) {
      throw new NotFoundException(`Session ${sessionId} not found`);
    }

    // Add event (repository handles duplicate prevention)
    const event = await this.eventRepository.addEvent(
      sessionId,
      createEventDto,
    );

    return {
      eventId: event.eventId,
      sessionId: event.sessionId,
      type: event.type,
      payload: event.payload,
      timestamp: event.timestamp,
    };
  }
}
