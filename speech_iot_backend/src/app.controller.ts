import { Controller, Get } from '@nestjs/common';
import * as https from 'https';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('health-check')
  healthCheck(): string {
    https.get('https://www.google.com', (res) => {
      if (res.statusCode === 200) {
        console.log('Internet Connection: OK');
      } else {
        throw new Error('Internet Connection: Fail');
      }
    });

    return 'OK';
  }
}
