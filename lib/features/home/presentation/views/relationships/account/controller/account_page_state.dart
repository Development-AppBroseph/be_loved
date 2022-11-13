import 'package:equatable/equatable.dart';

abstract class AccountPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountEmptytPageState extends AccountPageState {
  @override
  List<Object?> get props => [];
}

class AccountPostRequestPageState extends AccountPageState {
  @override
  List<Object?> get props => [];
}

class AccountPutCodePageState extends AccountPageState {
  @override
  List<Object?> get props => [];
}

class AccountGetResponsePageState extends AccountPageState {
  @override
  List<Object?> get props => [];
}
class AccountGetCodeResponsePageState extends AccountPageState {
  @override
  List<Object?> get props => [];
}

class AccountGetErrorPageState extends AccountPageState {
  final String message;

  AccountGetErrorPageState({required this.message});
  @override
  List<Object?> get props => [message];
}
