part of 'main_widgets_bloc.dart';


abstract class MainWidgetsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetMainWidgetsEvent extends MainWidgetsEvent{}

class AddFileWidgetEvent extends MainWidgetsEvent{
  final GalleryFileEntity file;
  AddFileWidgetEvent({required this.file});
}


class AddPurposeWidgetEvent extends MainWidgetsEvent{
  final PurposeEntity purpose;
  AddPurposeWidgetEvent({required this.purpose});
}


class DeleteFileWidgetEvent extends MainWidgetsEvent{
  final int id;
  DeleteFileWidgetEvent({required this.id});
}


class DeletePurposeWidgetEvent extends MainWidgetsEvent{
  final int id;
  DeletePurposeWidgetEvent({required this.id});
}