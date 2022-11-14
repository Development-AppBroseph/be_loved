import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketInitEvents, WebSocketState> {
  WebSocketBloc() : super(WebSocketState()) {
    // on<WebSocketEvent>(_initWebSocket);
    on<WebSocketCloseEvent>(_closeConnection);
    on<WebSocketGetInviteMessage>(_getInvite);
    on<WebSocketSendInviteMessage>(_sendInvite);
    on<WebSocketCloseInviteMessage>(_closeInvite);
    on<WebSocketAcceptInviteMessage>(_acceptInvite);
  }

  void _getInvite(WebSocketGetInviteMessage event, Emitter<WebSocketState> emit) =>
      emit(WebSocketInviteGetState());
  void _sendInvite(WebSocketSendInviteMessage event, Emitter<WebSocketState> emit) =>
      emit(WebSocketInviteSendState());
  void _closeInvite(WebSocketCloseInviteMessage event, Emitter<WebSocketState> emit) =>
      emit(WebSocketInviteCloseState());
  void _acceptInvite(WebSocketAcceptInviteMessage event, Emitter<WebSocketState> emit) =>
      emit(WebSocketInviteAcceptState());

  WebSocket? channel;

  void _initWebSocket(
      WebSocketEvent event, Emitter<WebSocketState> emit) async {
    channel = await WebSocket.connect(
      'ws://194.58.69.88:8000/ws/${event.token}',
    );

    if (channel != null) {
      print('websocket CONNECT');
      channel!.listen(
        (event) async {
          print('websocket message ${jsonDecode(event)}');
          // Приглашение в авторизации
          if (jsonDecode(event)['type'] == 'notification') {
            if(jsonDecode(event)['message'] == 'Вам пришло приглашение') {
              add(WebSocketGetInviteMessage());
            } else if(jsonDecode(event)['message'] == 'Приглашение отправлено') {
              add(WebSocketSendInviteMessage());
            } else if(jsonDecode(event)['message'] == 'Отношения разрушены (может даже не начавшись') {
              add(WebSocketCloseInviteMessage());
            } else if(jsonDecode(event)['message'] == 'Поздравляю с началом отношений!') {
              add(WebSocketAcceptInviteMessage());
            }
          }
        },
        onDone: () {
          _initWebSocket(event, emit);
        },
      );
    }
  }

  void _closeConnection(
          WebSocketCloseEvent event, Emitter<WebSocketState> emit) =>
      channel!.close();
}
