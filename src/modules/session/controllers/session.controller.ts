import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  Query,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { SessionService } from '../services/session.service';
import { CreateSessionDto } from '../dto/create-session.dto';
import { SessionResponseDto } from '../dto/session-response.dto';
import { PaginationDto } from '../dto/pagination.dto';

@Controller('sessions')
export class SessionController {
  constructor(private readonly sessionService: SessionService) {}

  /**
   * POST /sessions
   * Create or get existing session (idempotent)
   */
  @Post()
  @HttpCode(HttpStatus.OK)
  async upsertSession(
    @Body() createSessionDto: CreateSessionDto,
  ): Promise<SessionResponseDto> {
    return this.sessionService.upsertSession(createSessionDto);
  }

  /**
   * GET /sessions/:sessionId
   * Get session with paginated events
   */
  @Get(':sessionId')
  async getSession(
    @Param('sessionId') sessionId: string,
    @Query() paginationDto: PaginationDto,
  ): Promise<SessionResponseDto> {
    const { page, limit } = paginationDto;
    return this.sessionService.getSessionById(sessionId, page, limit);
  }

  /**
   * POST /sessions/:sessionId/complete
   * Complete a session (idempotent)
   */
  @Post(':sessionId/complete')
  @HttpCode(HttpStatus.OK)
  async completeSession(
    @Param('sessionId') sessionId: string,
  ): Promise<SessionResponseDto> {
    return this.sessionService.completeSession(sessionId);
  }
}
