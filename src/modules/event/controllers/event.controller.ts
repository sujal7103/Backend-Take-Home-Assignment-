import {
  Controller,
  Post,
  Body,
  Param,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { EventService } from '../services/event.service';
import { CreateEventDto } from '../dto/create-event.dto';
import { EventResponseDto } from '../dto/event-response.dto';

@Controller('sessions')
export class EventController {
  constructor(private readonly eventService: EventService) {}

  /**
   * POST /sessions/:sessionId/events
   * Add an event to a session
   */
  @Post(':sessionId/events')
  @HttpCode(HttpStatus.CREATED)
  async addEvent(
    @Param('sessionId') sessionId: string,
    @Body() createEventDto: CreateEventDto,
  ): Promise<EventResponseDto> {
    return this.eventService.addEvent(sessionId, createEventDto);
  }
}
