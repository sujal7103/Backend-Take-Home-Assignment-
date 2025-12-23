import {
  IsString,
  IsEnum,
  IsOptional,
  IsObject,
  IsNotEmpty,
} from 'class-validator';
import { SessionStatus } from '../schemas/conversation-session.schema';

export class CreateSessionDto {
  @IsString()
  @IsNotEmpty()
  sessionId: string;

  @IsEnum(SessionStatus)
  @IsOptional()
  status?: SessionStatus;

  @IsString()
  @IsNotEmpty()
  language: string;

  @IsObject()
  @IsOptional()
  metadata?: Record<string, any>;
}
