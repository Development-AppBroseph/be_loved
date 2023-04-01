import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/main_config_app.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/functions.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/domain/entities/purposes/promos_entiti.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';

class PromosCard extends StatefulWidget {
  final PromosEntiti promosEntiti;
  const PromosCard({
    Key? key,
    required this.promosEntiti,
  }) : super(key: key);

  @override
  State<PromosCard> createState() => _PromosCardState();
}

class _PromosCardState extends State<PromosCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 170.h,
            width: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: SizedBox(
                    height: 170.h,
                    width: double.infinity,
                    child: Image.network(
                      widget.promosEntiti.photo,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 17.w, vertical: 6.h),
                    margin: EdgeInsets.only(top: 15.h, left: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.promosEntiti.shortName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 17.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: sl<AuthConfig>().idx == 0
                          ? Colors.white.withOpacity(0.9)
                          : ColorStyles.black2Color.withOpacity(0.9),
                    ),
                    margin: EdgeInsets.only(top: 15.h, right: 20.w),
                    child: Text(
                      'до ${widget.promosEntiti.dateEnd!.day.toString()} ${MainConfigApp.monthsPromo[widget.promosEntiti.dateEnd!.month]}.',
                      style: TextStyles(context).black_15_w800.copyWith(
                          color: sl<AuthConfig>().idx == 0
                              ? ColorStyles.blackColor.withOpacity(0.7)
                              : ColorStyles.white.withOpacity(0.7)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 12.h,
            ),
            child: Text(
              widget.promosEntiti.name,
              textAlign: TextAlign.start,
              style: TextStyles(context)
                  .black_24_w700
                  .copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          GestureDetector(
            onTap: () {
              Functions.showPromosDilog(widget.promosEntiti, context);
            },
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(left: 20.w, bottom: 15.h),
                width: 178.w,
                height: 36.h,
                child: CupertinoCard(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: ColorStyles.primarySwath,
                  radius: BorderRadius.circular(20.r),
                  child: Center(
                    child: Text(
                      'Получить купон',
                      style: TextStyles(context).white_18_w800.copyWith(
                          color: sl<AuthConfig>().idx == 1
                              ? ColorStyles.black2Color
                              : null),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PromosDilog extends StatefulWidget {
  final PromosEntiti promosEntiti;
  const PromosDilog({Key? key, required this.promosEntiti}) : super(key: key);

  @override
  State<PromosDilog> createState() => _PromosDilogState();
}

class _PromosDilogState extends State<PromosDilog> {
  Icon icon = const Icon(Icons.copy_rounded);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 25.w,
      ),
      backgroundColor: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 170.h,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: SizedBox(
                      height: 170.h,
                      width: double.infinity,
                      child: Image.network(
                        widget.promosEntiti.photo.contains('https')
                            ? widget.promosEntiti.photo
                            : 'https://beloved-app.ru${widget.promosEntiti.photo}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async => Navigator.of(context).pop(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(9.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: sl<AuthConfig>().idx == 0
                              ? Colors.black.withOpacity(.7)
                              : ColorStyles.black2Color.withOpacity(0.7),
                        ),
                        margin: EdgeInsets.only(
                            top: 15.h, right: 20.w, bottom: 15.h),
                        child: SvgPicture.asset(
                          SvgImg.closeEventCreate,
                          height: 10.h,
                          width: 10,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 17.w, vertical: 6.h),
                      margin:
                          EdgeInsets.only(top: 15.h, left: 20.w, bottom: 15.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.promosEntiti.shortName,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 17.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: sl<AuthConfig>().idx == 0
                            ? Colors.white.withOpacity(0.9)
                            : ColorStyles.black2Color.withOpacity(0.9),
                      ),
                      margin:
                          EdgeInsets.only(top: 15.h, right: 20.w, bottom: 15.h),
                      child: Text(
                        'до ${widget.promosEntiti.dateEnd!.day.toString()} ${MainConfigApp.months[widget.promosEntiti.dateEnd!.month]}.',
                        style: TextStyles(context).black_15_w800.copyWith(
                            color: sl<AuthConfig>().idx == 0
                                ? ColorStyles.blackColor.withOpacity(0.7)
                                : ColorStyles.white.withOpacity(0.7)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 12.h,
              ),
              child: Text(
                widget.promosEntiti.name,
                textAlign: TextAlign.start,
                style: TextStyles(context)
                    .black_24_w700
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            if (widget.promosEntiti.description != '')
              Container(
                margin: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 5.h,
                ),
                child: Text(
                  widget.promosEntiti.description,
                  textAlign: TextAlign.start,
                  style: TextStyles(context)
                      .grey_15_w700
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            Container(
              margin: EdgeInsets.only(bottom: 30.h, top: 40.h),
              child: GestureDetector(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  await Clipboard.setData(
                          ClipboardData(text: widget.promosEntiti.promo))
                      .then((_) {
                    setState(() {
                      icon = const Icon(Icons.done_rounded);
                    });
                  });
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DottedBorder(
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [10, 10],
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: SizedBox(
                        height: 70.h,
                        width: 328.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Промокод',
                              style: TextStyles(context)
                                  .grey_15_w700
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.promosEntiti.promo,
                                  style: TextStyles(context)
                                      .black_24_w700
                                      .copyWith(fontWeight: FontWeight.w800),
                                ),
                                icon,
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
