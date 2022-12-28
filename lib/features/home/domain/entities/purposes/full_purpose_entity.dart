import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:equatable/equatable.dart';

class FullPurposeEntity extends Equatable {
  final int id;
  final String? verdict;
  final String? photo;
  final String? desc;
  final PurposeEntity purpose;

  FullPurposeEntity({
    required this.id,
    required this.photo,
    required this.verdict,
    required this.purpose,
    required this.desc,
  });


  @override
  List<Object> get props => [
    id,
    purpose
  ];
}
