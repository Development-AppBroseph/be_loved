import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/data/models/home/hashTag.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/show_create_tag_modal.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/tags_list_block.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/user_event_item.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/user_events.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_modal.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'tag_modal.dart';

class AllEeventsPage extends StatefulWidget {
  final VoidCallback prevPage;
  final Function(int id) toDetailPage;
  const AllEeventsPage({Key? key, required this.prevPage, required this.toDetailPage}) : super(key: key);

  @override
  State<AllEeventsPage> createState() => _AllEeventsPageState();
}

class _AllEeventsPageState extends State<AllEeventsPage> {
  final PageController _pageController = PageController();
  ScrollController scrollController = ScrollController();

  int countPage = 0;
  List<HashTagData> hashTags = [
    HashTagData(title: 'Важно', type: TypeHashTag.main),
    HashTagData(title: 'Арбуз', type: TypeHashTag.user),
    HashTagData(title: 'Название', type: TypeHashTag.custom),
    HashTagData(type: TypeHashTag.add),
  ];
  bool isSelectedAll = false;
  List<int> selectedEvents = [];
  TextStyle style1 = TextStyle(
      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15.sp);
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EventsBloc eventsBloc = context.read<EventsBloc>();
    return Scaffold(
      backgroundColor: ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 75.h, bottom: 54.h, left: 35.w),
            child: GestureDetector(
              onTap: () => widget.prevPage(),
              child: SizedBox(
                child: Row(
                  children: [
                    // const Icon(
                    //   Icons.arrow_back_ios_new_rounded,
                    //   size: 28,
                    // ),
                    SvgPicture.asset(
                      SvgImg.back,
                      height: 26.32.h,
                      color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.w),
                      child: Text(
                        'Назад',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20.sp,
                          color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 55.h,
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  countPage = value;
                });
              },
              children: [
                Row(
                  children: [
                    Container(
                      height: 55.h,
                      width: 109.w,
                      margin: EdgeInsets.only(left: 25.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: const Color(0xff969696),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${eventsBloc.eventsSorted.length}/30",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff969696),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 25.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              countPage = 1;
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOutQuint);
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: const Color(0xff969696),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  SvgImg.edit,
                                  height: 19.h,
                                  width: 19.w,
                                  color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalCreateEvent(context, () {});
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: const Color(0xff20CB83),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 35,
                                  color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        'Выделено: ${selectedEvents.length} событий',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20.sp,
                          color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    isSelectedAll
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                countPage = 0;
                                _pageController.previousPage(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeInOutQuint);
                              });
                              showLoaderWrapper(context);
                              eventsBloc
                                  .add(EventDeleteEvent(ids: selectedEvents));
                              isSelectedAll = false;
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: const Color(0xffFF1D1D),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  SvgImg.bin,
                                  height: 22.h,
                                  width: 24.w,
                                  color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          countPage = 0;
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOutQuint);

                          selectedEvents.clear();
                          isSelectedAll = false;
                        });
                      },
                      child: Container(
                        height: 55.h,
                        width: 55.w,
                        margin: EdgeInsets.only(right: 25.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: const Color(0xffFF1D1D),
                              width: 1,
                            )),
                        child: Center(
                          child: SvgPicture.asset(
                            SvgImg.add,
                            height: 19.h,
                            width: 19.w,
                            color: const Color(0xffFF1D1D),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 39.h,
          ),
          TagsListBlock(isBlack2C: true,),
          BlocConsumer<EventsBloc, EventsState>(listener: (context, state) {
            if (state is EventErrorState) {
              Loader.hide();
              showAlertToast(state.message);
            }
            if (state is EventInternetErrorState) {
              Loader.hide();
              showAlertToast('Проверьте соединение с интернетом!');
            }
            if (state is EventDeletedState) {
              Loader.hide();
              selectedEvents.clear();
              setState(() {});
            }
            if (state is GotSuccessEventsState) {
              setState(() {});
            }
          }, builder: (context, state) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 39.h),
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  scrollDirection: Axis.vertical,
                  itemCount: eventsBloc.eventsSorted.length,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return UserEventItem(
                      onTap: (){
                        // if(!eventsBloc.eventsSorted[index].important && countPage != 0){
                        if(countPage != 0){
                          showModalCreateEvent(context, (){}, eventsBloc.eventsSorted[index]);
                        }else{
                          widget.toDetailPage(eventsBloc.eventsSorted[index].id);
                        }
                      },
                      editorState: isSelectedAll
                          ? EditorState.groupSelect
                          : countPage == 0
                              ? EditorState.just
                              : EditorState.oneItemDelete,
                      onLongPress: () {
                        setState(() {
                          if (isSelectedAll == false &&
                              countPage == 1 &&
                              !eventsBloc.eventsSorted[index].important) {
                            isSelectedAll = true;
                            selectedEvents
                                .add(eventsBloc.eventsSorted[index].id);
                          }
                        });
                      },
                      onSelect: (val) {
                        setState(() {
                          if (val) {
                            if (!eventsBloc.eventsSorted[index].important) {
                              selectedEvents
                                  .add(eventsBloc.eventsSorted[index].id);
                            }
                          } else {
                            selectedEvents
                                .remove(eventsBloc.eventsSorted[index].id);
                          }
                        });
                      },
                      eventEntity: eventsBloc.eventsSorted[index],
                      isSelected: selectedEvents
                          .contains(eventsBloc.eventsSorted[index].id),
                      onTapDelete: () {
                        if (!eventsBloc.eventsSorted[index].important) {
                          showLoaderWrapper(context);
                          context.read<EventsBloc>().add(EventDeleteEvent(
                              ids: [eventsBloc.eventsSorted[index].id]));
                        }
                      },
                    );
                  },
                ),
              ),
            );
          }),
          SizedBox(
            height: 30.h,
          )
        ],
      ),
    );
  }
}

enum EditorState { just, oneItemDelete, groupSelect }
