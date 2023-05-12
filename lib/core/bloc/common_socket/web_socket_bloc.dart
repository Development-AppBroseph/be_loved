import 'dart:convert';
import 'dart:io';

import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/secure_storage.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/locator.dart';
import 'package:bloc/bloc.dart';

part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketInitEvents, WebSocketState> {
  WebSocketBloc() : super(WebSocketState()) {
    on<WebSocketEvent>(_initWebSocket);
    on<WebSocketCloseEvent>(_closeConnection);
    on<WebSocketGetInviteMessage>(_getInvite);
    on<WebSocketSendInviteMessage>(_sendInvite);
    on<WebSocketCloseInviteMessage>(_closeInvite);
    on<WebSocketAcceptInviteMessage>(_acceptInvite);
    on<WebSocketStartRelationshipsMessage>(_startRelationships);
  }

  void _getInvite(
          WebSocketGetInviteMessage event, Emitter<WebSocketState> emit) =>
      emit(WebSocketInviteGetState());
  void _sendInvite(
          WebSocketSendInviteMessage event, Emitter<WebSocketState> emit) =>
      emit(WebSocketInviteSendState());
  void _closeInvite(
          WebSocketCloseInviteMessage event, Emitter<WebSocketState> emit) =>
      emit(WebSocketInviteCloseState());
  void _acceptInvite(
      WebSocketAcceptInviteMessage event, Emitter<WebSocketState> emit) async {
    sl<AuthConfig>().user = await MySharedPrefs().user;
    sl<AuthConfig>().token = await MySecureStorage().getToken();
    emit(WebSocketInviteAcceptState());
  }

  void _startRelationships(WebSocketStartRelationshipsMessage event,
          Emitter<WebSocketState> emit) =>
      emit(WebSocketStartRelatioinshipsState());

  int trialsCount = 0;
  WebSocket? channel;

  void _initWebSocket(
      WebSocketEvent event, Emitter<WebSocketState> emit) async {
    print('WEBSOCKET: ${'${Config.ws.ws}/ws/${event.token}'}');
    channel = await WebSocket.connect(
      '${Config.ws.ws}/ws/${event.token}',
    );
    if (channel != null) {
      print('websocket CONNECT');
      channel!.listen((event) async {
        try {
          print('websocket message ${jsonDecode(event)}');
          print('object sokect statetyeteyte ${jsonDecode(event)['message']}');
          // Приглашение в авторизации
          if (jsonDecode(event)['type'] == 'notification') {
            if (jsonDecode(event)['message'] == 'Вам пришло приглашение') {
              add(WebSocketGetInviteMessage());
            } else if (jsonDecode(event)['message'] ==
                'Приглашение отправлено') {
              add(WebSocketSendInviteMessage());
            } else if (jsonDecode(event)['message'] ==
                'Отношения разрушены (может даже не начавшись') {
              add(WebSocketCloseInviteMessage());
            } else if (jsonDecode(event)['message'] ==
                'Поздравляю с началом отношений!') {
              add(WebSocketAcceptInviteMessage());
            } else if (jsonDecode(event)['message'] ==
                'Дата отношений изменена!') {
              add(WebSocketStartRelationshipsMessage());
            }
          }
        } catch (e) {
          print(e);
        }
      }, 
      onError: (error) {
        print('SOCKET ERROR: $error');
        if (trialsCount < 4) {
          channel!.close();
          _initWebSocket(event, emit);
          trialsCount++;
        }
      });
    }
  }

  void _closeConnection(
      WebSocketCloseEvent event, Emitter<WebSocketState> emit) {
    channel!.close();
    print('Closed');
  }
}
