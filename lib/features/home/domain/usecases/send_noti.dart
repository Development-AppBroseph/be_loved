import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../repositories/main_widgets_repository.dart';

class SendNotificaton implements UseCase<void, SendNotiParams> {
  final MainWidgetsRepository mainWidgetsRepository;

  SendNotificaton({required this.mainWidgetsRepository});

  @override
  Future<Either<Failure, void>> call(SendNotiParams params) async {
    return await mainWidgetsRepository.sendNoti();
  }
}

class SendNotiParams extends Equatable {
  @override
  List<Object?> get props => [];
}
