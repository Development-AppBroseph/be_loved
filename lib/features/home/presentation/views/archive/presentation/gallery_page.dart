import 'dart:ui';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/detail_gallery.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/helpers/gallery_helper.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class GalleryPage extends StatefulWidget {
  final int hideGalleryFileID;
  final List<int> deletingIds;
  final Function(int id) onSelectForDeleting;
  GalleryPage({required this.hideGalleryFileID, required this.deletingIds, required this.onSelectForDeleting});
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  showGallerySettingsModal(Offset offset){
    gallerySettingsModal(
      context, 
      offset,
      (){},
      (){}
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
        if(state is GalleryFilesAddedState){
          Loader.hide();
          bloc.add(GetGalleryFilesEvent(isReset: true));
        }
        if(state is GalleryFilesDeletedState){
          Loader.hide();
          bloc.add(GetGalleryFilesEvent(isReset: true));
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
                      _buildVideoItem(),
                      ...List.generate(galleryGroupingCount(group), (index) 
                        => MiniMediaCard(
                          file: group.additionalFiles[index],
                          isSelected: widget.deletingIds.contains(group.additionalFiles[index].id),
                          onTap: (){
                            if(widget.deletingIds.isNotEmpty){
                              widget.onSelectForDeleting(group.additionalFiles[index].id);
                            }else{
                              Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => PhotoFullScreenView(urlToImage: group.additionalFiles[index].urlToFile,)));
                            }
                          },
                        )
                      ).toList()
                    ],
                  ),


                  if(group.additionalFiles.length - galleryGroupingCount(group) != 0)
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
                  )
                ],
              )
            ).toList()
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







  Widget _buildVideoItem(){
    return Stack(
      children: [
        Container(
          height: 284.h,
          color: ColorStyles.greyColor2,
          child: Image.asset('assets/images/gallery2.png', fit: BoxFit.cover,),
        ),
        Positioned.fill(
          child: Center(child: SvgPicture.asset(SvgImg.play, ))
        ),
        Positioned(
          top: 30.h,
          right: 30.w,
          child: Text('0:40', style: TextStyles(context).white_15_w800)
        )
      ],
    );
  }


  Widget _buildMainItem(GlobalKey mainKey, GlobalKey dotsKey, int index, GalleryFileEntity file, GalleryGroupFilesEntity group){
    //Setting position of group
    if(group.topPosition == 0){
      Future.delayed(Duration(milliseconds: 100), (){
        GalleryBloc bloc = context.read<GalleryBloc>();
        for(var gItem in bloc.groupedFiles){
          if(gItem.mainPhoto.id == file.id){
            bloc.groupedFiles[bloc.groupedFiles.indexOf(gItem)].topPosition = getWidgetPosition(mainKey).dy;
            // print('SETTING: ${bloc.groupedFiles[bloc.groupedFiles.indexOf(gItem)].topPosition}');
            break;
          }
        }
      });
    }
    return MainMediaCard(
      dotsKey: dotsKey,
      isDeleting: widget.deletingIds.contains(file.id),
      mainKey: mainKey,
      onDotsTap: (){
        showGallerySettingsModal(getWidgetPosition(dotsKey));
      },
      onTap: (){
        if(widget.deletingIds.isEmpty){
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => DetailGalleryPage(group: group,),
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







  _buildMiniItem(GalleryFileEntity file){
    return Container(
      height: 140.h,
      width: 140.w,
      color: ColorStyles.greyColor2,
      child: CachedNetworkImage(
        imageUrl: file.urlToFile,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      )
    );
  }

}
