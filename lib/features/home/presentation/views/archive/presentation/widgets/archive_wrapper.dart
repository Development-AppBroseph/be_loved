import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/helpers/sync_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/bloc/albums/albums_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/moments/moments_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/memory_mini_info_card.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ships_page.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../modals/add_file/add_file_modal.dart';

class ArchiveWrapper extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Function(int index)? onChangePage;
  final int currentIndex;
  const ArchiveWrapper(
      {Key? key,
      required this.currentIndex,
      required this.child,
      required this.scrollController,
      this.onChangePage})
      : super(key: key);

  @override
  State<ArchiveWrapper> createState() => _ArchiveWrapperState();
}

class _ArchiveWrapperState extends State<ArchiveWrapper>
    with SingleTickerProviderStateMixin {
  final streamControllerPage = StreamController<int>();

  List<String> data = [
    'Моменты',
    'Галерея',
    'Альбомы',
    'События',
  ];

  static const _indicatorSize = 30.0;
  static const _imageSize = 30.0;

  late AnimationController _spoonController;
  static final _spoonTween = CurveTween(curve: Curves.easeInOutQuint);
  bool isLoading = false;
  bool isOpacity = false;
  final StreamController<bool> streamController = StreamController();
  void _showLoader() {
    setState(() {
      isLoading = true;
    });
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
    GalleryBloc galleryBloc = context.read<GalleryBloc>();
    galleryBloc.add(GetGalleryFilesEvent(isReset: false));
    allSync(context);
    streamController.sink.add(true);
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutQuint,
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isOpacity = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isOpacity = false;
      });
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      isLoading = false;
      streamController.sink.add(false);
    });
  }

  @override
  void initState() {
    _spoonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset.toInt() < -40 && !isLoading) {
        _showLoader();
      }
      // print('offset: ' + scrollController.offset.toString());
    });

    super.initState();
  }

  Widget _buildImage(IndicatorController controller, ParalaxConfig asset) {
    return Transform.translate(
      offset: Offset(
        0,
        (2 * (controller.value * 30.clamp(1, 10) - 5) * 6) + 30.h,
      ),
      child: OverflowBox(
        maxHeight: 50.h,
        minHeight: 50.h,
        child: Container(
          height: 50.h,
          width: 50.h,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  offset: const Offset(0, 0),
                  blurRadius: 4,
                )
              ]),
          padding: EdgeInsets.all(10.h),
          child: Image.asset(
            'assets/images/smile.png',
            fit: BoxFit.contain,
            height: _imageSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: ClrStyle.backToBlack17[sl<AuthConfig>().idx],
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.w,
                          right: 25.w,
                          top: 45.h + MediaQuery.of(context).padding.top,
                          bottom: 22.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MemoryMiniInfoCard(),
                          _buildAddBtn(context, () {
                            print('add');
                            if (context.read<ArchiveBloc>().memoryEntity !=
                                    null &&
                                !context
                                    .read<ArchiveBloc>()
                                    .memoryEntity!
                                    .fullFilled()) {
                              showModalAddFile(context, () {});
                            }
                          })
                        ],
                      )),
                  SizedBox(
                    height: 38.w,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                              right: 15.w, left: index == 0 ? 25.w : 0),
                          height: 38.h,
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onChangePage != null) {
                                widget.onChangePage!(index);
                              }
                            },
                            child: CupertinoCard(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              color: index == widget.currentIndex
                                  ? ColorStyles.blackColor
                                  : Colors.white,
                              radius: BorderRadius.circular(20.r),
                              child: Center(
                                  child: Text(data[index],
                                      style: TextStyles(context)
                                          .white_18_w800
                                          .copyWith(
                                              color: index ==
                                                      widget.currentIndex
                                                  ? Colors.white
                                                  : ColorStyles.greyColor))),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  widget.child,
                  SizedBox(
                    height: 700.h,
                  ),
                ],
              ),
            ),
            StreamBuilder<bool>(
              stream: streamController.stream,
              initialData: false,
              builder: (context, snapshot) {
                print('Изменения');
                if (snapshot.data!) {
                  return Stack(
                    children: [
                      backdropFilterExample(
                        context,
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          // color: Colors.black,
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOutQuint,
                        top: isOpacity ? 80.h : -100,
                        left: MediaQuery.of(context).size.width / 2 - 20.w,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 40.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            padding: EdgeInsets.all(10.h),
                            child: Image.asset(
                              'assets/images/smile.png',
                              fit: BoxFit.contain,
                              height: _imageSize,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const SizedBox(
                    width: 0,
                    height: 0,
                  );
                }
              },
            ),
          ],
        ));
  }

  Widget _buildAddBtn(BuildContext context, Function() tap) {
    return GestureDetector(
      onTap: tap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 38.h,
        width: 65.w,
        child: CupertinoCard(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: ColorStyles.primarySwath,
          radius: BorderRadius.circular(20.r),
          child: Center(
              child: Transform.rotate(
                  angle: pi / 4,
                  child: SvgPicture.asset(
                    SvgImg.add,
                    height: 16.h,
                    color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                  ))),
        ),
      ),
    );
  }

  Widget backdropFilterExample(BuildContext context, Widget child) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        child,
        AnimatedOpacity(
          opacity: isOpacity ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: const Color.fromRGBO(44, 44, 46, 0.1),
            ),
          ),
        )
      ],
    );
  }
}
