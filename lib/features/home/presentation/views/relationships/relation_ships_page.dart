import 'dart:async';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_first.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_second.dart';
import 'package:be_loved/features/profile/presentation/widget/main_file/parametrs_user_bottomsheet.dart';
import 'package:be_loved/core/widgets/buttons/custom_add_animation_button.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_item_relationships.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'modals/create_event_modal.dart';

class RelationShipsPage extends StatefulWidget {
  final VoidCallback nextPage;
  const RelationShipsPage({Key? key, required this.nextPage}) : super(key: key);

  @override
  State<RelationShipsPage> createState() => _RelationShipsPageState();
}

class _RelationShipsPageState extends State<RelationShipsPage> {
  final _streamController = StreamController<int>();
  final _streamControllerCarousel = StreamController<double>();

  TextEditingController _controller = TextEditingController();
  FocusNode f1 = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _streamControllerCarousel.close();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        content(),
      ],
    );
  }

  List<Widget> events = [];

  Widget content() {
    TextStyle style1 = TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 15.sp,
        height: 1);
    TextStyle style2 = TextStyle(
        fontWeight: FontWeight.w700,
        color: Colors.white,
        fontSize: 30.sp,
        height: 0.2);
    TextStyle style3 = TextStyle(
        fontWeight: FontWeight.w800, color: Colors.white, fontSize: 18.sp);

    return StreamBuilder<int>(
        stream: _streamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 448.h,
                      color: Colors.black,
                    ),
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
                                    photoMini(),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'Олег Бочко',
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(40.r),
                                    ),
                                  ),
                                  builder: (context) =>
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.8,
                                      child: SingleChildScrollView(
                                        physics: ClampingScrollPhysics(),
                                        child: const ParametrsUserBottomsheet(),
                                      ),
                                    ),
                                ),
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: SizedBox(
                            height: 45.h,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 33.h,
                                    child: TextField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: style2,
                                      controller: _controller,
                                      focusNode: f1,
                                      scrollPadding: EdgeInsets.zero,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Назовите отношения',
                                        hintStyle: style2,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 45.h,
                                  width: 45.h,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context)
                                                .requestFocus(f1);
                                          },
                                          child: SvgPicture.asset(SvgImg.edit)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  photo(),
                                  SizedBox(height: 10.h),
                                  Text('Олег',
                                      style: style3.copyWith(fontSize: 25.sp))
                                ],
                              ),
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
                                        child: HomeInfoFirst()),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 378.w,
                                      height: (data * 138.h + 115.h),
                                      child: HomeInfoSecond(data: data),
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
                        SizedBox(height: 11.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount: events.length,
                            itemBuilder: ((context, index) {
                              return CustomAnimationItemRelationships(
                                // func: func,
                                delete: delete,
                                index: index,
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: CustomAddAnimationButton(func: () {
                            showModalCreateEvent(context, () {
                              Navigator.pop(context);
                              func();
                            });
                          }),
                        ),
                        SizedBox(height: 200.h)
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  void func() {
    if (events.length < 3) {
      events.add(const SizedBox());
      setState(() {});
    }
    // print('object ${events.length}');
  }

  void delete(int index) {
    events.removeAt(index);
    setState(() {});
  }

  Widget photoMini() {
    return Container(
      width: 45.h,
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15.r),
        ),
        border: Border.all(width: 2.h, color: Colors.white),
        image: const DecorationImage(
          image: AssetImage('assets/images/avatar_none.png'),
        ),
      ),
    );
  }

  Widget photo() {
    return Container(
      width: 134.h,
      height: 134.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40.r),
        ),
        border: Border.all(width: 5.h, color: Colors.white),
        image: const DecorationImage(
          image: AssetImage('assets/images/avatar_none.png'),
        ),
      ),
    );
  }
}
