import { SessionStatus } from '../schemas/conversation-session.schema';

export class SessionResponseDto {
  sessionId: string;
  status: SessionStatus;
  language: string;
  startedAt: Date;
  endedAt: Date | null;
  metadata: Record<string, any>;
  events?: any[];
  pagination?: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}
