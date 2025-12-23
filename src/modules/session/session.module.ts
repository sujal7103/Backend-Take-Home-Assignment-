import { Module, forwardRef } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import {
  ConversationSession,
  ConversationSessionSchema,
} from './schemas/conversation-session.schema';
import { SessionController } from './controllers/session.controller';
import { SessionService } from './services/session.service';
import { SessionRepository } from './repositories/session.repository';
import { EventModule } from '../event/event.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: ConversationSession.name, schema: ConversationSessionSchema },
    ]),
    forwardRef(() => EventModule),
  ],
  controllers: [SessionController],
  providers: [SessionService, SessionRepository],
  exports: [SessionRepository, SessionService],
})
export class SessionModule {}
