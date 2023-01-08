import 'dart:async';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/helpers/events.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_first.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_second.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/text_widget.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:be_loved/features/profile/presentation/widget/decor/sliding_background_card.dart';
import 'package:be_loved/features/profile/presentation/widget/main_file/parametrs_user_bottomsheet.dart';
import 'package:be_loved/core/widgets/buttons/custom_add_animation_button.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_item_relationships.dart';
import 'package:be_loved/features/theme/bloc/theme_bloc.dart';
import 'package:be_loved/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'modals/add_event_modal.dart';
import 'modals/create_event_modal.dart';

class RelationShipsPage extends StatefulWidget {
  final VoidCallback nextPage;
  final Function(int id) toDetailPage;
  final Function() toRelationSettingsPage;
  const RelationShipsPage({Key? key, required this.nextPage, required this.toDetailPage, required this.toRelationSettingsPage}) : super(key: key);

  @override
  State<RelationShipsPage> createState() => _RelationShipsPageState();
}

class _RelationShipsPageState extends State<RelationShipsPage>
    with AutomaticKeepAliveClientMixin {
  final int maxLength = 18;
  String text = '';
  final _streamController = StreamController<int>();
  final _streamControllerCarousel = StreamController<double>();

  final TextEditingController _controller = TextEditingController(
      text: sl<AuthConfig>().user == null ? '' : sl<AuthConfig>().user!.name);
  FocusNode f1 = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
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
    _controller.removeListener(() {});
    _streamController.close();
    _streamControllerCarousel.close();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        content(context),
      ],
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
        
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is GetUserSuccess) {
              if(context.read<ThemeBloc>().state is ThemeInitialState){
                context.read<ThemeBloc>().add(SetThemeEvent(index: state.user.theme == 'dark' ? 1 : 0));
              }
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
              return RefreshIndicator(
                color: ColorStyles.accentColor,
                onRefresh: () async {
                  showLoaderWrapper(context);
                  context.read<AuthBloc>().add(GetUser(isJustRefresh: true));
                  return;
                },
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics()),
                  child: GestureDetector(
                    onTap: () {
                      // f1.unfocus();
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SlidingBackgroundCard(),
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
                                            photoMini(sl<AuthConfig>().user == null
                                                ? null
                                                : sl<AuthConfig>().user!.me.photo),
                                            SizedBox(width: 12.w),
                                            Text(
                                              sl<AuthConfig>().user == null
                                                  ? ''
                                                  : sl<AuthConfig>().user!.me.username,
                                              style: style1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => showMaterialModalBottomSheet(
                                          animationCurve: Curves.easeInOutQuint,
                                          duration: const Duration(milliseconds: 600),
                                          context: context,
                                          // shape: RoundedRectangleBorder(
                                          //   borderRadius: BorderRadius.vertical(
                                          //     top: Radius.circular(50.r),
                                          //   ),
                                          // ),
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              ParametrsUserBottomsheet(
                                                onRelationSettingsTap: (){
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
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: 3,
                                                  itemBuilder:
                                                      (BuildContext context, index) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.only(left: 5.57.h),
                                                      height: 5.57.h,
                                                      width: 5.57.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
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
                                    if (state is ProfileRelationNameChangedState) {
                                      // Loader.hide();
                                      // showLoaderWrapper(context);
                                      context.read<AuthBloc>().add(GetUser(isJustRefresh: true));
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
                                                      showLoaderWrapper(context);
                                                      context.read<ProfileBloc>().add(
                                                          EditRelationNameEvent(
                                                              name: _controller.text
                                                                  .trim()));
                                                    }
                                                  },
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  onChanged: (value) {
                                                    if (value.length <= maxLength) {
                                                      text = value;
                                                    } else {
                                                      _controller.value =
                                                          TextEditingValue(
                                                        text: text,
                                                        selection: TextSelection(
                                                          baseOffset: maxLength,
                                                          extentOffset: maxLength,
                                                          affinity:
                                                              TextAffinity.upstream,
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
                                                  scrollPadding: EdgeInsets.zero,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(top: 20),
                                                    border: InputBorder.none,
                                                    hintText: f1.hasFocus
                                                        ? " "
                                                        : 'Назовите отношения',
                                                    hintStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30.sp,
                                                      fontWeight: FontWeight.w700,
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
                                                  context.read<ProfileBloc>().add(
                                                      EditRelationNameEvent(
                                                          name:
                                                              _controller.text.trim()));
                                                } else {
                                                  FocusScope.of(context)
                                                      .requestFocus(f1);
                                                }
                                              },
                                              child: _controller.text.isNotEmpty &&
                                                      f1.hasFocus
                                                  ? const Icon(
                                                      Icons.check_rounded,
                                                      color: Colors.white,
                                                    )
                                                  : !f1.hasFocus
                                                      ? SvgPicture.asset(SvgImg.edit)
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
                                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                          ? _buildLoveUser()
                                          : _buildCurrentUser()
                                    ],
                                  ),
                                ),
                                SizedBox(height: 26.h),
                                StreamBuilder<double>(
                                  stream: _streamControllerCarousel.stream,
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
                                        height:
                                            data >= 1 ? 253.h : (data * 138.h + 115.h),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 15.h),
                                BlocConsumer<EventsBloc, EventsState>(
                                    listener: (context, state) {
                                  if (state is EventErrorState) {
                                    showAlertToast(state.message);
                                    if (state.isTokenError) {
                                      print('TOKEN ERROR, LOGOUT...');
                                      context.read<AuthBloc>().add(LogOut(context));
                                    }
                                  }
                                  if (state is EventInternetErrorState) {
                                    showAlertToast(
                                        'Проверьте соединение с интернетом!');
                                  }
                                }, builder: (context, state) {
                                  if (state is EventLoadingState) {
                                    return Container();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                                    child: ReorderableListView.builder(
                                      onReorder: (oldIndex, newIndex) {
                                        context.read<EventsBloc>().add(
                                            EventChangeToHomeEvent(
                                                eventEntity:
                                                    eventsBloc.eventsInHome[oldIndex],
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
                                          key: ValueKey(
                                              '${eventsBloc.eventsInHome[index].id}'),
                                          delete: (i) {
                                            eventsBloc.add(EventChangeToHomeEvent(
                                                eventEntity: null, position: i));
                                          },
                                          index: index,
                                          onDetail:(id) {
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
                                // if (events.isEmpty) SizedBox(height: 15.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                                  child: CustomAddAnimationButton(func: () {
                                    if (eventsBloc.eventsInHome.length < 3) {
                                      if(!eventsBloc.eventsInHome.any((element) => element.id == eventsBloc.events.first.id)){
                                        context.read<EventsBloc>().add(EventChangeToHomeEvent(
                                          eventEntity: eventsBloc.events.first,
                                          position: eventsBloc.eventsInHome.isEmpty ? 0 : eventsBloc.eventsInHome.length+1
                                        ));
                                      }else{
                                        showModalAddEvent(context, () {});
                                      }
                                    }
                                  }),
                                ),
                                SizedBox(height: 200.h)
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          )
        );
      }
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
        // SizedBox(
        //   width: 134.h,
        //   height: 134.h,
        //   child: CupertinoCard(
        //     elevation: 0,
        //     margin: EdgeInsets.zero,
        //     radius: BorderRadius.circular(80.r),
        //     color: Colors.white,
        //   ),
        // ),
        Container(
          width: 134.h,
          height: 134.h,
          decoration: BoxDecoration(
            // color: Colors.white,
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
