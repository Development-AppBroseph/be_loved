import 'dart:async';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/models/get_order_status_extended/get_order_status_extended_request.dart';
import 'package:be_loved/core/models/get_order_status_extended/get_order_status_extended_response.dart';
import 'package:be_loved/core/models/register/register_request.dart';
import 'package:be_loved/core/models/register/register_response.dart';
import 'package:be_loved/core/sberbank_acquiring.dart';
import 'package:be_loved/core/sberbank_acquiring_config.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/web_view_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionView extends StatelessWidget {
  final StreamController<int> _streamController = StreamController<int>();
  final PageController _pageController = PageController(initialPage: 0);

  final SberbankAcquiring acquiring = SberbankAcquiring(
    SberbankAcquiringConfig.token(
      token: 'ouugfon7gfat57qjn7ae97fp1t',
      isDebugMode: false,
    ),
  );

  Future<void> webviewPayment(int amount, BuildContext context) async {
    final RegisterResponse register = await acquiring.register(
      RegisterRequest(
        amount: amount,
        returnUrl:
            'https://3dsec.sberbank.ru/sbersafe/anonymous/order/finishTds',
        failUrl: 'https://www.yandex.ru/',
        orderNumber: 'test',
        pageView: 'MOBILE',
      ),
    );
    final String? formUrl =
        register.formUrl?.replaceFirst('/www.3dsec.sberbank.ru', '');
    if (!register.hasError && formUrl != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15.r)),
                height: 700.h,
                child: Scaffold(
                  body: WebViewPayment(
                    logger: acquiring.logger,
                    formUrl: formUrl,
                    returnUrl:
                        'https://3dsec.sberbank.ru/sbersafe/anonymous/order/finishTds',
                    failUrl: 'https://www.yandex.ru/',
                    onLoad: (bool v) {
                      debugPrint('WebView load: $v');
                    },
                    onError: () {
                      debugPrint('WebView Error');
                    },
                    onFinished: (String? v) async {
                      print('finished!!!!');
                      final GetOrderStatusExtendedResponse status =
                          await acquiring.getOrderStatusExtended(
                        GetOrderStatusExtendedRequest(orderId: v),
                      );
                      // _successPaid();

                      // orderStatus = status.orderStatus;
                      // setState(() {});

                      // Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: _streamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          int index = snapshot.data!;
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Image.asset(
                    'assets/images/back_text.png',
                    width: MediaQuery.of(
                      context,
                    ).size.width,
                    height: 780.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Image.asset(
                    'assets/images/back_love.png',
                    width: MediaQuery.of(
                      context,
                    ).size.width,
                    height: 737.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 530.h,
                    width: MediaQuery.of(
                      context,
                    ).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.black,
                          Colors.black.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 500.h,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 115.h,
                          ),
                          Text(
                            'Поддержи проект',
                            style: TextStyles(context).white_35_w800,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Text(
                            'И получи N ГБ совместного архива, доступ к\nвыполнению уникальных целей и получению\nинтересных призов :) ',
                            style: TextStyles(context).grey_15_w800,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: CustomButton(
                              color: ColorStyles.white,
                              text: 'Приобрести за 200₽',
                              textColor: ColorStyles.blackColor,
                              validate: true,
                              onPressed: () {
                                _pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOutQuint,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Text(
                            'Пользовательское соглашение',
                            style: TextStyles(context).grey_15_w800,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Тариф',
                            style: TextStyles(context).white_35_w800,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),

                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _streamController.sink.add(0);
                                },
                                child: Container(
                                  height: 50.h,
                                  width: double.infinity,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.r),
                                    border: Border.all(
                                      width: 2.h,
                                      color: index == 0
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 33.w),
                                        child: Text(
                                          '1 месяц',
                                          style: TextStyles(context)
                                              .white_20_w700
                                              .copyWith(
                                                color: index == 0
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        width: 110.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          color: index == 0
                                              ? Colors.white
                                              : Colors.grey,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.r),
                                            bottomRight: Radius.circular(10.r),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '199₽',
                                          style:
                                              TextStyles(context).black_20_w700,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  _streamController.sink.add(1);
                                },
                                child: Container(
                                  height: 50.h,
                                  width: double.infinity,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.r),
                                    border: Border.all(
                                      width: 2.h,
                                      color: index == 1
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 33.w),
                                        child: Text(
                                          '3 месяца',
                                          style: TextStyles(context)
                                              .white_20_w700
                                              .copyWith(
                                                color: index == 1
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        width: 110.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          color: index == 1
                                              ? Colors.white
                                              : Colors.grey,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.r),
                                            bottomRight: Radius.circular(10.r),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '549₽',
                                          style:
                                              TextStyles(context).black_20_w700,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  _streamController.sink.add(2);
                                },
                                child: Container(
                                  height: 50.h,
                                  width: double.infinity,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.r),
                                    border: Border.all(
                                      width: 2.h,
                                      color: index == 2
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 33.w),
                                            child: Text(
                                              '1 год',
                                              style: TextStyles(context)
                                                  .white_20_w700
                                                  .copyWith(
                                                    color: index == 2
                                                        ? Colors.white
                                                        : Colors.grey,
                                                  ),
                                            ),
                                          ),
                                          Container(
                                            width: 110.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              color: index == 2
                                                  ? Colors.white
                                                  : Colors.grey,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.r),
                                                bottomRight:
                                                    Radius.circular(10.r),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '1990₽',
                                              style: TextStyles(context)
                                                  .black_20_w700,
                                            ),
                                          )
                                        ],
                                      ),
                                      Center(
                                        child: Container(
                                          height: 30.h,
                                          width: 139.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            color: index == 2
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '+20 ГБ архива',
                                            style: TextStyles(context)
                                                .black_15_w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Text(
                          //   'И получи N ГБ совместного архива, доступ к\nвыполнению уникальных целей и получению\nинтересных призов :) ',
                          //   style: TextStyles(context).grey_15_w800,
                          //   textAlign: TextAlign.center,
                          // ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: CustomButton(
                              color: ColorStyles.white,
                              text: 'К оформлению',
                              textColor: ColorStyles.blackColor,
                              validate: true,
                              onPressed: () {
                                webviewPayment(19900, context);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: 38.h + MediaQuery.of(context).padding.top,
                    left: 35.w,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            SvgImg.back,
                            height: 26.32.h,
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.w),
                            child: Text(
                              'Назад',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          );
        });
  }
}
