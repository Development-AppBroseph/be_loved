import 'package:equatable/equatable.dart';

class PurposeEntity extends Equatable {
  final int id;
  final String name;
  final String photo;
  final DateTime? dateTime;
  final bool ifSeason;

  PurposeEntity({
    required this.id,
    required this.name,
    required this.photo,
    required this.dateTime,
    required this.ifSeason,
  });


  @override
  List<Object> get props => [
    id,
    name,
    photo,
    ifSeason
  ];
}
