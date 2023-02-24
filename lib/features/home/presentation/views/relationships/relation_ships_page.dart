import 'dart:async';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/helpers/events.dart';
import 'package:be_loved/core/utils/helpers/sync_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_widgets/main_widgets_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/selecting_gallery_page.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/modals/widget_purposes_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/file_widget_delete_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_first.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_second.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/main_widgets.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/text_widget.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:be_loved/features/profile/presentation/views/subscription_view.dart';
import 'package:be_loved/features/profile/presentation/widget/decor/sliding_background_card.dart';
import 'package:be_loved/features/profile/presentation/widget/main_file/parametrs_user_bottomsheet.dart';
import 'package:be_loved/core/widgets/buttons/custom_add_animation_button.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_item_relationships.dart';
import 'package:be_loved/features/theme/bloc/theme_bloc.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'modals/add_event_modal.dart';
import 'modals/create_event_modal.dart';

class ParalaxConfig {
  final int? level;
  final String image;

  const ParalaxConfig({
    this.level,
    required this.image,
  });
}

class RelationShipsPage extends StatefulWidget {
  final VoidCallback nextPage;
  final Function(int id) toDetailPage;
  final Function() toRelationSettingsPage;
  final Function() toStaticsPage;
  const RelationShipsPage(
      {Key? key,
      required this.nextPage,
      required this.toDetailPage,
      required this.toRelationSettingsPage,
      required this.toStaticsPage})
      : super(key: key);

  @override
  State<RelationShipsPage> createState() => _RelationShipsPageState();
}

