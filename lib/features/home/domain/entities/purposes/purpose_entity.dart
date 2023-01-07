import 'package:equatable/equatable.dart';

class PurposeEntity extends Equatable {
  final int id;
  final String name;
  final String photo;
  final String? verdict;
  final int? forPhotoId;
  final DateTime? dateTime;
  final bool ifSeason;
  bool inProcess;
  bool inHistory;

  PurposeEntity({
    required this.id,
    required this.name,
    required this.forPhotoId,
    required this.verdict,
    required this.photo,
    required this.dateTime,
    required this.ifSeason,
    this.inProcess = false,
    required this.inHistory
  });


  @override
  List<Object> get props => [
    id,
    name,
    photo,
    ifSeason,
    inProcess,
    inHistory
  ];
}
