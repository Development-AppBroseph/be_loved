import 'dart:ui';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_widgets/main_widgets_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/detail_gallery.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/helpers/gallery_helper.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/video_view_v2.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery/main_media_card.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery/mini_media_card.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery_settings_modal.dart';
import 'package:be_loved/features/home/presentation/views/events/view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryPage extends StatefulWidget {
  final int hideGalleryFileID;
  final List<int> deletingIds;
  final Function(int id) onSelectForDeleting;
  double position;
  final bool isForSelecting;
  final Function(int i) onPageChange;
  GalleryPage({required this.position, required this.onPageChange, this.isForSelecting = false, required this.hideGalleryFileID, required this.deletingIds, required this.onSelectForDeleting});
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  showGallerySettingsModal(Offset offset, int id){
    gallerySettingsModal(
      context, 
      offset,
      (){
        Navigator.pop(context);
        showLoaderWrapper(context);
        context.read<GalleryBloc>().add(GalleryFileDeleteEvent(ids: [id]));
      },
    );
  }

  bool isDeleting = false;


  @override
  Widget build(BuildContext context) {
    GalleryBloc bloc = context.read<GalleryBloc>();
    return BlocConsumer<GalleryBloc, GalleryState>(
      listener: (context, state) {
        if(state is GalleryFilesErrorState){
          Loader.hide();
          showAlertToast(state.message);
        }
        if(state is GalleryFilesInternetErrorState){
          Loader.hide();
          showAlertToast('Проверьте соединение с интернетом!');
        }
        if(state is GalleryFilesDeletedState){
          Loader.hide();
          bloc.add(GetGalleryFilesEvent(isReset: true));
          context.read<MainWidgetsBloc>().add(GetMainWidgetsEvent());
        }
        if(state is GalleryFilesDeletedState){
          for(int i = 0; i < bloc.groupedFiles.length; i++){
            bloc.groupedFiles[i].topPosition = 0;
          }
          widget.position = 0;
          setState(() {});
        }
      },
      builder: (context, state) {
        if(state is GalleryFilesInitialState || state is GalleryFilesLoadingState){
          return Container();
        }
        return SingleChildScrollView(
          child: Column(
            children: bloc.groupedFiles.map((group) 
              => Stack(
                children: [
                  Wrap(
                    spacing: 4.w,
                    runSpacing: 4.w,
                    children: [
                      _buildMainItem(GlobalKey(),GlobalKey(), bloc.groupedFiles.indexOf(group), group.mainPhoto, group),
                      if(group.mainVideo != null)
                      _buildMainItem(GlobalKey(),GlobalKey(), bloc.groupedFiles.indexOf(group), group.mainVideo!, group),
                      ...List.generate(galleryGroupingCount(group), (index) 
                        => MiniMediaCard(
                          file: group.additionalFiles[index],
                          isSelected: widget.deletingIds.contains(group.additionalFiles[index].id),
                          onLongTap: (){
                            widget.onSelectForDeleting(group.additionalFiles[index].id);
                          },
                          onTap: (){
                            if(widget.deletingIds.isNotEmpty || widget.isForSelecting){
                              widget.onSelectForDeleting(group.additionalFiles[index].id);
                            }else{
                              if(group.additionalFiles[index].isVideo){
                                Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) =>
                                  VideoView(
                                    url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                                    // url: index == 0
                                    // ? widget.group.mainPhoto.urlToFile
                                    // : index == 1
                                    // ? widget.group.mainVideo!.urlToFile
                                    // : widget.group.additionalFiles[index - 1 + (widget.group.mainVideo == null ? 0 : 1)].urlToFile, 
                                    duration: null
                                  )
                                ));
                              }else{
                                Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => PhotoFullScreenView(urlToImage: group.additionalFiles[index].urlToFile,)));
                              }
                            }
                          },
                        )
                      ).toList()
                    ],
                  ),


                  if(group.additionalFiles.length - galleryGroupingCount(group) != 0 && !widget.isForSelecting)
                  Positioned(
                    bottom: 12.h,
                    right: 12.h,
                    child: ClipPath.shape(
                      shape: SquircleBorder(
                        radius: BorderRadius.circular(22.r)
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 11.w),
                          color: Colors.white.withOpacity(0.7),
                          alignment: Alignment.center,
                          child: Text('+${group.additionalFiles.length - galleryGroupingCount(group)}', style: TextStyles(context).black_15_w800.copyWith(color: ColorStyles.blackColor.withOpacity(0.7)),)
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ).toList(),
            // List.generate(20, 
            //   (index) => index % 5 == 0
            //   ? _buildMainItem(GlobalKey(), index)
            //   : index != 0 && (index-1) % 5 == 0
            //   ? _buildVideoItem()
            //   : _buildMiniItem()
            // ),
          ),
        );
      }, 
    );
  }




  Widget _buildMainItem(GlobalKey mainKey, GlobalKey dotsKey, int index, GalleryFileEntity file, GalleryGroupFilesEntity group){
    //Setting position of group
    if(group.topPosition == 0){
      print('SET POSITIONS: ${widget.position}');
      Future.delayed(Duration(milliseconds: 150), (){
        GalleryBloc bloc = context.read<GalleryBloc>();
        for(var gItem in bloc.groupedFiles){
          if(gItem.mainPhoto.id == file.id){
            bloc.groupedFiles[bloc.groupedFiles.indexOf(gItem)].topPosition = getWidgetPosition(mainKey).dy+((widget.position == 0) ? 0 : (widget.position-10.h));
            print('SETTING: ${bloc.groupedFiles[bloc.groupedFiles.indexOf(gItem)].topPosition}');
            break;
          }
        }
      });
    }
    return MainMediaCard(
      dotsKey: dotsKey,
      isForSelecting: widget.isForSelecting,
      isDeleting: widget.deletingIds.contains(file.id),
      mainKey: mainKey,
      onLongTap: (){
        if(widget.deletingIds.isEmpty){
          widget.onSelectForDeleting(file.id);
        }
      },
      onDotsTap: (){
        showGallerySettingsModal(getWidgetPosition(dotsKey), file.id);
      },
      onTapTop: (){
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DetailGalleryPage(
              group: group, 
              onPageChange: widget.onPageChange,
              onSelectForDeleting: widget.onSelectForDeleting,
              deletingIds: widget.deletingIds,
            ),
            transitionDuration: Duration(milliseconds: 400),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ));
      },
      onTapBottom: (){
        if(widget.deletingIds.isEmpty && !widget.isForSelecting){
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => file.isVideo && file.id != group.mainPhoto.id
                ? VideoView(url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', duration: const Duration(seconds: 0)) 
                : DetailGalleryPage(
                  group: group, 
                  onPageChange: widget.onPageChange,
                  onSelectForDeleting: widget.onSelectForDeleting,
                  deletingIds: widget.deletingIds,
                ),
              transitionDuration: Duration(milliseconds: 400),
              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          ));
        }else{
          widget.onSelectForDeleting(file.id);
        }
      },
      file: file,
      group: group,
      showTopBar: file.id != widget.hideGalleryFileID,

    );
    
  }



}
