import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


void iconSelectModal(BuildContext context, Offset offset, Function(int index) onTap, int iconIndex) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        ScrollController scrollController = ScrollController(initialScrollOffset: iconIndex == 0 ? 0 : (54.h*iconIndex-126.h));
        return AlertDialog(
          insetPadding: EdgeInsets.only(top: offset.dy-70.h, left: offset.dx-14.w),
            alignment: Alignment.topLeft,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20.h,
                        color: Colors.black.withOpacity(0.1)
                      )
                    ],
                    borderRadius: BorderRadius.circular(15.r)
                  ),
                  height: 140.h,
                  width: 57.w,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    controller: scrollController,
                    itemCount: 31,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          onTap(index);
                        },
                        child: Padding(
                          padding: EdgeInsets
                                  .symmetric(
                              vertical: 12.h),
                          child: index == 15
                          ? SvgPicture.asset('assets/icons/no_icon.svg', height: 28.h,)
                          : Text(
                            '😎',
                            style: TextStyle(fontSize: 20.sp, fontFamily: 'Inter', fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          )
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        );
      },
    );