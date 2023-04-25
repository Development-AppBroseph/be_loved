import 'package:be_loved/features/home/data/models/purposes/promos_model.dart';
import 'package:be_loved/features/home/domain/entities/purposes/promos_entiti.dart';
import 'package:equatable/equatable.dart';

class PurposeEntity extends Equatable {
  final int id;
  final int? widgetId;
  final String name;
  final String photo;
  final String? verdict;
  final int? forPhotoId;
  final DateTime? dateTime;
  final bool ifSeason;
  bool inProcess;
  bool inHistory;
  PromosEntiti? promo;

  PurposeEntity({
    required this.id,
    required this.widgetId,
    required this.name,
    required this.forPhotoId,
    required this.verdict,
    required this.photo,
    required this.dateTime,
    required this.ifSeason,
    this.inProcess = false,
    required this.inHistory,
    required this.promo,
  });

  @override
  List<Object> get props => [
        id,
        name,
        photo,
        ifSeason,
        inProcess,
        inHistory,
      ];
}