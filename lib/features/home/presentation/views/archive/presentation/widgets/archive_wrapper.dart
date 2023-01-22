import 'dart:async';
import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/option_black_btn.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/memory_mini_info_card.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../modals/add_file/add_file_modal.dart';

class ArchiveWrapper extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;
  final Function(int index)? onChangePage;
  final int currentIndex;
  ArchiveWrapper(
      {required this.currentIndex,
      required this.child,
      required this.scrollController,
      this.onChangePage});
  final streamControllerPage = StreamController<int>();

  List<String> data = [
    'Моменты',
    'Галерея',
    'Альбомы',
    'События',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ClrStyle.backToBlack17[sl<AuthConfig>().idx],
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: 25.w,
                    right: 25.w,
                    top: 45.h + MediaQuery.of(context).padding.top,
                    bottom: 22.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MemoryMiniInfoCard(),
                    _buildAddBtn(context, () {
                      print('add');
                      if(context.read<ArchiveBloc>().memoryEntity != null && !context.read<ArchiveBloc>().memoryEntity!.fullFilled()){
                        showModalAddFile(context, () {});
                      }
                    })
                  ],
                )),
            SizedBox(
              height: 38.w,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                        right: 15.w, left: index == 0 ? 25.w : 0),
                    height: 38.h,
                    child: GestureDetector(
                      onTap: () {
                        if (onChangePage != null) {
                          onChangePage!(index);
                        }
                      },
                      child: CupertinoCard(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        color: index == currentIndex
                            ? ColorStyles.blackColor
                            : Colors.white,
                        radius: BorderRadius.circular(20.r),
                        child: Center(
                            child: Text(data[index],
                                style: TextStyles(context)
                                    .white_18_w800
                                    .copyWith(
                                        color: index == currentIndex
                                            ? Colors.white
                                            : ColorStyles.greyColor))),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            child
          ],
        ),
      ));
  }

  Widget _buildAddBtn(BuildContext context, Function() tap) {
    return GestureDetector(
      onTap: tap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: 38.h,
        width: 65.w,
        child: CupertinoCard(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: ColorStyles.primarySwath,
          radius: BorderRadius.circular(20.r),
          child: Center(
              child: Transform.rotate(
                  angle: pi / 4,
                  child: SvgPicture.asset(
                    SvgImg.add,
                    height: 16.h,
                    color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                  ))),
        ),
      ),
    );
  }
}
