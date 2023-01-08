import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/helpers/text_size.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/texts/important_text_widget.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/old_events/old_events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/event_settings_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_modal.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../../../constants/texts/text_styles.dart';

class EventPageInArchive extends StatefulWidget {
  final Function(int id) nextPage;
  final PageController pageController;
  const EventPageInArchive({Key? key, required this.pageController, required this.nextPage})
      : super(key: key);

  @override
  State<EventPageInArchive> createState() => _EventPageInArchiveState();
}

class _EventPageInArchiveState extends State<EventPageInArchive> {




  showEventSettingsModal(EventEntity event, GlobalKey eventSettingsKey) async {
    eventSettingsModal(
      context,
      getWidgetPosition(eventSettingsKey),
      event.important,
      (){
        Navigator.pop(context);
        showModalCreateEvent(
          context, 
          (){
          }, 
          event
        );
      },
      (){
        Navigator.pop(context);
        context.read<OldEventsBloc>().add(DeleteOldEventEvent(id: event.id));
      },
      (){
      },
      isOld: true
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OldEventsBloc oldEventsBloc = context.read<OldEventsBloc>();
    if(oldEventsBloc.state is OldEventInitialState){
      oldEventsBloc.add(GetOldEventsEvent());
    }
    
  }





  @override
  Widget build(BuildContext context) {
    OldEventsBloc oldEventsBloc = context.read<OldEventsBloc>();
    return SingleChildScrollView(
      child: BlocConsumer<OldEventsBloc, OldEventsState>(
        listener: (context, state) {
          if(state is OldEventErrorState){
            Loader.hide();
            showAlertToast(state.message);
          }
          if(state is OldEventInternetErrorState){
            Loader.hide();
            showAlertToast('Проверьте соединение с интернетом!');
          }
          if(state is OldEventDeletedState){
            Loader.hide();
            oldEventsBloc.add(GetOldEventsEvent());
          }
        },
        builder: (context, state) {
          if(state is OldEventInitialState || state is OldEventLoadingState){
            return Container();
          }
          return  Column(
            children: [
              ...List.generate(
                oldEventsBloc.events.length,
                (index) => GestureDetector(
                  onTap: (){
                    print('DDD: ${oldEventsBloc.events[index]}');
                    widget.nextPage(oldEventsBloc.events[index].id);
                    oldEventsBloc.selectedEvent = oldEventsBloc.events[index];
                    // widget.nextPage(context.read<EventsBloc>().events.isNotEmpty ? context.read<EventsBloc>().events.first.id : 1);
                  },
                  child: _buildEvent(context, oldEventsBloc.events[index], GlobalKey())
                ),
              )
            ]
          );
        }
      ),
    );
  }



  Widget _buildEvent(BuildContext context, EventEntity event, GlobalKey eventSettingsKey){
    return CupertinoCard(
      elevation: 0,
      color: ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      margin: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 20.h),
      radius: BorderRadius.circular(40.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Прошедшее событие', style: TextStyles(context).grey_15_w700,),
              Text(
                // "",
                DateFormat('dd.MM.yy').format(DateTime.now().add(Duration(days: int.parse(event.datetimeString)))),
                style: TextStyle(
                  color: getColorFromDays(event.datetimeString, event.important),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 33.h,),
          Text(
            event.title,
            style: TextStyle(
                color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
                fontSize: homeWidgetTextSize(event.title).sp,
                fontWeight: FontWeight.w800,
                height: 1),
          ),
          SizedBox(height: 15.h,),
          Text(event.description, style: TextStyles(context).grey_15_w700,),
          SizedBox(height: 38.h,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              !event.important
                ? Text(
                  'Добавил(а): ${event.eventCreator.username}',
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
                  SizedBox(width: 15.w,),
                  GestureDetector(
                    onTap: (){
                      showEventSettingsModal(event, eventSettingsKey);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: 22.5.h,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: SvgPicture.asset(
                        SvgImg.dots,
                        key: eventSettingsKey,
                        height: 7.h,
                        color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
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
    );
  }
}
