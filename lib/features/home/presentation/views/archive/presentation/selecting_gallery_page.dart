import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/gallery_page.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/archive_fixed_top_info.dart';
import 'package:be_loved/features/home/presentation/views/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectingGalleryPage extends StatefulWidget {
  List<int> files;
  SelectingGalleryPage({required this.files});
  @override
  State<SelectingGalleryPage> createState() => _SelectingGalleryPageState();
}

class _SelectingGalleryPageState extends State<SelectingGalleryPage> {
  ScrollController scrollController = ScrollController();
  GalleryGroupFilesEntity? enitityPos;
  int hideGalleryFileID = 0;
  bool showTop = false;
  String dateTime = '';

  //Gallery
  List<int> gallerySelectedIds = [];
  double currentScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    gallerySelectedIds = widget.files;
    GalleryBloc bloc = context.read<GalleryBloc>();

    scrollController.addListener(() {
      double position = scrollController.position.pixels;
      currentScrollPosition = position;
      if(position > (scrollController.position.maxScrollExtent-100)){
        GalleryBloc galleryBloc = context.read<GalleryBloc>();
        if(!galleryBloc.isEnd && !galleryBloc.isLoading){
          galleryBloc.add(GetGalleryFilesEvent(isReset: false));
        }
      }



      int newHideGalleryFileID = 0;
      //Position of file
      for (int i = 0; i < bloc.groupedFiles.length; i++) {
        double widgetTopPos = bloc.groupedFiles[i].topPosition -
            MediaQuery.of(context).padding.top -
            20.h;
        if (widgetTopPos == 0) {
          break;
        }
        if (position >= widgetTopPos) {
          newHideGalleryFileID = bloc.groupedFiles[i].mainPhoto.id;
        }
        if (!(i != bloc.groupedFiles.length - 1 &&
            position >=
                bloc.groupedFiles[i + 1].topPosition -
                    MediaQuery.of(context).padding.top -
                    20.h)) {
          break;
        }
      }

      if (hideGalleryFileID != newHideGalleryFileID) {
        setState(() {
          print('NEWITEM: ${hideGalleryFileID}');
          hideGalleryFileID = newHideGalleryFileID;
          onChangeShow(
              hideGalleryFileID == 0
                  ? null
                  : bloc.groupedFiles
                      .where((element) =>
                          element.mainPhoto.id == hideGalleryFileID)
                      .first,
              hideGalleryFileID == 0);
        });
      }
    });
  }

  onChangeShow(GalleryGroupFilesEntity? show, bool hide) {
    setState(() {
      if (show != null) {
        showTop = true;
        enitityPos = show;
      } else {
        showTop = false;
      }
    });
  }

  ScrollPhysics physics = const NeverScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    GalleryBloc galleryBloc = context.read<GalleryBloc>();
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        onTap: (){
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: GalleryPage(
                isForSelecting: true,
                position: currentScrollPosition,
                hideGalleryFileID: 0,
                deletingIds: gallerySelectedIds,
                onSelectForDeleting: (id){
                  if(gallerySelectedIds.contains(id)){
                    gallerySelectedIds.remove(id);
                  }else{
                    gallerySelectedIds.add(id);
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 15.h,
            left: 30.w,
            right: 22.w,
            child: ArchiveFixedTopInfo(
              showTop: showTop,
              enitityPos: enitityPos,
              onBackTap: (){
                Navigator.pop(context, gallerySelectedIds);
              },
              dateTime: dateTime,
              isForSelecting: true,
              isDeleting: gallerySelectedIds.isNotEmpty,
              onTap: (){
                if(enitityPos != null && gallerySelectedIds.isEmpty){
                  gallerySelectedIds.add(enitityPos!.mainPhoto.id);
                }else{
                  gallerySelectedIds = [];
                }
                setState(() {});
              },
              onDeleteTap: (){},
            )
          ),
        ],
      ),
    );
  }
}
