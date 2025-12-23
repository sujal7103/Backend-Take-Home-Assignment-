import {
  IsString,
  IsEnum,
  IsObject,
  IsNotEmpty,
  IsOptional,
  IsDateString,
} from 'class-validator';
import { EventType } from '../schemas/conversation-event.schema';

export class CreateEventDto {
  @IsString()
  @IsNotEmpty()
  eventId: string;

  @IsEnum(EventType)
  type: EventType;

  @IsObject()
  @IsNotEmpty()
  payload: Record<string, any>;

  @IsOptional()
  @IsDateString()
  timestamp?: string;
}
