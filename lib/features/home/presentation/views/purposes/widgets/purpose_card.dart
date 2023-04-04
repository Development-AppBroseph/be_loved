import 'dart:io';
import 'dart:math';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/main_config_app.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/functions.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/modals/add_file/add_file_modal.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class PurposeCard extends StatelessWidget {
  final PurposeEntity purposeEntity;
  final Function()? onCompleteTap;
  final Function()? onCancelTap;
  final Function(File file)? onPickFile;
  final bool isMainWidget;
  final Function()? deleteTap;
  PurposeCard(
      {Key? key,
      required this.purposeEntity,
      this.onCompleteTap,
      this.onPickFile,
      this.onCancelTap,
      this.isMainWidget = false,
      this.deleteTap});

  pickImage(ImageSource source) async {
    XFile? pick = await ImagePicker().pickImage(source: source);
    if (pick != null) {
      if (onPickFile != null) onPickFile!(File(pick.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration daysDifference = purposeEntity.dateTime == null
        ? Duration.zero
        : purposeEntity.dateTime!.difference(DateTime.now());
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -5.h),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20.w,
          ),
        ],
        borderRadius: BorderRadius.circular(20.r),
      ),
      width: 378.w,
      height: 220.h,
      child: CupertinoCard(
        margin: EdgeInsets.zero,
        elevation: 0,
        radius: BorderRadius.circular(40.r),
        color: Colors.black,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              purposeEntity.photo.contains('http')
                  ? purposeEntity.photo
                  : Config.url.url + purposeEntity.photo,
            ),
            fit: BoxFit.cover,
            opacity: .6,
          ),
        ),
        child: Stack(
          children: [
            if ((purposeEntity.dateTime != null &&
                    daysDifference.inDays <= 31) ||
                purposeEntity.inHistory ||
                purposeEntity.inProcess)
              // Positioned(
              //   top: 18.h,
              //   left: 20.w,
              //   child: Row(
              //     children: [
              //       if (purposeEntity.inProcess) ...[
              //         _buildCloseBtn(() {
              //           onCancelTap != null ? onCancelTap!() : () {};
              //         }),
              //         SizedBox(
              //           width: 10.w,
              //         )
              //       ],
              //       _buildStatusBlock(
              //         purposeEntity.inProcess
              //             ? 'В процессе'
              //             : purposeEntity.inHistory
              //                 ? 'Достигнута'
              //                 : daysDifference == 0
              //                     ? purposeTimes(daysDifference)
              //                     : purposeDays('${daysDifference.inDays}'),
              //         context,
              //         horizontalPadding: purposeEntity.inProcess ? 26.w : 17.w,
              //       ),
              //     ],
              //   ),
              // ),
              if (isMainWidget)
                Positioned(
                  top: 18.h,
                  right: 20.w,
                  child: Row(
                    children: const [
                      // _buildCloseBtn(
                      //   () {
                      //     deleteTap != null ? deleteTap!() : () {};
                      //   },
                      // ),
                    ],
                  ),
                ),
            if (purposeEntity.promo == null)
              Container()
            else
              GestureDetector(
                onTap: () =>
                    Functions.showPromosDilog(purposeEntity.promo!, context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 20.w,
                        top: 15.h,
                      ),
                      height: 29.h,
                      child: CupertinoCard(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.symmetric(
                            horizontal: 17.w, vertical: 6.h),
                        elevation: 0,
                        color: ColorStyles.redColor,
                        radius: BorderRadius.circular(10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '+Купон на ${purposeEntity.promo == null ? '' : purposeEntity.promo!.shortName}',
                            style: TextStyles(context).white_15_w800.copyWith(
                                  color: ColorStyles.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 63.h, left: 20.w),
                child: Text(
                  (purposeEntity.name),
                  style: TextStyles(context).white_25_w800,
                ),
              ),
            ),
            purposeEntity.dateTime == null
                ? Container()
                : Align(
                    alignment: purposeEntity.promo == null
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Container(
                      height: 29.h,
                      width: 113.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: sl<AuthConfig>().idx == 0
                            ? Colors.white.withOpacity(0.9)
                            : ColorStyles.black2Color.withOpacity(0.9),
                      ),
                      margin:
                          EdgeInsets.only(top: 15.h, right: 20.w, left: 20.w),
                      child: Text(
                        'до ${purposeEntity.dateTime!.day.toString()} ${MainConfigApp.monthsPromo[purposeEntity.dateTime!.month]}.',
                        style: TextStyles(context).black_15_w800.copyWith(
                            color: sl<AuthConfig>().idx == 0
                                ? ColorStyles.blackColor.withOpacity(0.7)
                                : ColorStyles.white.withOpacity(0.7)),
                      ),
                    ),
                  ),
            if (!purposeEntity.inHistory)
              if (!purposeEntity.inProcess)
                GestureDetector(
                  onTap: () {
                    if (onCompleteTap != null) {
                      onCompleteTap!();
                    }
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20.w, bottom: 15.h),
                      width: 139.w,
                      height: 36.h,
                      child: CupertinoCard(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        color: ColorStyles.primarySwath,
                        radius: BorderRadius.circular(20.r),
                        child: Center(
                          child: Text(
                            'Достигнуть',
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
              else
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (onCompleteTap != null) {
                              Functions.showPurposeDilog(
                                purposeEntity,
                                context,
                                () => pickImage(ImageSource.gallery),
                              );
                            }
                          },
                          child: SizedBox(
                            width: 139.w,
                            height: 36.h,
                            child: CupertinoCard(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              color: ColorStyles.white,
                              radius: BorderRadius.circular(20.r),
                              child: Center(
                                child: Text(
                                  'Завершить',
                                  style: TextStyles(context)
                                      .white_18_w800
                                      .copyWith(
                                        color: ColorStyles.primarySwath,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // _buildSvgBtn(
                        //     svg: SvgImg.gallery,
                        //     onTap: () {
                        //       pickImage(ImageSource.gallery);
                        //     }),
                        // SizedBox(
                        //   width: 24.w,
                        // ),
                        // _buildSvgBtn(
                        //     svg: SvgImg.camera,
                        //     onTap: () {
                        //       pickImage(ImageSource.camera);
                        //     }),
                        // SizedBox(
                        //   width: 12.w,
                        // )
                      ],
                    ),
                  ),
                )
            else
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (onCompleteTap != null) {
                            onCompleteTap!();
                          }
                        },
                        child: SizedBox(
                          height: 36.h,
                          child: CupertinoCard(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            elevation: 0,
                            color: const Color(0xff20CB83).withOpacity(.5),
                            radius: BorderRadius.circular(20.r),
                            child: Center(
                              child: Text(
                                'Цель достигнута',
                                style: TextStyles(context)
                                    .white_18_w800
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // _buildSvgBtn(
                      //     svg: SvgImg.gallery,
                      //     onTap: () {
                      //       pickImage(ImageSource.gallery);
                      //     }),
                      // SizedBox(
                      //   width: 24.w,
                      // ),
                      // _buildSvgBtn(
                      //     svg: SvgImg.camera,
                      //     onTap: () {
                      //       pickImage(ImageSource.camera);
                      //     }),
                      // SizedBox(
                      //   width: 12.w,
                      // )
                    ],
                  ),
                ),
              ),
            if (purposeEntity.inProcess)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 29.h,
                  width: 113.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: sl<AuthConfig>().idx == 0
                        ? Colors.white.withOpacity(0.9)
                        : ColorStyles.black2Color.withOpacity(0.9),
                  ),
                  margin: EdgeInsets.only(top: 15.h, right: 20.w, left: 20.w),
                  child: Text(
                    'В процессе',
                    style: TextStyles(context).black_15_w800.copyWith(
                        color: sl<AuthConfig>().idx == 0
                            ? ColorStyles.blackColor.withOpacity(0.7)
                            : ColorStyles.white.withOpacity(0.7)),
                  ),
                ),
              ),
          ],
        ),
        // child: CachedNetworkImage(
        //   imageUrl: purposeEntity.photo.contains('http')
        //       ? purposeEntity.photo
        //       : Config.url.url + purposeEntity.photo,
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

  Widget _buildSvgBtn({required Function() onTap, required String svg}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 42.h,
        height: 42.h,
        child: CupertinoCard(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: ColorStyles.primarySwath,
          radius: BorderRadius.circular(20.r),
          child: Center(
            child: SvgPicture.asset(
              svg,
              width: 19.w,
              color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBlock(String text, BuildContext context,
      {double? horizontalPadding}) {
    return ClipPath.shape(
      shape: SquircleBorder(radius: BorderRadius.circular(20.r)),
      child: Stack(
        children: [
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: horizontalPadding ?? 17.w),
            height: 33.h,
            alignment: Alignment.center,
            color: sl<AuthConfig>().idx == 0
                ? Colors.white.withOpacity(0.9)
                : ColorStyles.black2Color.withOpacity(0.9),
            child: Text(
              text,
              style: TextStyles(context).black_15_w800.copyWith(
                  color: sl<AuthConfig>().idx == 0
                      ? ColorStyles.blackColor.withOpacity(0.7)
                      : ColorStyles.white.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseBtn(Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipPath.shape(
          shape: SquircleBorder(radius: BorderRadius.circular(20.r)),
          child: Container(
            height: 33.h,
            color: sl<AuthConfig>().idx == 0
                ? Colors.white.withOpacity(0.9)
                : ColorStyles.black2Color.withOpacity(0.9),
            width: 33.h,
            child: Stack(
              children: [
                Center(
                    child: SvgPicture.asset(
                  SvgImg.add,
                  height: 14.h,
                  color: sl<AuthConfig>().idx == 0
                      ? ColorStyles.blackColor.withOpacity(0.7)
                      : ColorStyles.white.withOpacity(0.7),
                ))
              ],
            ),
          )),
    );
  }
}

class PurposeDilog extends StatefulWidget {
  final void Function() onComplete;
  final PurposeEntity purposeEntity;
  const PurposeDilog(
      {Key? key, required this.purposeEntity, required this.onComplete})
      : super(key: key);

  @override
  State<PurposeDilog> createState() => _PurposeDilogState();
}

class _PurposeDilogState extends State<PurposeDilog> {
  List<GalleryFileEntity> filesFromGallery = [];

  bool isValidate() {
    return filesFromGallery.isNotEmpty;
  }

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
                        widget.purposeEntity.photo.contains('https')
                            ? widget.purposeEntity.photo
                            : 'https://beloved-app.ru${widget.purposeEntity.photo}',
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
                  if (widget.purposeEntity.dateTime != null)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 17.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: sl<AuthConfig>().idx == 0
                              ? Colors.white.withOpacity(0.9)
                              : ColorStyles.black2Color.withOpacity(0.9),
                        ),
                        margin: EdgeInsets.only(
                            top: 15.h, right: 20.w, bottom: 15.h),
                        child: Text(
                          'до ${widget.purposeEntity.dateTime!.day.toString()} ${MainConfigApp.months[widget.purposeEntity.dateTime!.month]}.',
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
                'Вы достигли цель',
                textAlign: TextAlign.start,
                style: TextStyles(context)
                    .black_24_w700
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 5.h,
              ),
              child: Text(
                'Мы надеемся, что вы хорошо провели время! Вы можете сохранить памятный момент в архив:',
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
                  // HapticFeedback.lightImpact();
                  // await Clipboard.setData(
                  //         ClipboardData(text: widget.purposeEntity.promo))
                  //     .then((_) {
                  //   setState(() {
                  //     icon = const Icon(Icons.done_rounded);
                  //   });
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //       content: Text("Промокод был скопирован")));
                  // });
                },
                child: GestureDetector(
                  onTap: () {
                    widget.onComplete();
                    Navigator.of(context).pop();
                  },
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.center,
                        height: 54.h,
                        width: 338.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.sp),
                            color: const Color(0xff20CB83)),
                        child: Text(
                          'Выбрать файл',
                          style: TextStyles(context).white_20_w800,
                        ),
                      )
                      // child: DottedBorder(
                      //   strokeWidth: 1,
                      //   borderType: BorderType.RRect,
                      //   radius: const Radius.circular(12),
                      //   dashPattern: const [10, 10],
                      //   child: ClipRRect(
                      //     borderRadius: const BorderRadius.all(Radius.circular(12)),
                      //     child: SizedBox(
                      //       height: 70.h,
                      //       width: 328.w,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text(
                      //             'Промокод',
                      //             style: TextStyles(context)
                      //                 .grey_15_w700
                      //                 .copyWith(fontWeight: FontWeight.w600),
                      //           ),
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Text(
                      //                 widget.purposeEntity.promo,
                      //                 style: TextStyles(context)
                      //                     .black_24_w700
                      //                     .copyWith(fontWeight: FontWeight.w800),
                      //               ),
                      //               icon,
                      //             ],
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
