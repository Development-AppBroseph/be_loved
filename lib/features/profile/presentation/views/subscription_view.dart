import 'dart:async';
import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
// import 'package:be_loved/core/models/get_order_status_extended/get_order_status_extended_request.dart';
// import 'package:be_loved/core/models/get_order_status_extended/get_order_status_extended_response.dart';
// import 'package:be_loved/core/models/register/register_request.dart';
// import 'package:be_loved/core/models/register/register_response.dart';
import 'package:be_loved/core/models/subscriptions/subscription_variant.dart';
import 'package:be_loved/core/network/repository.dart';
import 'package:flutter/material.dart';
// import 'package:be_loved/core/sberbank_acquiring.dart';
// import 'package:be_loved/core/sberbank_acquiring_config.dart';
import 'package:sberbank_acquiring/sberbank_acquiring_core.dart';
import 'package:sberbank_acquiring/sberbank_acquiring_ui.dart' as ui;
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionView extends material.StatefulWidget {
  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  final StreamController<int> _streamController = StreamController<int>();

  final PageController _pageController = PageController(initialPage: 0);

  final SberbankAcquiring acquiring = SberbankAcquiring(
    SberbankAcquiringConfig.token(
      token: 'ouugfon7gfat57qjn7ae97fp1t',
      isDebugMode: false,
    ),
  );

  Future<void> webviewPayment(int index, BuildContext context) async {
    if (subscriptionVariant.isEmpty) return;
    final RegisterResponse register = await acquiring.register(
      RegisterRequest(
        amount: subscriptionVariant[index].price! * 100,
        returnUrl: 'https://3dsec.sberbank.ru/payment/rest/register.do',
        failUrl: 'https://www.yandex.ru/',
        orderNumber: subscriptionVariant[index].id.toString() +
            Random().nextInt(10000).toString(),
        pageView: 'MOBILE',
      ),
    );
    // final RegisterResponse register = await acquiring.register(
    //   RegisterRequest(
    //     amount: subscriptionVariant[index].price! * 100,
    //     returnUrl:
    //         'https://3dsec.sberbank.ru/sbersafe/anonymous/order/finishTds',
    //     failUrl: 'https://www.yandex.ru/',
    //     orderNumber: subscriptionVariant[index].id.toString() + Random().nextInt(10000).toString(),
    //     pageView: 'MOBILE',
    //   ),
    // );
    final String? formUrl =
        register.formUrl?.replaceFirst('/www.3dsec.sberbank.ru', '');
    if (!register.hasError && formUrl != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Оплата подписки'),
            ),
            body: ui.WebViewPayment(
              logger: acquiring.logger,
              formUrl: formUrl,
              returnUrl:
                  'https://3dsec.sberbank.ru/sbersafe/anonymous/order/finishTds',
              failUrl: 'https://www.yandex.ru/',
              onLoad: (bool v) {
                print('WebView load: $v');
              },
              onError: () {
                print('WebView Error');
              },
              onFinished: (String? v) async {
                print('finished!!! !$v');
                subscriptionVariant[index].id; // sub_id
                v; // payment_id
                final GetOrderStatusExtendedResponse status =
                    await acquiring.getOrderStatusExtended(
                  GetOrderStatusExtendedRequest(orderId: v),
                );

                print('object ${status}');
                // _successPaid();

                // orderStatus = status.orderStatus;
                // setState(() {});
                if (status.errorMessage == 'Успешно') {
                  showAlertToast('${status.actionCodeDescription}');
                } else {
                  showSuccessAlertToast('Подписка оформлена');
                  await Repository().sendPaymentSubscription(
                      v!, subscriptionVariant[index].id!);
                }
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      );
    }
  }

  List<SubscriptionVariant> subscriptionVariant = [];

  @override
  void initState() {
    super.initState();
    getSubscriptions();
  }

  void getSubscriptions() async {
    subscriptionVariant.clear();
    List<SubscriptionVariant> subscriptionVariantTemp =
        await Repository().getSuscriptionsList();
    subscriptionVariant.addAll(subscriptionVariantTemp);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _streamController.stream,
      initialData: 0,
      builder: (context, snapshot) {
        int index = snapshot.data!;
        print('object $index');
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
                child: material.PageView(
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

                        Builder(
                          builder: ((context) {
                            List<Widget> list = [];
                            for (int i = 0;
                                i < subscriptionVariant.length;
                                i++) {
                              list.add(itemSubscription(
                                  subscriptionVariant[i], i, index));
                            }
                            return Column(children: list);
                          }),
                        ),
                        // Text(
                        //   'И получи N ГБ совместного архива, доступ к\nвыполнению уникальных целей и получению\nинтересных призов :) ',
                        //   style: TextStyles(context).grey_15_w800,
                        //   textAlign: TextAlign.center,
                        // ),
                        SizedBox(height: 40.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: CustomButton(
                            color: ColorStyles.white,
                            text: 'К оформлению',
                            textColor: ColorStyles.blackColor,
                            validate: true,
                            onPressed: () => webviewPayment(index, context),
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
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget itemSubscription(
      SubscriptionVariant item, int index, int selectIndex) {
    int period = item.monthLong!;
    String monthName = '';
    if (period == 1) {
      monthName = 'месяц';
    } else if (period >= 2 && period <= 4) {
      monthName = 'месяца';
    } else if (period >= 5 && period <= 11) {
      monthName = 'месяцев';
    } else if (period >= 5 && period <= 11) {
      monthName = 'месяцев';
    } else if (period == 12) {
      period = 1;
      monthName = 'год';
    }

    return GestureDetector(
      onTap: () => _streamController.sink.add(index),
      child: Container(
        height: 50.h,
        // margin: EdgeInsets.only(bottom: 10.h),
        width: double.infinity,
        margin: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(
            width: 2.h,
            color: selectIndex == index ? Colors.white : Colors.grey,
          ),
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 33.w),
                  child: Text(
                    '${period} ${monthName}',
                    style: TextStyles(context).white_20_w700.copyWith(
                          color:
                              selectIndex == index ? Colors.white : Colors.grey,
                        ),
                  ),
                ),
                Container(
                  width: 110.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: selectIndex == index ? Colors.white : Colors.grey,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.r),
                      bottomRight: Radius.circular(10.r),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.price}₽',
                    style: TextStyles(context).black_20_w700,
                  ),
                )
              ],
            ),
            if (index == 2)
              Center(
                child: Container(
                  height: 30.h,
                  width: 139.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: selectIndex == index ? Colors.white : Colors.grey,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '+${item.overCountGb} ГБ архива',
                    style: TextStyles(context).black_15_w800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
