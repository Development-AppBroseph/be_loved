import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/detail_gallery.dart';
import 'package:be_loved/features/home/presentation/views/archive/helpers/gallery_helper.dart';
import 'package:be_loved/features/home/presentation/views/archive/widgets/gallery_settings_modal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class GalleryPage extends StatefulWidget {
  final ScrollController scrollController;
  final Function(GalleryGroupFilesEntity? group) onChangeShow;
  GalleryPage({required this.scrollController, required this.onChangeShow});
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  
  int hideGalleryFileID = 0;
  bool hideFixedDate = false;

  showGallerySettingsModal(Offset offset){
    gallerySettingsModal(
      context, 
      offset,
      (){},
      (){}
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    GalleryBloc bloc = context.read<GalleryBloc>();

    if(bloc.state is GalleryFilesInitialState){
      bloc.add(GetGalleryFilesEvent(isReset: false));
    }

    widget.scrollController.addListener(() {
      double position = widget.scrollController.position.pixels;
      int newHideGalleryFileID = 0;
      bool newHideFixedDate = false;
      if(position > 170){
        newHideFixedDate = false;
        for(int i = 0; i < bloc.groupedFiles.length; i++){
          double widgetTopPos = bloc.groupedFiles[i].topPosition-MediaQuery.of(context).padding.top-20.h;
          if(widgetTopPos == 0){
            break;
          }
          if(position >= widgetTopPos){
            newHideGalleryFileID = bloc.groupedFiles[i].mainPhoto.id;
          }
          if(i != bloc.groupedFiles.length-1){
            if(80.h <= ((bloc.groupedFiles[i+1].topPosition-MediaQuery.of(context).padding.top-20.h) - position)){
              newHideFixedDate = true;
            }else{
              newHideFixedDate = false;
            }
          }
          if(!(i != bloc.groupedFiles.length-1 && position >= bloc.groupedFiles[i+1].topPosition-MediaQuery.of(context).padding.top-20.h)){
            break;
          }
        }
      }else{
        newHideGalleryFileID = 0;
      }
      if(hideGalleryFileID != newHideGalleryFileID || newHideFixedDate != hideFixedDate){
        setState(() {
          print('NEWID: ${newHideGalleryFileID}');
          print('NEW HIDE: ${newHideFixedDate}');
          hideGalleryFileID = newHideGalleryFileID;
          hideFixedDate = newHideFixedDate;
          widget.onChangeShow(hideGalleryFileID == 0 || !hideFixedDate ? null : bloc.groupedFiles.where((element) => element.mainPhoto.id == hideGalleryFileID).first);
        });
      }
    });
  }

  
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
                        => _buildMiniItem(group.additionalFiles[index])
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


  Widget _buildMainItem(GlobalKey mainKey, GlobalKey newKey, int index, GalleryFileEntity file, GalleryGroupFilesEntity group){
    if(group.topPosition == 0){
      Future.delayed(Duration(milliseconds: 100), (){
        GalleryBloc bloc = context.read<GalleryBloc>();
        for(var gItem in bloc.groupedFiles){
          if(gItem.mainPhoto.id == file.id){
            bloc.groupedFiles[bloc.groupedFiles.indexOf(gItem)].topPosition = getWidgetPosition(mainKey).dy;
            print('SETTING: ${bloc.groupedFiles[bloc.groupedFiles.indexOf(gItem)].topPosition}');
            break;
          }
        }
        for(var fItem in bloc.files){
          if(fItem.id == file.id){
            bloc.groupedFiles[bloc.files.indexOf(fItem)].topPosition = getWidgetPosition(mainKey).dy;
            break;
          }
        }
      });
    }
    // WidgetsFlutterBinding().addPostFrameCallback((_){
    //   GalleryBloc bloc = context.read<GalleryBloc>();
    //   for(var gItem in bloc.groupedFiles){
    //     if(gItem.mainPhoto.id == file.id){
    //       bloc.groupedFiles[bloc.groupedFiles.indexOf(gItem)].topPosition = getWidgetPosition(newKey).dy;
    //       print('SETTING: ${bloc.groupedFiles[bloc.groupedFiles.indexOf(gItem)].topPosition}');
    //       break;
    //     }
    //   }
    // });
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DetailGalleryPage(group: group,),
            transitionDuration: Duration(milliseconds: 400),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ));
      },
      key: mainKey,
      child: Padding(
        padding: EdgeInsets.only(top: 4.w),
        child: Stack(
          children: [
            Hero(
              tag: '#${file.id}',
              child: CachedNetworkImage(
                imageUrl: file.urlToFile,
                height: 428.w,
                width: double.infinity,
                fit: BoxFit.cover,
              )
              // Image.asset(
              //   'assets/images/gallery1.png', 
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              //   height: 428.w,  
              // )
            ),
            Container(
              width: double.infinity,
              height: 151.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2C2C2E).withOpacity(0.5),
                    Color(0xFF2C2C2E).withOpacity(0),
                  ]
                )
              ),
            ),
            if(file.id != hideGalleryFileID)
            Positioned(
              top: 25.h,
              left: 30.w,
              right: 40.w,
              // child: AnimatedOpacity(
                // opacity: file.id != hideGalleryFileID ? 1 : 0,
                // duration: const Duration(milliseconds: 800),
                // curve: Curves.easeInOutQuint,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(convertToRangeDates(group), style: TextStyles(context).white_35_w800.copyWith(color: Colors.white.withOpacity(0.7),)),
                        GestureDetector(
                          onTap: (){
                            showGallerySettingsModal(getWidgetPosition(newKey));
                          },
                          child: SvgPicture.asset(
                            SvgImg.dots,
                            height: 7.h,
                            color: Colors.white,
                            key: newKey,
                          ),
                        ),
                      ],
                    ),
                    Text(file.place, style: TextStyles(context).white_15_w800.copyWith(color: Colors.white.withOpacity(0.7),)),
                  ],
                // ),
              )
            ),
          ],
        ),
      ),
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
