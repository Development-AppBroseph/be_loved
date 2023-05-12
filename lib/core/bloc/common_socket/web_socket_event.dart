part of 'web_socket_bloc.dart';

class WebSocketInitEvents {}

class WebSocketEvent extends WebSocketInitEvents {
  String token;

  WebSocketEvent(this.token);
}

class WebSocketSendInviteMessage extends WebSocketInitEvents {}

class WebSocketGetInviteMessage extends WebSocketInitEvents {}

class WebSocketCloseInviteMessage extends WebSocketInitEvents {}

class WebSocketAcceptInviteMessage extends WebSocketInitEvents {}

class WebSocketStartRelationshipsMessage extends WebSocketInitEvents {}

class WebSocketCloseEvent extends WebSocketInitEvents {}
