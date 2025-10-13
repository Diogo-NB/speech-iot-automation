import {
  WebSocketGateway,
  WebSocketServer,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { WebSocket } from 'ws';

@WebSocketGateway({ path: '/speech-recognition' })
export class AppSpeechRecognitionGateway
  implements OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: any;

  handleConnection(client: WebSocket) {
    console.log('Client connected');
    client.send(JSON.stringify({ message: 'Connected to NestJS backend' }));

    client.on('message', (raw) => {
      try {
        const message = JSON.parse(raw.toString()) as Record<string, unknown>;
        console.log('Received message from client:', message);

        this.handleMessage(client, message);
      } catch (err) {
        console.error('Error parsing message:', err);
      }
    });
  }

  handleDisconnect() {
    console.log('Client disconnected');
  }

  private handleMessage(client: WebSocket, data: any) {
    client.send(
      JSON.stringify({ message: `Command received: ${JSON.stringify(data)}` }),
    );
  }
}
