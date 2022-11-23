import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/data/models/home/hashTag.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/all_events.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/show_create_tag_modal.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/tags_list_block.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/user_event_item.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/user_events.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_modal.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EventDetailView extends StatefulWidget {
  final VoidCallback prevPage;
  const EventDetailView({Key? key, required this.prevPage}) : super(key: key);

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
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
      backgroundColor: ColorStyles.backgroundColorGrey,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 75.h, bottom: 54.h, left: 35.w, right: 25.w),
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
                CupertinoCard(
                  color: ColorStyles.greyColor,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  radius: BorderRadius.circular(20.r),
                  child: Stack(
                    children: [
                        Positioned.fill(
                          child: CupertinoCard(
                            elevation: 0,
                            margin: EdgeInsets.all(1.w),
                            radius: BorderRadius.circular(17.r),
                            color: ColorStyles.backgroundColorGrey,
                          ),
                        ),
                      Container(
                        height: 38.h,
                        width: 80.w,
                        child: Center(
                            child: Transform.rotate(
                                  angle: pi / 4,
                                  child:
                                      SvgPicture.asset(SvgImg.add, height: 14.h,))
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(
            height: 30.h,
          )
        ],
      ),
    );
  }
}
