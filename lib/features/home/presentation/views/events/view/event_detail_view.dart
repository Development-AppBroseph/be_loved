import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/helpers/text_size.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/core/widgets/texts/important_text_widget.dart';
import 'package:be_loved/features/home/data/models/home/hashTag.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/add_photo_card.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/add_tag_icon.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/detail_tag_select_modal.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/event_detail_timer.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/event_settings_modal.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/photo_settings_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_widget.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_first.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';



class EventDetailView extends StatefulWidget {
  final VoidCallback prevPage;
  const EventDetailView({Key? key, required this.prevPage}) : super(key: key);

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  ScrollController scrollController = ScrollController();

  GlobalKey tagAddIconKey = GlobalKey();
  GlobalKey photoSettingsKey = GlobalKey();
  GlobalKey addPhotoSettingsKey = GlobalKey();
  GlobalKey eventSettingsKey = GlobalKey();

  EventEntity? event;

  showTagModal() async {
    tagSelectModal(
      context,
      getWidgetPosition(tagAddIconKey),
      event!,
      (eventFrom){
        context.read<EventsBloc>().add(EventEditEvent(eventEntity: eventFrom));
      }
    );
  }



  showPhotoSettingsModal(bool editPhoto) async {
    scrollToBottom();
    Future.delayed(Duration(milliseconds: 300), (){
      photoSettingsModal(
        context,
        getWidgetPosition(editPhoto ? photoSettingsKey : addPhotoSettingsKey),
        editPhoto,
        () {
          Navigator.pop(context);
          context.read<EventsBloc>().add(EventEditEvent(eventEntity: event!, isDeletePhoto: true));
        },
        (f){
          Navigator.pop(context);
          showLoaderWrapper(context);
          context.read<EventsBloc>().add(EventEditEvent(eventEntity: event!, photo: f));
        }
      );
    });
  }




  showEventSettingsModal() async {
    eventSettingsModal(
      context,
      getWidgetPosition(eventSettingsKey),
      event!.important,
      (){
        Navigator.pop(context);
        showModalCreateEvent(context, (){}, event);
      },
      (){
        Navigator.pop(context);
        context.read<EventsBloc>().add(EventDeleteEvent(ids: [event!.id]));
        widget.prevPage();
      },
      (){
        Navigator.pop(context);
        if(context.read<EventsBloc>().eventsInHome.length != 3 && !context.read<EventsBloc>().eventsInHome.any((element) => element.id == event!.id)){
          context.read<EventsBloc>().add(EventChangeToHomeEvent(
            eventEntity: event!, 
            position: context.read<EventsBloc>().eventsInHome.isEmpty ? 0 : (context.read<EventsBloc>().eventsInHome.length+1)
          ));
        }
      }
    );
  }



  void scrollToBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear
    );
  }



  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    event = context.read<EventsBloc>().events.where((element) => element.id == context.read<EventsBloc>().eventDetailSelectedId).first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EventsBloc eventsBloc = context.read<EventsBloc>();
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColorGrey,
      body: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if(state is EventErrorState){
            Loader.hide();
            showAlertToast(state.message);
          }
          if(state is EventInternetErrorState){
            Loader.hide();
            showAlertToast('Проверьте соединение с интернетом!');
          }
          if(state is GotSuccessEventsState){
            setState(() {});
          }
          if(state is EventAddedState){
            Loader.hide();
            setState(() {
              event = context.read<EventsBloc>().events.where((element) => element.id == context.read<EventsBloc>().eventDetailSelectedId).first;
            });
          }
        },
        builder:(context, state) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 75.h, bottom: 46.h, left: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => widget.prevPage(),
                          child: SizedBox(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 28,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: Text(
                                    'Назад',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 20.sp,
                                      color: const Color(0xff2C2C2E),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AddTagIcon(
                          key: tagAddIconKey,
                          onTap: (){
                            showTagModal();
                          },
                        )
                      ],
                    ),
                  ),
                  CupertinoCard(
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                    margin: EdgeInsets.zero,
                    radius: BorderRadius.circular(40.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Предстоящее событие', style: TextStyles(context).grey_15_w700,),
                            Text(
                              DateFormat('dd.MM.yy').format(DateTime.now().add(Duration(days: int.parse(event!.datetimeString)))),
                              style: TextStyle(
                                color: getColorFromDays(event!.datetimeString, event!.important),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 33.h,),
                        Text(
                          event!.title,
                          style: TextStyle(
                              color: const Color.fromRGBO(
                                  23, 23, 23, 1),
                              fontSize: homeWidgetTextSize(eventsBloc.events.first.title).sp,
                              fontWeight: FontWeight.w800,
                              height: 1),
                        ),
                        SizedBox(height: 15.h,),
                        Text(event!.description, style: TextStyles(context).grey_15_w700,),
                        SizedBox(height: 38.h,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            !event!.important
                              ? Text(
                                'Добавил(а): ${event!.eventCreator.username}',
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  color: const Color(0xff969696),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ) 
                              : ImportantTextWidget(),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  SvgImg.favorite,
                                  height: 22.5.h,
                                ),
                                SizedBox(width: 15.w,),
                                GestureDetector(
                                  onTap: showEventSettingsModal,
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    height: 22.5.h,
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    child: SvgPicture.asset(
                                      SvgImg.dots,
                                      key: eventSettingsKey,
                                      height: 7.h,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 8.h,),
                      ],
                    )
                  ),
                  SizedBox(height: 15.h,),
                  SizedBox(
                    height: 115.h,
                    width: 378.w,
                    child: EventDetailTimer(eventEntity: event!,)
                  ),
                  SizedBox(height: 15.h,),
                  event!.photo != null
                  ? CupertinoCard(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    radius: BorderRadius.circular(60.r),
                    child: Stack(
                      children: [
                        Image.network(
                          event!.photo!,
                          height: MediaQuery.of(context).size.width-80.w,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 21.h,
                          left: 24.h,
                          child: Text('Прикреплённое фото', style: TextStyles(context).white_25_w800,)
                        ),
                        Positioned(
                          bottom: 30.h,
                          right: 24.w,
                          child: GestureDetector(
                            onTap: (){
                              showPhotoSettingsModal(true);
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              width: 50.w,
                              height: 27,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                SvgImg.dots,
                                height: 7.h,
                                color: Colors.white,
                                key: photoSettingsKey,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                  : AddPhotoCard(
                    onTap: (){
                      showPhotoSettingsModal(false);
                    },
                    keyAdd: addPhotoSettingsKey,
                  ),
                  SizedBox(
                    height: 140.h,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
