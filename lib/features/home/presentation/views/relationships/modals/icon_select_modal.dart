import 'package:be_loved/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

void iconSelectModal(BuildContext context, Offset offset,
        Function(int index) onTap, int iconIndex) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        bool isInit = false;
        bool isInitOpacity = false;
        ScrollController scrollController = ScrollController(
            initialScrollOffset: iconIndex == 0 ? 0 : (57.h * (iconIndex - 1)));
        return AlertDialog(
          insetPadding:
              EdgeInsets.only(top: offset.dy - 70.h, left: offset.dx - 14.w),
          alignment: Alignment.topLeft,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconColor: Colors.transparent,
          content: Container(
            height: 140.h,
            child: StatefulBuilder(builder: ((context, setState) {
              initWidgets() {
                if (isInit == false) {
                  setState(() {
                    isInit = true;
                  });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    setState(() {
                      isInitOpacity = true;
                    });
                  });
                }
              }

              WidgetsBinding.instance
                  .addPostFrameCallback((_) => initWidgets());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20.h,
                              color: Colors.black.withOpacity(0.1))
                        ],
                        borderRadius: BorderRadius.circular(15.r)),
                    height: isInit ? 140.h : 100.h,
                    width: 57.w,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: isInitOpacity ? 1 : 0,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: 31,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              onTap(index);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 57.h, 
                              child: index == 15
                                  ? Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      child: SvgPicture.asset(
                                        'assets/icons/no_icon.svg',
                                        height: 28.h,
                                      ))
                                  : Container(
                                      color: Colors.white,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 13.w),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Image.asset(Img.smile),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            })),
          ),
        );
      },
    );
