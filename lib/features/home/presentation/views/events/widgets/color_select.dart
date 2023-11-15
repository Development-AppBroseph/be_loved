import 'package:be_loved/constants/main_config_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

enum WhichScroll { top, down, middle }

void colorSelectModal(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
  WhichScroll whichScroll,
  int iconIndex,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        bool isInit = false;
        // int load = 0;
        bool isInitOpacity = false;
        ScrollController scrollController = ScrollController(
            initialScrollOffset: iconIndex == 0 ? 0 : (57.h * (iconIndex - 1)));
        // if (load == 0) {
        //   load = 1;
        //   Future.delayed(const Duration(milliseconds: 300), () {
        //     scrollController.animateTo(
        //       whichScroll == WhichScroll.down
        //           ? 100
        //           : whichScroll == WhichScroll.middle
        //               ? 0
        //               : -20,
        //       duration: const Duration(milliseconds: 500),
        //       curve: Curves.easeInOutQuint,
        //     );
        //   });
        // }
        return AlertDialog(
          insetPadding:
              EdgeInsets.only(top: offset.dy - 58.h, left: offset.dx + 1.w),
          alignment: Alignment.topLeft,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // iconColor: Colors.transparent,
          content: SizedBox(
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
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(15.r)),
                    height: isInit ? 140.h : 100.h,
                    width: 57.w,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isInitOpacity ? 1 : 0,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        controller: scrollController,
                        itemCount: MainConfigApp.tagColors.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              onTap(index);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 57.h,
                              child: Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  MainConfigApp.tagColors[index].assetPath,
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
