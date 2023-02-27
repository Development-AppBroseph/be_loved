import 'package:equatable/equatable.dart';

abstract class SubState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubEmptyState extends SubState {
  @override
  List<Object?> get props => [];
}

class SubHaveState extends SubState {
  @override
  List<Object?> get props => [];
}

class SubNotHaveState extends SubState {
  @override
  List<Object?> get props => [];
}
