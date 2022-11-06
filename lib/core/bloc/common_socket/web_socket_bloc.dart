import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
part 'web_socket_event.dart';
part 'web_socket_state.dart';

class WebSocketBloc extends Bloc<WebSocketInitEvents, WebSocketState> {
  WebSocketBloc() : super(WebSocketState()) {
    on<WebSocketEvent>(_initWebSocket);
    on<WebSocketCloseEvent>((event, emit) => _closeConnection(event, emit));
  }

  WebSocket? channel;

  // WebSocketChannel? channel;

  void _initWebSocket(
      WebSocketEvent event, Emitter<WebSocketState> emit) async {
    channel = await WebSocket.connect(
      'ws://194.58.69.88:8000/ws/${event.token}',
    );

    if (channel != null) {
      print('websocket CONNECT ${channel}');
      channel!.listen((event) async {
        print('websocket message ${event}');
        // Приглашение в авторизации
        print('websocket ${jsonDecode(event)}');
        if (jsonDecode(event)['type'] == 'notification') {
          print('websocket get invite');
          emit(WebSocketInviteState());
        }
      });
    } else {
      print('websocket ERROR');
    }
  }

  void _closeConnection(
          WebSocketCloseEvent event, Emitter<WebSocketState> emit) =>
      channel!.close();
}
