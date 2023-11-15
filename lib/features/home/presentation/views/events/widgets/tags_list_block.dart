import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/show_create_tag_modal.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../bloc/tags/tags_bloc.dart';

// ignore: must_be_immutable
class TagsListBlock extends StatelessWidget {
  bool isLeftPadding;
  bool isBlack2C;
  TagsListBlock({this.isLeftPadding = true, this.isBlack2C = false});
  TextStyle style1 = TextStyle(
      color: ColorStyles.white, fontWeight: FontWeight.w800, fontSize: 15.sp);

  @override
  Widget build(BuildContext context) {
    TagsBloc tagsBloc = context.read<TagsBloc>();
    return BlocConsumer<TagsBloc, TagsState>(listener: (context, state) {
      if (state is TagErrorState) {
        Loader.hide();
        showAlertToast(state.message);
      }
      if (state is TagInternetErrorState) {
        Loader.hide();
        showAlertToast('Проверьте соединение с интернетом!');
      }
      if (state is TagAddedState || state is TagDeletedState) {
        Loader.hide();
      }
    }, builder: (context, state) {
      if (state is TagLoadingState) {
        return Container();
      }
      return SizedBox(
        height: 48.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            bool isLast =
                tagsBloc.tags.isEmpty || (tagsBloc.tags.length) == index;
            bool isSelected = !isLast &&
                context.read<EventsBloc>().selectedTag?.id ==
                    tagsBloc.tags[index].id;
            return GestureDetector(
              onTap: () {
                if (!isLast) {
                  context
                      .read<EventsBloc>()
                      .add(SortByTagEvent(tagEntity: tagsBloc.tags[index]));
                } else {
                  showModalCreateTag(context, true);
                }
              },
              onLongPress: () {
                if (!tagsBloc.tags[index].important) {
                  showModalCreateTag(context, isLast, tagsBloc.tags[index]);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: !isLeftPadding && index == 0
                        ? 0
                        : index == 0
                            ? 25.w
                            : 15.w,
                    right: isLast ? 25.w : 0,
                    top: 2.h,
                    bottom: 6.h),
                child: Builder(builder: (context) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutQuint,
                    opacity: isLast
                        ? 1
                        : context.read<EventsBloc>().selectedTag != null &&
                                !isSelected
                            ? 0.5
                            : 1,
                    child: CupertinoCard(
                      color: isLast
                          ? ColorStyles.greyColor
                          : tagsBloc.tags[index].color.color,
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      radius: BorderRadius.circular(20.r),
                      child: Stack(
                        children: [
                          if (isLast)
                            Positioned.fill(
                              child: CupertinoCard(
                                elevation: 0,
                                margin: EdgeInsets.all(1.w),
                                radius: BorderRadius.circular(17.r),
                                color: isBlack2C
                                    ? ClrStyle
                                        .whiteToBlack2C[sl<AuthConfig>().idx]
                                    : ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25.w, vertical: 10.h),
                            child: Center(
                                child: isLast
                                    ? Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.h),
                                        height: 34.h,
                                        width: 34.w,
                                        child: Transform.rotate(
                                            angle: pi / 4,
                                            child:
                                                SvgPicture.asset(SvgImg.add)),
                                      )
                                    : Text('#${tagsBloc.tags[index].title}',
                                        style: style1)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          },
          itemCount: tagsBloc.tags.length + 1,
        ),
      );
    });
  }
}
