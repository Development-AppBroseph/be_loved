import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/albums/albums_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/moments/moments_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/albums_page.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/gallery_page.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/moments_page.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/archive_fixed_top_info.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/archive_wrapper.dart';
import 'package:be_loved/features/home/presentation/views/events/view/event_detail_view.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/events/events_bloc.dart';
import 'event_page.dart';
import 'helpers/gallery_helper.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  bool showTop = false;
  bool hideTopBar = true;
  GalleryGroupFilesEntity? enitityPos;
  String dateTime = '';

  int currentPageIndex = 1;

  //Gallery
  int hideGalleryFileID = 0;
  bool hideFixedDate = false;
  List<int> galleryDeleteIds = [];
  double currentScrollPosition = 0;

  // Map<String, dynamic> inGroupPositionCalcID(double position){
  //   GalleryBloc bloc = context.read<GalleryBloc>();
  //   int newHideGalleryFileID = 0;
  //   bool newHideFixedDate = false;
  //   for (int i = 0; i < bloc.groupedFiles.length; i++) {
  //     print('POST: ${position}');
  //     print('TPPPOS: ${bloc.groupedFiles[i].topPosition} ||| id: ${bloc.groupedFiles[i].mainPhoto.id}');
  //     double widgetTopPos = bloc.groupedFiles[i].topPosition -
  //         MediaQuery.of(context).padding.top -
  //         20.h;
  //     print('NEW POST: ${widgetTopPos}');
  //     if (widgetTopPos == 0) {
  //       break;
  //     }
  //     if (position >= widgetTopPos) {
  //       newHideGalleryFileID = bloc.groupedFiles[i].mainPhoto.id;
  //     }
  //     if (i != bloc.groupedFiles.length - 1) {
  //       if (80.h <=
  //           ((bloc.groupedFiles[i + 1].topPosition -
  //                   MediaQuery.of(context).padding.top -
  //                   20.h) -
  //               position)) {
  //         newHideFixedDate = true;
  //       } else {
  //         newHideFixedDate = false;
  //       }
  //     }
  //   }

  //   return {
  //     'newHideFixedDate': newHideFixedDate,
  //     'newHideGalleryFileID': newHideGalleryFileID
  //   };
  // }

  @override
  void initState() {
    super.initState();

    GalleryBloc bloc = context.read<GalleryBloc>();
    ArchiveBloc archiveBloc = context.read<ArchiveBloc>();
    AlbumsBloc albumsBloc = context.read<AlbumsBloc>();
    MomentsBloc momentsBloc = context.read<MomentsBloc>();
    EventsBloc eventsBloc = context.read<EventsBloc>();

    if (bloc.state is GalleryFilesInitialState) {
      bloc.add(GetGalleryFilesEvent(isReset: false));
    }
    if (albumsBloc.state is AlbumInitialState) {
      albumsBloc.add(GetAlbumsEvent());
    }
    if (archiveBloc.memoryEntity == null ||
        sl<AuthConfig>().memoryEntity == null) {
      archiveBloc.add(GetMemoryInfoEvent());
    }

    scrollController.addListener(() {
      double position = scrollController.position.pixels;
      currentScrollPosition = position;
      //Pagination gallery
      if (position > (scrollController.position.maxScrollExtent - 100) &&
          currentPageIndex == 1) {
        GalleryBloc galleryBloc = context.read<GalleryBloc>();
        if (!galleryBloc.isEnd && !galleryBloc.isLoading) {
          galleryBloc.add(GetGalleryFilesEvent(isReset: false));
        }
      }

      //Pagination moments
      if (position > (scrollController.position.maxScrollExtent - 100) &&
          currentPageIndex == 0 &&
          momentsBloc.state is! MomentInitialState) {
        MomentsBloc momentsBloc = context.read<MomentsBloc>();
        if (!momentsBloc.isEnd && !momentsBloc.isLoading) {
          momentsBloc.add(GetMomentsEvent(isReset: false));
        }
      }

      //Pagination old events
      if (position > (scrollController.position.maxScrollExtent - 100) &&
          currentPageIndex == 3) {
        if (!eventsBloc.isEnd && !eventsBloc.isLoading) {
          eventsBloc.add(GetOldEventsEvent(isReset: false));
        }
      }

      if (currentPageIndex != 1) {
        if (!hideTopBar) {
          setState(() {
            hideTopBar = true;
          });
        }
        return;
      }
      int newHideGalleryFileID = 0;
      bool newHideFixedDate = false;
      if (position > 170) {
        newHideFixedDate = false;
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
          if (i != bloc.groupedFiles.length - 1) {
            if (80.h <=
                ((bloc.groupedFiles[i + 1].topPosition -
                        MediaQuery.of(context).padding.top -
                        20.h) -
                    position)) {
              newHideFixedDate = true;
            } else {
              newHideFixedDate = false;
            }
          }
          if (!(i != bloc.groupedFiles.length - 1 &&
              position >=
                  bloc.groupedFiles[i + 1].topPosition -
                      MediaQuery.of(context).padding.top -
                      20.h)) {
            break;
          }
        }
      } else {
        newHideGalleryFileID = 0;
      }
      if (hideGalleryFileID != newHideGalleryFileID ||
          newHideFixedDate != hideFixedDate) {
        setState(() {
          // print('NEWID: ${newHideGalleryFileID}');
          // print('NEW HIDE: ${newHideFixedDate}');
          hideGalleryFileID = newHideGalleryFileID;
          hideFixedDate = newHideFixedDate;
          onChangeShow(
              hideGalleryFileID == 0 || !hideFixedDate
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
        dateTime = convertToRangeDates(show);
        showTop = true;
        enitityPos = show;
      } else {
        showTop = false;
      }
      hideTopBar = hide;
    });
  }

  onDeleteFiles() {
    showLoaderWrapper(context);
    context
        .read<GalleryBloc>()
        .add(GalleryFileDeleteEvent(ids: galleryDeleteIds));
    setState(() {
      galleryDeleteIds = [];
      showTop = false;
      hideTopBar = true;
    });
  }

  void nextPage(int id) {
    context.read<EventsBloc>().eventDetailSelectedId = id;

    pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuint);
  }

  void prevPage() => pageController.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint);
  ScrollPhysics physics = const NeverScrollableScrollPhysics();

  changePage(int newPage) {
    setState(() {
      currentPageIndex = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocListener<GalleryBloc, GalleryState>(
          listener: (context, state) {
            if (state is GalleryFilesDeletedState ||
                state is GalleryFilesAddedState) {
              // currentScrollPosition = 0;
            }
          },
          child: PageView(
            controller: pageController,
            physics: physics,
            scrollDirection: Axis.horizontal,
            onPageChanged: (value) {
              // physics = value == 0
              //     ? const NeverScrollableScrollPhysics()
              //     : const ClampingScrollPhysics();
              setState(() {});
            },
            children: [
              Stack(
                children: [
                  ArchiveWrapper(
                    currentIndex: currentPageIndex,
                    onChangePage: changePage,
                    scrollController: scrollController,
                    child: currentPageIndex == 0
                        ? MomentsPage()
                        : currentPageIndex == 1
                            ? GalleryPage(
                                onPageChange: changePage,
                                position: currentScrollPosition,
                                hideGalleryFileID: hideGalleryFileID,
                                deletingIds: galleryDeleteIds,
                                onSelectForDeleting: (id) {
                                  if (galleryDeleteIds.contains(id)) {
                                    galleryDeleteIds.remove(id);
                                  } else {
                                    galleryDeleteIds.add(id);
                                  }
                                  setState(() {});
                                },
                              )
                            : currentPageIndex == 2
                                ? AlbumsPage()
                                : currentPageIndex == 3
                                    ? EventPageInArchive(
                                        pageController: pageController,
                                        nextPage: nextPage,
                                      )
                                    : const SizedBox.shrink(),
                  ),
                  if (!hideTopBar && currentPageIndex == 1)
                    Positioned(
                        top: MediaQuery.of(context).padding.top + 15.h,
                        left: 30.w,
                        right: 22.w,
                        child: ArchiveFixedTopInfo(
                          showTop: showTop,
                          enitityPos: enitityPos,
                          dateTime: dateTime,
                          isDeleting: galleryDeleteIds.isNotEmpty,
                          onTap: () {
                            if (enitityPos != null &&
                                galleryDeleteIds.isEmpty) {
                              galleryDeleteIds.add(enitityPos!.mainPhoto.id);
                            } else {
                              galleryDeleteIds = [];
                            }
                            setState(() {});
                          },
                          onDeleteTap: onDeleteFiles,
                        )),
                ],
              ),
              EventDetailView(
                prevPage: prevPage,
                isOld: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
