import { Injectable, NotFoundException } from '@nestjs/common';
import { SessionRepository } from '../repositories/session.repository';
import { EventRepository } from '../../event/repositories/event.repository';
import { CreateSessionDto } from '../dto/create-session.dto';
import { SessionResponseDto } from '../dto/session-response.dto';
import { SessionStatus } from '../schemas/conversation-session.schema';

@Injectable()
export class SessionService {
  constructor(
    private readonly sessionRepository: SessionRepository,
    private readonly eventRepository: EventRepository,
  ) {}

  /**
   * Create or get existing session (idempotent)
   */
  async upsertSession(
    createSessionDto: CreateSessionDto,
  ): Promise<SessionResponseDto> {
    const session =
      await this.sessionRepository.upsertSession(createSessionDto);

    return this.mapToResponseDto(session);
  }

  /**
   * Get session by ID with paginated events
   */
  async getSessionById(
    sessionId: string,
    page: number = 1,
    limit: number = 20,
  ): Promise<SessionResponseDto> {
    const session = await this.sessionRepository.findBySessionId(sessionId);

    if (!session) {
      throw new NotFoundException(`Session ${sessionId} not found`);
    }

    // Fetch events with pagination
    const { events, total } =
      await this.eventRepository.findEventsBySessionId(
        sessionId,
        page,
        limit,
      );

    const totalPages = Math.ceil(total / limit);

    return {
      ...this.mapToResponseDto(session),
      events: events.map((event) => ({
        eventId: event.eventId,
        type: event.type,
        payload: event.payload,
        timestamp: event.timestamp,
      })),
      pagination: {
        total,
        page,
        limit,
        totalPages,
      },
    };
  }

  /**
   * Complete a session (idempotent)
   */
  async completeSession(sessionId: string): Promise<SessionResponseDto> {
    const session = await this.sessionRepository.findBySessionId(sessionId);

    if (!session) {
      throw new NotFoundException(`Session ${sessionId} not found`);
    }

    // If already completed, return current state (idempotent)
    if (session.status === SessionStatus.COMPLETED) {
      return this.mapToResponseDto(session);
    }

    const updatedSession =
      await this.sessionRepository.completeSession(sessionId);

    return this.mapToResponseDto(updatedSession);
  }

  /**
   * Helper method to map document to DTO
   */
  private mapToResponseDto(session: any): SessionResponseDto {
    return {
      sessionId: session.sessionId,
      status: session.status,
      language: session.language,
      startedAt: session.startedAt,
      endedAt: session.endedAt,
      metadata: session.metadata,
    };
  }
}
