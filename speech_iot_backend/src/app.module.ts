import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AppSpeechRecognitionGateway } from './app-speech-recognition.gateway';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService, AppSpeechRecognitionGateway],
})
export class AppModule {}
