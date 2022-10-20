import 'dart:async';

import 'package:be_loved/widgets/buttons/custom_add_animation_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventWidget {
  final bool expanded;
  final Widget widget;

  EventWidget(this.expanded, this.widget);
}

class RelationShipsPage extends StatelessWidget {
  RelationShipsPage({Key? key}) : super(key: key);

  final List<EventWidget> _events = [
    EventWidget(
      false,
      Container(
        width: 376.w,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r), color: Colors.grey),
      ),
    ),
    EventWidget(
      true,
      Container(
        width: 376.w,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r), color: Colors.grey),
      ),
    ),
    EventWidget(
      true,
      Container(
        width: 376.w,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r), color: Colors.grey),
      ),
    ),
    EventWidget(
      true,
      Container(
        width: 376.w,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r), color: Colors.grey),
      ),
    ),
  ];

  final _streamController = StreamController<int>();

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // scrollController.addListener(() {
    //   if (scrollController.offset % 376.w > 350.w) {
    //     print('object ${scrollController.offset % 376.w}');
    //     scrollController.jumpTo(376.w);
    //   }
    // });
    return Stack(
      children: [
        Column(
          children: [
            Expanded(child: Container(color: Colors.black)),
            Expanded(child: Container(color: backgroundColorGrey))
          ],
        ),
        content(),
      ],
    );
  }

  Widget content() {
    TextStyle style1 = TextStyle(
        fontWeight: FontWeight.w700, color: Colors.white, fontSize: 15.sp);
    TextStyle style2 = TextStyle(
        fontWeight: FontWeight.w700, color: Colors.white, fontSize: 30.sp);
    TextStyle style3 = TextStyle(
        fontWeight: FontWeight.w800, color: Colors.white, fontSize: 18.sp);

    return StreamBuilder<int>(
        stream: _streamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.only(top: 64.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    children: [
                      photoMini(),
                      SizedBox(width: 12.w),
                      Text(
                        'Олег Бочко',
                        style: style1,
                      ),
                      const Spacer(),
                      const Icon(Icons.more_horiz, color: Colors.white)
                    ],
                  ),
                ),
                SizedBox(height: 39.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    children: [
                      Text('Назовите отношения', style: style2),
                      const Spacer(),
                      SvgPicture.asset('assets/icons/edit.svg')
                    ],
                  ),
                ),
                SizedBox(height: 33.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          photo(),
                          SizedBox(height: 10.h),
                          Text('Олег', style: style3.copyWith(fontSize: 25.sp))
                        ],
                      ),
                      const Spacer(),
                      SvgPicture.asset('assets/icons/heart.svg'),
                      const Spacer(),
                      Column(
                        children: [
                          photo(),
                          SizedBox(height: 10.h),
                          Text('Екатерина', style: style3)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 26.h),
                AnimatedContainer(
                  height: _events[snapshot.data!].expanded ? 200 : 100,
                  width: double.infinity,
                  duration: const Duration(milliseconds: 500),
                  child: ListView.builder(
                    itemCount: _events.length,
                    padding: const EdgeInsets.only(left: 20),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      // print(index);
                      _streamController.sink.add(index == 1 ? 0 : index);
                      return Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            height: snapshot.data == 0
                                ? 100
                                : index == 0
                                    ? 100
                                    : 200,
                            margin: const EdgeInsets.only(right: 20),
                            child: _events[index].widget,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 27.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: CustomAddAnimationButton(),
                ),
              ],
            ),
          );
        });
  }

  Widget photoMini() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 45.w,
          height: 45.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r), color: Colors.white),
        ),
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r), color: Colors.grey),
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 15,
          ),
        ),
      ],
    );
  }

  Widget photo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 135.w,
          height: 135.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r), color: Colors.white),
        ),
        Container(
          width: 125.w,
          height: 125.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r), color: Colors.grey),
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 45,
          ),
        ),
      ],
    );
  }
}
