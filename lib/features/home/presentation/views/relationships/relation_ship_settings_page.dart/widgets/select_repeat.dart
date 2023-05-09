import 'dart:async';

import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showSelector(
  BuildContext context,
  Offset offset,
  List<Map<String, dynamic>> repeats,
  StreamController<int> controller,
) =>
    showDialog(
        context: context,
        useSafeArea: false,
        barrierColor: Colors.transparent,
        builder: (context) {
          bool isInit = false;
          bool isInitOpacity = false;
          return AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy - 70, left: offset.dx - 15),
            alignment: Alignment.topLeft,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: SizedBox(
              height: 140.h,
              child: StatefulBuilder(
                builder: ((context, setState) {
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
                            color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 20.h,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            borderRadius: BorderRadius.circular(15.r)),
                        height: isInit ? 140.h : 100.h,
                        width: 180.w,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isInitOpacity ? 1 : 0,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            // controller: scrollController,
                            itemCount: repeats.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.sink.add(index);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 57.h,
                                  child: Text(
                                    repeats[index]['repeat'],
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xff969696),
                                      fontWeight: FontWeight.w800,
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
                }),
              ),
            ),
          );
        });
