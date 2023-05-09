import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/entities/home/levels_entiti.dart';
import 'package:be_loved/features/home/domain/entities/main_widgets/main_widgets_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_file_widget.dart';
import 'package:be_loved/features/home/domain/usecases/add_purpose_widget.dart';
import 'package:be_loved/features/home/domain/usecases/delete_file_widget.dart';
import 'package:be_loved/features/home/domain/usecases/delete_purpose_widget.dart';
import 'package:dartz/dartz.dart';

abstract class MainWidgetsRepository {
  Future<Either<Failure, MainWidgetsEntity>> getMainWidgets();
  Future<Either<Failure, void>> addFileWidget(AddFileWidgetParams params);
  Future<Either<Failure, void>> addPurposeWidget(AddPurposeWidgetParams params);
  Future<Either<Failure, void>> deleteFileWidget(DeleteFileWidgetParams params);
  Future<Either<Failure, void>> deletePurposeWidget(DeletePurposeWidgetParams params);
  Future<Either<Failure, void>> sendNoti();
  Future<Either<Failure, List<LevelEntiti>>> getLevels();
}