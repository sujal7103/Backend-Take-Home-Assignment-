import { Module, forwardRef } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import {
  ConversationEvent,
  ConversationEventSchema,
} from './schemas/conversation-event.schema';
import { EventController } from './controllers/event.controller';
import { EventService } from './services/event.service';
import { EventRepository } from './repositories/event.repository';
import { SessionModule } from '../session/session.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: ConversationEvent.name, schema: ConversationEventSchema },
    ]),
    forwardRef(() => SessionModule),
  ],
  controllers: [EventController],
  providers: [EventService, EventRepository],
  exports: [EventRepository, EventService],
})
export class EventModule {}
