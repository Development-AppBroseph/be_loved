import 'dart:async';
import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/helpers/events_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/core/widgets/buttons/new_event_btn.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/main_page/widgets/events_list_widget.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/tags_list_block.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/widgets/levels_widgets.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ships_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/relation_start_date_widget.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/text_widget.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:be_loved/features/profile/presentation/views/parting_view.dart';
import 'package:be_loved/features/profile/presentation/widget/decor/sliding_background_card.dart';
import 'package:be_loved/features/theme/bloc/theme_bloc.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RelationShipsSettingsPage extends StatefulWidget {
  final VoidCallback prevPage;
  final Function() toStaticsPage;
  final Function() toAllEvents;
  const RelationShipsSettingsPage(
      {Key? key,
      required this.toAllEvents,
      required this.prevPage,
      required this.toStaticsPage})
      : super(key: key);

  @override
  State<RelationShipsSettingsPage> createState() =>
      _RelationShipsSettingsPageState();
}

class _RelationShipsSettingsPageState extends State<RelationShipsSettingsPage>
    with AutomaticKeepAliveClientMixin {
  final int maxLength = 18;
  static const _imageSize = 30.0;
  String text = '';
  final _streamController = StreamController<int>();

  final TextEditingController _controller = TextEditingController(
      text: sl<AuthConfig>().user == null ? '' : sl<AuthConfig>().user!.name);
  FocusNode f1 = FocusNode();

  ScrollController controller = ScrollController();

  DateTime datetime =
      sl<AuthConfig>().user == null || sl<AuthConfig>().user!.date == null
          ? DateTime.now()
          : DateFormat("yyyy-MM-dd")
              .parse(sl<AuthConfig>().user!.date!, true)
              .toLocal();

  setNewRelationDate() async {
    showLoaderWrapper(context);

    print('OLD DATE: ${sl<AuthConfig>().user!.date}');
    sl<AuthConfig>().user!.date = DateFormat('yyyy-MM-dd').format(datetime);
    print('NEW DATE: ${sl<AuthConfig>().user!.date}');
    context.read<ProfileBloc>().add(EditRelationNameEvent(
        name: sl<AuthConfig>().user!.name ?? '',
        date: sl<AuthConfig>().user!.date));
    await MySharedPrefs().setBoolYears(false);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {});
    });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(() {});
    _streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

  Widget content(BuildContext context) {
    EventsBloc eventsBloc = context.read<EventsBloc>();
    print('RELREL: ${sl<AuthConfig>().user!.relationId}');

    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, _) {
      return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              // context.read<ThemeBloc>().add(SetThemeEvent(index: state.user.theme == 'dark' ? 1 : 0));
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
                  SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    // physics: const AlwaysScrollableScrollPhysics(
                    //     parent: ClampingScrollPhysics()),
                    child: GestureDetector(
                      onTap: () {
                        // f1.unfocus();
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              // SlidingBackgroundCard(),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 25.w,
                                      left: 25.w,
                                      top: 35.h +
                                          MediaQuery.of(context).padding.top,
                                    ),
                                    child: GestureDetector(
                                      onTap: () => widget.prevPage(),
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            // const Icon(
                                            //   Icons.arrow_back_ios_new_rounded,
                                            //   size: 28,
                                            // ),
                                            SvgPicture.asset(
                                              SvgImg.back,
                                              height: 26.32.h,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Text(
                                              'Назад',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 20.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 42.h),
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
                                                        TextCapitalization
                                                            .words,
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
                                                            baseOffset:
                                                                maxLength,
                                                            extentOffset:
                                                                maxLength,
                                                            affinity:
                                                                TextAffinity
                                                                    .upstream,
                                                            isDirectional:
                                                                false,
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
                                                        TextAlignVertical
                                                            .center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                        .add(EditRelationNameEvent(
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
                                            ? _buildLoveUser()
                                            : _buildCurrentUser(),
                                        const Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(top: 13.h),
                                          child: SizedBox(
                                            height: 108.h,
                                            width: 108.w,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  SvgImg.heart,
                                                  height: 59.h,
                                                  width: 70.w,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        sl<AuthConfig>().user!.fromYou ?? true
                                            ? _buildCurrentUser()
                                            : _buildLoveUser()
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 26.h),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: ClrStyle.backgroundColor[
                                          sl<AuthConfig>().idx],
                                    ),
                                    child: Column(
                                      children: [
                                        RelationStartDateWidget(
                                          onTapEditDate: () {
                                            // controller.animateTo(controller.position.pixels+100.h, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuint);
                                          },
                                          onTapStats: widget.toStaticsPage,
                                          onChangeDate: (newDate) {
                                            setState(() {
                                              datetime = newDate;
                                            });
                                            setNewRelationDate();
                                          },
                                          datetime: datetime,
                                        ),
                                        SizedBox(height: 15.h),
                                        GestureDetector(
                                          onTap: () =>
                                              showMaterialModalBottomSheet(
                                            context: context,
                                            animationCurve:
                                                Curves.easeInOutQuint,
                                            duration: const Duration(
                                              milliseconds: 600,
                                            ),
                                            backgroundColor: Colors.transparent,
                                            builder: (context) {
                                              return LevelsWidget(
                                                dateTime: datetime,
                                              );
                                            },
                                          ),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 65.h,
                                            child: CupertinoCard(
                                              radius:
                                                  BorderRadius.circular(40.r),
                                              color: ClrStyle.whiteTo17[
                                                  sl<AuthConfig>().idx],
                                              elevation: 0,
                                              margin: EdgeInsets.zero,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25.w,
                                                  vertical: 20.h),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    SvgImg.heart,
                                                    color: ColorStyles.redColor,
                                                    width: 27.w,
                                                  ),
                                                  SizedBox(
                                                    width: 18.w,
                                                  ),
                                                  Text(
                                                    'Уровни отношений',
                                                    style: TextStyles(context)
                                                        .black_18_w800,
                                                  ),
                                                  const Spacer(),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: ClrStyle
                                                            .black17ToWhite[
                                                        sl<AuthConfig>().idx],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        SizedBox(
                                          width: double.infinity,
                                          child: CupertinoCard(
                                            radius: BorderRadius.circular(40.r),
                                            color: ClrStyle.whiteTo17[
                                                sl<AuthConfig>().idx],
                                            elevation: 0,
                                            margin: EdgeInsets.zero,
                                            padding: EdgeInsets.only(
                                                top: 25.h, bottom: 50.h),
                                            child: Column(
                                              children: [
                                                TagsListBlock(),
                                                SizedBox(height: 25.h),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 25.w),
                                                  child: GestureDetector(
                                                    onTap: widget.toAllEvents,
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                'Предстоящие события',
                                                                style: TextStyles(
                                                                        context)
                                                                    .black_20_w700),
                                                            SizedBox(
                                                                height: 8.h),
                                                            Text(
                                                                countEventsText(
                                                                    eventsBloc
                                                                        .eventsSorted),
                                                                style: TextStyles(
                                                                        context)
                                                                    .grey_15_w700),
                                                          ],
                                                        ),
                                                        const Spacer(),
                                                        SizedBox(
                                                          height: 45.w,
                                                          width: 45.w,
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                child: Transform
                                                                    .rotate(
                                                                        angle:
                                                                            pi,
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          SvgImg
                                                                              .back,
                                                                          height:
                                                                              20.41.h,
                                                                          width:
                                                                              11.37.h,
                                                                          color:
                                                                              ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                                                                        )),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 17.h),
                                                BlocConsumer<EventsBloc,
                                                        EventsState>(
                                                    listener: (context, state) {
                                                  if (state
                                                      is EventErrorState) {
                                                    showAlertToast(
                                                        state.message);
                                                  }
                                                  if (state
                                                      is EventInternetErrorState) {
                                                    showAlertToast(
                                                        'Проверьте соединение с интернетом!');
                                                  }
                                                  if (state
                                                          is EventAddedState ||
                                                      state
                                                          is GotSuccessEventsState) {
                                                    setState(() {});
                                                  }
                                                }, builder: (context, state) {
                                                  if (state
                                                      is EventLoadingState) {
                                                    return Container();
                                                  }
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    25.w),
                                                        child: Container(
                                                          height: 1,
                                                          color: ColorStyles
                                                              .greyColor,
                                                        ),
                                                      ),
                                                      SizedBox(height: 25.h),
                                                      EventsListWidget(
                                                          events: eventsBloc
                                                              .eventsSorted,
                                                          onTap: (id) {}),
                                                    ],
                                                  );
                                                }),
                                                SizedBox(height: 35.h),
                                                NewEventBtn(
                                                  onTap: () =>
                                                      showModalCreateEvent(
                                                          context, () {
                                                    Navigator.pop(context);
                                                  }),
                                                  isActive: !(eventsBloc
                                                          .events.length >=
                                                      30),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //CAROUSEL

                                  //EVENTS
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: CustomAnimationButton(
                              text: 'Зажми, чтобы расстаться',
                              // color: ColorStyles.redColor,
                              red: true,
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            PartingView()));
                              },
                            ),
                          ),
                          SizedBox(
                            height: 31.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }));
    });
  }

  Widget photo(String? path) {
    return Stack(
      children: [
        if (path != null && path.trim() != '')
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(38.r),
            ),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
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
            borderRadius: BorderRadius.all(
              Radius.circular(38.r),
            ),
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
    return const AssetImage('assets/images/avatar_none.png');
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
