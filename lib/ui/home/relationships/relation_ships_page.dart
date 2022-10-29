import 'dart:async';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:be_loved/ui/home/relationships/widgets/home_info_first.dart';
import 'package:be_loved/ui/home/relationships/widgets/home_info_second.dart';
import 'package:be_loved/widgets/buttons/custom_add_animation_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RelationShipsPage extends StatefulWidget {
  final VoidCallback nextPage;
  const RelationShipsPage({Key? key, required this.nextPage}) : super(key: key);

  @override
  State<RelationShipsPage> createState() => _RelationShipsPageState();
}

class _RelationShipsPageState extends State<RelationShipsPage> {
  final _streamController = StreamController<int>();
  final _streamControllerCarousel = StreamController<double>();

  ScrollController scrollController = ScrollController();

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
                      SizedBox(
                        height: 5.57.sp,
                        width: 33.43,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              margin: EdgeInsets.only(left: 5.57.sp),
                              height: 5.57.sp,
                              width: 5.57.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.5),
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 35.h),
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
                          Text('Олег', style: style3.copyWith(fontSize: 25.sp))
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(top: 37.h, bottom: 39.h),
                        child: SvgPicture.asset('assets/icons/heart.svg'),
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
                                  child: HomeInfoFirst(),
                                ),
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
                            height: data >= 1 ? 253.h : (data * 138.h + 115.h),
                          ));
                    }),
                SizedBox(height: 27.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: const CustomAddAnimationButton(),
                ),
              ],
            ),
          );
        });
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
        image: DecorationImage(
          image: AssetImage('assets/images/avatar_none.png'),
          
        )
      ),
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 45.h,
          height: 45.h,
          child: Material(
            color: Colors.white,
            shape: SquircleBorder(
              radius: BorderRadius.all(
                Radius.circular(30.r),
              ),
            ),
            clipBehavior: Clip.hardEdge,
          ),
        ),
        SizedBox(
          width: 42.h,
          height: 42.h,
          child: Material(
            color: const Color.fromRGBO(150, 150, 150, 1),
            shape: SquircleBorder(
              radius: BorderRadius.all(
                Radius.circular(30.r),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: EdgeInsets.all(13.h),
              child: SvgPicture.asset(
                'assets/icons/camera.svg',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget photo() {
    
    return Container(
      width: 135.h,
      height: 135.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(40.r),
        ),
        border: Border.all(width: 5.h, color: Colors.white),
        image: DecorationImage(
          image: AssetImage('assets/images/avatar_none.png'),
          
        )
      ),
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 135.h,
          height: 135.h,
          child: GestureDetector(
            child: Material(
              color: Colors.white,
              shape: SquircleBorder(
                radius: BorderRadius.all(
                  Radius.circular(80.r),
                ),
              ),
              clipBehavior: Clip.hardEdge,
            ),
          ),
        ),
        SizedBox(
          width: 127.h,
          height: 127.h,
          child: GestureDetector(
            child: Material(
              color: const Color.fromRGBO(150, 150, 150, 1),
              shape: SquircleBorder(
                radius: BorderRadius.all(
                  Radius.circular(80.r),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: EdgeInsets.all(43.h),
                child: SvgPicture.asset(
                  'assets/icons/camera.svg',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
