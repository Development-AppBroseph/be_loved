import 'package:equatable/equatable.dart';

class StaticsEntity extends Equatable {
  final int events;
  final int completeTargets;
  final int archive;

  StaticsEntity({
    required this.events,
    required this.completeTargets,
    required this.archive,
  });

  @override
  List<Object> get props => [
  ];
}
