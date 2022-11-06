part of 'web_socket_bloc.dart';

class WebSocketInitEvents {}

class WebSocketEvent extends WebSocketInitEvents {
  String token;

  WebSocketEvent(this.token);
}

class WebSocketGetMessage extends WebSocketCloseEvent {}

class WebSocketCloseEvent extends WebSocketInitEvents {}
