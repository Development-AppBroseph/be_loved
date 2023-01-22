import 'dart:io';

import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/presentation/bloc/main_widgets/main_widgets_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/video_view_v2.dart';
import 'package:be_loved/features/home/presentation/views/events/view/photo_view.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/event_photo_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_card.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/file_widget_delete_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class MainWidgets extends StatelessWidget {


  void completePurpose(BuildContext context, int id){
    showLoaderWrapper(context);
    context.read<PurposeBloc>().add(CompletePurposeEvent(target: id));
  }

  void cancelPurpose(BuildContext context, int id){
    showLoaderWrapper(context);
    context.read<PurposeBloc>().add(CancelPurposeEvent(target: id));
  }

  void sendPhotoPurpose(BuildContext context, int id, File file){
    showLoaderWrapper(context);
    context.read<PurposeBloc>().add(SendPhotoPurposeEvent(path: file.path, target: id));
  }

  GlobalKey fileKey = GlobalKey();

  deleteFileWidget(BuildContext context, int id, GlobalKey keyg){
    fileWidgetDeleteModalModal(
      context,
      getWidgetPosition(keyg),
      (){
        Navigator.pop(context);
        context.read<MainWidgetsBloc>().add(DeleteFileWidgetEvent(id: id));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    MainWidgetsBloc bloc = context.read<MainWidgetsBloc>();
    PurposeBloc purposeBloc = context.read<PurposeBloc>();
    return BlocConsumer<MainWidgetsBloc, MainWidgetsState>(
      listener: (context, state) {
        if(state is MainWidgetsErrorState){
          Loader.hide();
          showAlertToast(state.message);
        }
        if(state is MainWidgetsInternetErrorState){
          Loader.hide();
          showAlertToast('Проверьте соединение с интернетом!');
        }
        if(state is MainWidgetsAddedState && state.isRefresh){
          bloc.add(GetMainWidgetsEvent());
        }
      },
      builder: (context, state) {
        if(state is MainWidgetsInitialState || state is MainWidgetsLoadingState){
          return Container();
        }
        return BlocConsumer<PurposeBloc, PurposeState>(
          listener: (context, state) {
            if(state is PurposeErrorState){
              Loader.hide();
              showAlertToast(state.message);
            }
            if(state is PurposeInternetErrorState){
              Loader.hide();
              showAlertToast('Проверьте соединение с интернетом!');
            }
            if(state is CompletedPurposeState){
              Loader.hide();
              purposeBloc.add(GetAllPurposeDataEvent());
              bloc.add(GetMainWidgetsEvent());
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if(bloc.mainWidgets.file != null)
                ...[EventPhotoCard(
                  isVideo: bloc.mainWidgets.file!.isVideo,
                  additionKey: GlobalKey(), 
                  onAdditionTap: () {  },
                  onAdditionWithKeyTap: (g){
                    deleteFileWidget(context, (bloc.mainWidgets.file!.widgetId ?? 1), g!);
                  },
                  onTap: (){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => bloc.mainWidgets.file!.isVideo
                          ? VideoView(url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', duration: const Duration(seconds: 0)) 
                          : PhotoFullScreenView(urlToImage: (bloc.mainWidgets.file!.urlToFile.contains('http')
                            ? bloc.mainWidgets.file!.urlToFile
                            : (Config.url.url + bloc.mainWidgets.file!.urlToFile))),
                        transitionDuration: Duration(milliseconds: 400),
                        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                    ));
                  }, 
                  url: bloc.mainWidgets.file!.isVideo 
                    ? (bloc.mainWidgets.file!.urlToPreviewVideoImage != null && bloc.mainWidgets.file!.urlToPreviewVideoImage!.contains('http')
                    ? bloc.mainWidgets.file!.urlToPreviewVideoImage ?? ''
                    : (Config.url.url + (bloc.mainWidgets.file!.urlToPreviewVideoImage ?? ''))) 
                    : (bloc.mainWidgets.file!.urlToFile.contains('http')
                    ? bloc.mainWidgets.file!.urlToFile
                    : (Config.url.url + bloc.mainWidgets.file!.urlToFile)),
                  title: bloc.mainWidgets.file!.place ?? '', 
                ),
                SizedBox(height: 15.h,),],


                if(bloc.mainWidgets.purposes.isNotEmpty)
                ...bloc.mainWidgets.purposes.map((e) 
                  => Padding(
                    padding: EdgeInsets.only(bottom: 15.h),
                    child: PurposeCard(
                      purposeEntity: e,
                      onPickFile: (f){
                        sendPhotoPurpose(context, e.id, f);
                      },
                      onCompleteTap: (){
                        completePurpose(context, e.id);
                      },
                      onCancelTap: (){
                        cancelPurpose(context, e.id);
                      },
                      isMainWidget: true,
                      deleteTap: (){
                        context.read<MainWidgetsBloc>().add(DeletePurposeWidgetEvent(id: e.widgetId ?? 1));
                      },
                    ),
                  )
                ).toList()
              ],
            );
          }
        );
      }
    );
  }
}