class _RelationShipsPageState extends State<RelationShipsPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final int maxLength = 18;
  String text = '';
  final _streamController = StreamController<int>();
  final _streamControllerCarousel = StreamController<double>();
  final _scrollController = ScrollController();

  static const _indicatorSize = 30.0;
  static const _imageSize = 30.0;

  late AnimationController _spoonController;
  static final _spoonTween = CurveTween(curve: Curves.easeInOutQuint);
  late final AnimationController animationController;

  final _borderRadius = BorderRadius.all(
    Radius.circular(38.r),
  );

  final TextEditingController _controller = TextEditingController(
      text: sl<AuthConfig>().user == null ? '' : sl<AuthConfig>().user!.name);
  FocusNode f1 = FocusNode();
  bool heartPressed = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      }
    });
    _spoonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
    });

    // getNameRelationShips();
  }

  // void getNameRelationShips() async {
  //   final name = await MySharedPrefs().getNameRelationShips;
  //   if (name != null && name.length > 0) {
  //     _controller.text = name;
  //   } else {
  //     _controller.text = 'Назовите отношения';
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    _controller.removeListener(() {});
    _streamController.close();
    _streamControllerCarousel.close();
  }

  resetPositions() {
    GalleryBloc bloc = context.read<GalleryBloc>();
    for (int i = 0; i < bloc.groupedFiles.length; i++) {
      bloc.groupedFiles[i].topPosition = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        content(context),
      ],
    );
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
          ),
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

  List<Events> events = [];

  Widget content(BuildContext context) {
    EventsBloc eventsBloc = context.read<EventsBloc>();
    TextStyle style1 = TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 15.sp,
        height: 1);

    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
      return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              // if(context.read<ThemeBloc>().state is ThemeInitialState){
              // context.read<ThemeBloc>().add(SetThemeEvent(index: state.user.theme == 'dark' ? 1 : 0));
              // }
              print('GOT USER');
              Loader.hide();
              setState(() {
                _controller.text = sl<AuthConfig>().user!.name ?? '';
              });
            }
          },
          child: BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
            if (state is ProfileErrorState) {
              Loader.hide();
              showAlertToast(state.message);
            }
            if (state is ProfileInternetErrorState) {
              Loader.hide();
              showAlertToast('Проверьте соединение с интернетом!');
            }
            if (state is ProfileEditedSuccessState) {
              Loader.hide();
            }
          }, builder: (context, state) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Stack(
                children: [
                  SlidingBackgroundCard(),
                  CustomRefreshIndicator(
                    onRefresh: () async {
                      showLoaderWrapper(context);
                      context
                          .read<AuthBloc>()
                          .add(GetUser(isJustRefresh: true));
                      allSync(context);
                      return;
                    },
                    builder: (BuildContext context, Widget child,
                        IndicatorController controller) {
                      return Stack(
                        children: <Widget>[
                          AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, Widget? _) {
                              return SizedBox(
                                height: controller.value * _indicatorSize,
                                child: Stack(
                                  children: <Widget>[
                                    /// check if it is a spoon build animated builed and attach spoon controller

                                    _buildImage(
                                        controller,
                                        ParalaxConfig(
                                            level: 5,
                                            image: 'assets/icons/add.svg')),
                                  ],
                                ),
                              );
                            },
                          ),
                          AnimatedBuilder(
                            builder: (context, _) {
                              return Transform.translate(
                                offset: Offset(0.0, controller.value * 0),
                                child: child,
                              );
                            },
                            animation: controller,
                          ),
                        ],
                      );
                    },
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      // physics: const AlwaysScrollableScrollPhysics(
                      //     parent: ClampingScrollPhysics()),

                      child: GestureDetector(
                        onTap: () {
                          // f1.unfocus();
                        },
                        child: Stack(
                          children: [
                            // SlidingBackgroundCard(),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 25.w,
                                    left: 25.w,
                                    top: 59.h,
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: widget.nextPage,
                                        child: Row(
                                          children: [
                                            photoMini(
                                                sl<AuthConfig>().user == null
                                                    ? null
                                                    : sl<AuthConfig>()
                                                        .user!
                                                        .me
                                                        .photo),
                                            SizedBox(width: 12.w),
                                            Text(
                                              sl<AuthConfig>().user == null
                                                  ? ''
                                                  : sl<AuthConfig>()
                                                      .user!
                                                      .me
                                                      .username,
                                              style: style1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () =>
                                            showMaterialModalBottomSheet(
                                          animationCurve: Curves.easeInOutQuint,
                                          duration:
                                              const Duration(milliseconds: 600),
                                          context: context,
                                          // shape: RoundedRectangleBorder(
                                          //   borderRadius: BorderRadius.vertical(
                                          //     top: Radius.circular(50.r),
                                          //   ),
                                          // ),
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              ParametrsUserBottomsheet(
                                            onRelationSettingsTap: () {
                                              Navigator.pop(context);
                                              widget.toRelationSettingsPage();
                                            },
                                          ),
                                        ).then((value) {
                                          if (value is String) {
                                            if (value == 'account') {
                                              widget.nextPage();
                                            }
                                          }
                                        }),
                                        child: Container(
                                          height: 55.h,
                                          width: 55.h,
                                          color: Colors.transparent,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SizedBox(
                                                height: 5.57.h,
                                                width: 33.43.h,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: 3,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          index) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5.57.h),
                                                      height: 5.57.h,
                                                      width: 5.57.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    1.5.r),
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                BlocConsumer<ProfileBloc, ProfileState>(
                                  listener: (context, state) {
                                    if (state is ProfileErrorState) {
                                      Loader.hide();
                                      showAlertToast(state.message);
                                    }
                                    if (state is ProfileInternetErrorState) {
                                      Loader.hide();
                                      showAlertToast(
                                          'Проверьте соединение с интернетом!');
                                    }
                                    if (state
                                        is ProfileRelationNameChangedState) {
                                      // Loader.hide();
                                      // showLoaderWrapper(context);
                                      context
                                          .read<AuthBloc>()
                                          .add(GetUser(isJustRefresh: true));
                                    }
                                  },
                                  builder: (context, state) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 25.w,
                                        right: 38.w,
                                      ),
                                      child: SizedBox(
                                        height: 45.h,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 33.h,
                                                child: TextField(
                                                  onSubmitted: (s) {
                                                    if (s.length > 1) {
                                                      showLoaderWrapper(
                                                          context);
                                                      context
                                                          .read<ProfileBloc>()
                                                          .add(EditRelationNameEvent(
                                                              name: _controller
                                                                  .text
                                                                  .trim()));
                                                    }
                                                  },
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  onChanged: (value) {
                                                    if (value.length <=
                                                        maxLength) {
                                                      text = value;
                                                    } else {
                                                      _controller.value =
                                                          TextEditingValue(
                                                        text: text,
                                                        selection:
                                                            TextSelection(
                                                          baseOffset: maxLength,
                                                          extentOffset:
                                                              maxLength,
                                                          affinity: TextAffinity
                                                              .upstream,
                                                          isDirectional: false,
                                                        ),
                                                        composing: TextRange(
                                                          start: 0,
                                                          end: maxLength,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  cursorColor: Colors.white,
                                                  cursorHeight: 30,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  controller: _controller,
                                                  focusNode: f1,
                                                  scrollPadding:
                                                      EdgeInsets.zero,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    border: InputBorder.none,
                                                    hintText: f1.hasFocus
                                                        ? " "
                                                        : 'Назовите отношения',
                                                    hintStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                if (f1.hasFocus) {
                                                  f1.unfocus();
                                                  // MySharedPrefs().setNameRelationShips(
                                                  //     _controller.text);
                                                  // getNameRelationShips();
                                                  showLoaderWrapper(context);
                                                  context
                                                      .read<ProfileBloc>()
                                                      .add(
                                                          EditRelationNameEvent(
                                                              name: _controller
                                                                  .text
                                                                  .trim()));
                                                } else {
                                                  FocusScope.of(context)
                                                      .requestFocus(f1);
                                                }
                                              },
                                              child: _controller
                                                          .text.isNotEmpty &&
                                                      f1.hasFocus
                                                  ? const Icon(
                                                      Icons.check_rounded,
                                                      color: Colors.white,
                                                    )
                                                  : !f1.hasFocus
                                                      ? SvgPicture.asset(
                                                          SvgImg.edit)
                                                      : const Icon(
                                                          Icons.check_rounded,
                                                          color: Colors.white,
                                                        ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 25.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      sl<AuthConfig>().user!.fromYou ?? true
                                          ? _buildCurrentUser()
                                          : _buildLoveUser(),
                                      const Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(top: 13.h),
                                        child: SizedBox(
                                          height: 108.h,
                                          width: 108.w,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (heartPressed == false) {
                                                    heartPressed = true;
                                                    animationController
                                                        .forward();
                                                  } else {
                                                    heartPressed = false;
                                                    animationController.reset();
                                                  }
                                                  eventsBloc.sendNotification();
                                                },
                                                child: Lottie.asset(
                                                    'assets/animations/heart.json',
                                                    repeat: false,
                                                    controller:
                                                        animationController),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      sl<AuthConfig>().user!.fromYou ?? true
                                          ? _buildLoveUser()
                                          : _buildCurrentUser()
                                    ],
                                  ),
                                ),
                                SizedBox(height: 26.h),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 40.h),
                                      child: _body(eventsBloc, context, false),
                                    ),
                                    _body(eventsBloc, context, true),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }));
    });
  }

  Container _body(EventsBloc eventsBloc, BuildContext context, bool isVisible) {
    return Container(
      color: !isVisible ? ClrStyle.backgroundColor[sl<AuthConfig>().idx] : null,
      child: Opacity(
        opacity: isVisible ? 1 : 0,
        child: Column(
          children: [
            StreamBuilder<double>(
              stream: isVisible ? _streamControllerCarousel.stream : null,
              builder: (context, snapshot) {
                double data = snapshot.data ?? 0;
                return CarouselSlider(
                  items: [
                    Column(
                      children: [
                        SizedBox(
                          width: 378.w,
                          height: 115.h,
                          child: HomeInfoFirst(
                            onRelationTap: widget.toRelationSettingsPage,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 378.w,
                          height: (data * 138.h + 115.h),
                          child: HomeInfoSecond(
                            onStatsTap: widget.toStaticsPage,
                            data: data,
                            onRelationTap: widget.toRelationSettingsPage,
                          ),
                        ),
                      ],
                    )
                  ],
                  options: CarouselOptions(
                    viewportFraction: 0.91,
                    onScrolled: (d) {
                      _streamControllerCarousel.sink.add(d ?? 0);
                    },
                    enableInfiniteScroll: false,
                    height: data >= 1 ? 253.h : (data * 138.h + 115.h),
                  ),
                );
              },
            ),
            SizedBox(height: 15.h),
            BlocConsumer<EventsBloc, EventsState>(listener: (context, state) {
              if (state is EventErrorState) {
                showAlertToast(state.message);
                if (state.isTokenError) {
                  print('TOKEN ERROR, LOGOUT...');
                  context.read<AuthBloc>().add(LogOut(context));
                }
              }
              if (state is EventInternetErrorState) {
                showAlertToast('Проверьте соединение с интернетом!');
              }
            }, builder: (context, state) {
              if (state is EventLoadingState) {
                return Container();
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: ReorderableListView.builder(
                  onReorder: (oldIndex, newIndex) {
                    context.read<EventsBloc>().add(EventChangeToHomeEvent(
                        eventEntity: eventsBloc.eventsInHome[oldIndex],
                        position: newIndex));
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: eventsBloc.eventsInHome.length,
                  itemBuilder: ((context, index) {
                    return CustomAnimationItemRelationships(
                      events: eventsBloc.eventsInHome[index],
                      // func: func,
                      key: ValueKey('${eventsBloc.eventsInHome[index].id}'),
                      delete: (i) {
                        eventsBloc.add(EventChangeToHomeEvent(
                            eventEntity: null, position: i));
                      },
                      index: index,
                      onDetail: (id) {
                        widget.toDetailPage(id);
                      },
                    );
                  }),
                  proxyDecorator: (child, index, animation) {
                    return Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            blurRadius: 20.h,
                            color: Color.fromRGBO(0, 0, 0, 0.1))
                      ], borderRadius: BorderRadius.circular(20.r)),
                      child: child,
                    );
                  },
                ),
              );
            }),
            MainWidgets(),
            // if (events.isEmpty) SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: CustomAddAnimationButton(
                //On event tap
                func: () {
                  if (eventsBloc.eventsInHome.length < 3) {
                    if (!eventsBloc.eventsInHome.any((element) =>
                        element.id == eventsBloc.events.first.id)) {
                      context.read<EventsBloc>().add(EventChangeToHomeEvent(
                          eventEntity: eventsBloc.events.first,
                          position: eventsBloc.eventsInHome.isEmpty
                              ? 0
                              : eventsBloc.eventsInHome.length + 1));
                    } else {
                      showModalAddEvent(context, () {});
                    }
                  }
                },

                //On archive tap
                funcArchive: () async {
                  if (context.read<MainWidgetsBloc>().mainWidgets == null ||
                      context.read<MainWidgetsBloc>().mainWidgets.file !=
                          null) {
                    return;
                  }

                  int? fileId;
                  GalleryBloc bloc = context.read<GalleryBloc>();
                  bloc.add(GetGalleryFilesEvent(isReset: false));
                  resetPositions();
                  List<int>? files =
                      await Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => SelectingGalleryPage(
                      files: fileId != null ? [fileId] : [],
                      isOneItemSelecting: true,
                    ),
                    transitionDuration: Duration(milliseconds: 400),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ));
                  resetPositions();
                  if (files != null) {
                    fileId = files.first;
                    context.read<MainWidgetsBloc>().add(AddFileWidgetEvent(
                        file: bloc.files
                            .where((element) => element.id == fileId)
                            .first));
                  }
                },

                //On purpose tap
                funcPurpose: () {
                  if (context.read<MainWidgetsBloc>().mainWidgets == null ||
                      context
                              .read<MainWidgetsBloc>()
                              .mainWidgets
                              .purposes
                              .length >=
                          3) {
                    return;
                  }

                  showModalWidgetPurposes(context, (p) {
                    Navigator.pop(context);
                    context
                        .read<MainWidgetsBloc>()
                        .add(AddPurposeWidgetEvent(purpose: p));
                  });
                },
              ),
            ),
            SizedBox(height: 200.h)
          ],
        ),
      ),
    );
  }

  // void func() {
  //   if (events.length < 3) {
  //     // events.add(Events(name: 'name', description: description, datetime: datetime));
  //     setState(() {});
  //   }
  //   // print('object ${events.length}');
  // }

  void delete(int index) {
    events.removeAt(index);
    setState(() {});
    print('event length ${events.length}');
  }

  Widget photoMini(String? path) {
    return Stack(
      children: [
        if (path != null && path.trim() != '')
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(15.r),
            ),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: CachedNetworkImage(
                imageUrl: Config.url.url + path,
                placeholder: (_, __) {
                  return Container();
                },
                fit: BoxFit.cover,
                width: 45.h,
                height: 45.h,
                fadeInCurve: Curves.easeInOutQuint,
                fadeOutCurve: Curves.easeInOutQuint,
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        Container(
          width: 45.h,
          height: 45.h,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15.r),
            ),
            border: Border.all(width: 2.h, color: Colors.white),
            image: path == null || path.trim() == ''
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: getImage(path),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget photo(String? path) {
    return Stack(
      children: [
        if (path != null && path.trim() != '')
          ClipRRect(
            borderRadius: _borderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: _borderRadius,
              ),
              child: CachedNetworkImage(
                imageUrl: Config.url.url + path,
                fit: BoxFit.cover,
                fadeInCurve: Curves.easeInOutQuint,
                fadeOutCurve: Curves.easeInOutQuint,
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 300),
                width: 134.h,
                height: 134.h,
              ),
            ),
          ),
        Container(
          width: 134.h,
          height: 134.h,
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            border: Border.all(width: 5.h, color: Colors.white),
            image: path == null || path.trim() == ''
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: getImage(path),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  ImageProvider<Object> getImage(String? path) {
    if (path != null && path.trim() != '') {
      return NetworkImage(Config.url.url + path);
    }
    return AssetImage('assets/images/avatar_none.png');
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _buildCurrentUser() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        photo(sl<AuthConfig>().user == null
            ? null
            : sl<AuthConfig>().user!.me.photo),
        SizedBox(height: 10.h),
        TextWidget(
          text: sl<AuthConfig>().user == null
              ? ''
              : sl<AuthConfig>().user!.me.username,
        )
      ],
    );
  }

  Widget _buildLoveUser() {
    return Column(
      children: [
        photo(
            sl<AuthConfig>().user == null || sl<AuthConfig>().user!.love == null
                ? null
                : sl<AuthConfig>().user!.love!.photo),
        SizedBox(height: 10.h),
        TextWidget(
          text: sl<AuthConfig>().user == null ||
                  sl<AuthConfig>().user?.love == null
              ? ''
              : sl<AuthConfig>().user!.love!.username,
        )
      ],
    );
  }
}
