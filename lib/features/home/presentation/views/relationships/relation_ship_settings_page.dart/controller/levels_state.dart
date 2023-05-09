import 'package:be_loved/features/home/domain/entities/home/levels_entiti.dart';
import 'package:equatable/equatable.dart';

abstract class LevelState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LevelEmptyState extends LevelState{
  @override
  List<Object?> get props => [];
}

class LevelLoadingState extends LevelState{
  @override
  List<Object?> get props => [];
}

class LevelLoadedState extends LevelState {
  final List<LevelEntiti> levels;
   LevelLoadedState({
    required this.levels,
  });
  @override
  List<Object?> get props => [levels];
}

class LevelErrorState extends LevelState{
  final String message;

  LevelErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}