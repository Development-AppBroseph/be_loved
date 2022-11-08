part of 'web_socket_bloc.dart';

class WebSocketInitEvents {}

class WebSocketEvent extends WebSocketInitEvents {
  String token;

  WebSocketEvent(this.token);
}

class WebSocketSendInviteMessage extends WebSocketCloseEvent {}

class WebSocketGetInviteMessage extends WebSocketCloseEvent {}

class WebSocketCloseInviteMessage extends WebSocketCloseEvent {}

class WebSocketAcceptInviteMessage extends WebSocketCloseEvent {}

class WebSocketCloseEvent extends WebSocketInitEvents {}
