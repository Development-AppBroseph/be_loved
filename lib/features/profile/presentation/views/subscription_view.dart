import 'dart:async';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/models/subscriptions/subscription_variant.dart';
import 'package:be_loved/core/network/repository.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/presentation/views/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yookassa_payments_flutter/yookassa_payments_flutter.dart';

class SubscriptionView extends material.StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  final StreamController<int> _streamController = StreamController<int>();

  // var clientApplicationKey = "<Ключ для клиентских приложений>";
  // Amount amount = Amount(value: 999.9, currency: Currency.rub);
  // var shopId = "<Идентификатор магазина в ЮKassa)>";
  // TokenizationModuleInputData tokenizationModuleInputData =
  //     TokenizationModuleInputData(
  //   clientApplicationKey: "ouugfon7gfat57qjn7ae97fp1t",
  //   title: "Космические объекты",
  //   subtitle: "Комета повышенной яркости, период обращения — 112 лет",
  //   amount: Amount(value: 999.9, currency: Currency.rub),
  //   shopId: '12',
  //   savePaymentMethod: SavePaymentMethod.on,
  // );

  int currentIndex = 0;
  bool isPayment = false;

  // final SberbankAcquiring acquiring = SberbankAcquiring(
  //   SberbankAcquiringConfig.token(
  //     token: 'ouugfon7gfat57qjn7ae97fp1t',
  //     isDebugMode: false,
  //   ),
  // );

  // Future<void> webviewPayment(int index, BuildContext context) async {
  //   if (subscriptionVariant.isEmpty) return;
  //   final RegisterResponse register = await acquiring.register(
  //     RegisterRequest(
  //       amount: 99 * 100,
  //       returnUrl: 'https://3dsec.sberbank.ru/payment/rest/register.do',
  //       failUrl: 'https://belovedapp.ru/error/',
  //       orderNumber: subscriptionVariant[index].id.toString() +
  //           Random().nextInt(10000).toString(),
  //       pageView: 'MOBILE',
  //     ),
  //   );
  //   final String? formUrl =
  //       register.formUrl?.replaceFirst('/www.3dsec.sberbank.ru', '');
  //   if (!register.hasError && formUrl != null) {
  //     // ignore: use_build_context_synchronously
  //     showMaterialModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       barrierColor: Color.fromRGBO(0, 0, 0, 0.2),
  //       // isDismissible: false,
  //       enableDrag: false,
  //       animationCurve: Curves.easeInOutQuint,
  //       builder: (context) => Container(
  //         height: 800.h,
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.only(
  //             topRight: Radius.circular(20.r),
  //             topLeft: Radius.circular(20.r),
  //           ),
  //           child: ui.WebViewPayment(
  //             logger: acquiring.logger,
  //             formUrl: register.formUrl!,
  //             returnUrl:
  //                 'https://3dsec.sberbank.ru/sbersafe/anonymous/order/finishTds',
  //             failUrl: 'https://belovedapp.ru/error/',
  //             onLoad: (bool v) {
  //               print('WebView load: $v');
  //             },
  //             onError: () {
  //               print('WebView Error');
  //             },
  //             onFinished: (String? v) async {
  //               print('finished!!! !$v');
  //               subscriptionVariant[index].id; // sub_id
  //               v; // payment_id
  //               final GetOrderStatusExtendedResponse status =
  //                   await acquiring.getOrderStatusExtended(
  //                 GetOrderStatusExtendedRequest(orderId: v),
  //               );

  //               print('object ${status}');
  //               // _successPaid();

  //               // orderStatus = status.orderStatus;
  //               // setState(() {});
  //               if (status.errorMessage == 'Успешно') {
  //                 showAlertToast('${status.actionCodeDescription}');
  //               } else {
  //                 showSuccessAlertToast('Подписка оформлена');
  //                 await Repository().sendPaymentSubscription(
  //                     v!, subscriptionVariant[index].id!);
  //               }
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

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
    UserAnswer? user = BlocProvider.of<AuthBloc>(context).user;
    return StreamBuilder<int>(
      stream: _streamController.stream,
      initialData: 0,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: ColorStyles.mainBackgroundColor,
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, top: 59.h),
                    // child: GestureDetector(
                    //   onTap: () async {
                    //     BlocProvider.of<AuthBloc>(context).add(GetUser());
                    //     if (user != null) {
                    //       if (user.fromYou!) {
                    //         await Repository().sendTestSub();
                    //       }
                    //     }
                    //     if (Navigator.of(context).canPop()) {
                    //       Navigator.of(context).pop(true);
                    //     }
                    //   },
                    //   behavior: HitTestBehavior.opaque,
                    //   child: Container(
                    //     width: 55.w,
                    //     height: 55.h,
                    //     color: Colors.transparent,
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         SvgPicture.asset(
                    //           SvgImg.back,
                    //           height: 26.32.h,
                    //           color: Colors.black,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),
                        Text(
                          'Пробный период',
                          style: TextStyles(context).black_35_w800,
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          'Приложение с полным функционалом. Первые 7 дней бесплатно, далее 199 р в год',
                          style: TextStyles(context).grey_15_w800.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        if (currentIndex == 0)
                          GestureDetector(
                            onTap: () {
                              setState(() => currentIndex = 0);
                            },
                            child: Image.asset(
                              Img.subButtonFirst,
                              width: double.infinity,
                            ),
                          ),
                        if (currentIndex == 1)
                          GestureDetector(
                            onTap: () {
                              setState(() => currentIndex = 0);
                            },
                            child: Image.asset(
                              Img.subButtonFifth,
                              width: double.infinity,
                            ),
                          ),
                        SizedBox(height: 8.h),
                        // if (currentIndex == 0)
                        //   GestureDetector(
                        //     onTap: () {
                        //       setState(() => currentIndex = 1);
                        //     },
                        //     child: Image.asset(
                        //       Img.subButtonSecond,
                        //       width: double.infinity,
                        //     ),
                        //   ),
                        // if (currentIndex == 1)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutQuint,
                          height: currentIndex == 0 ? 84.h : 102.h,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => currentIndex = 1);
                            },
                            child: currentIndex == 1
                                ? Image.asset(
                                    Img.subButtonThird,
                                    width: double.infinity,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() => currentIndex = 1);
                                    },
                                    child: Image.asset(
                                      Img.subButtonSecond,
                                      width: double.infinity,
                                    ),
                                  ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 25.w),
                        //   child: CustomButton(
                        //     color: ColorStyles.white,
                        //     text: 'Приобрести за 199₽',
                        //     textColor: ColorStyles.blackColor,
                        //     validate: true,
                        //     onPressed: () {
                        //       _pageController.animateToPage(
                        //         1,
                        //         duration: const Duration(milliseconds: 600),
                        //         curve: Curves.easeInOutQuint,
                        //       );
                        //     },
                        //   ),
                        // ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Text(
                          'Никаких обязательств. Подписку можно отменить в любой момент.',
                          style: TextStyles(context).grey_15_w800,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (user != null)
                AnimatedOpacity(
                  opacity: !isPayment ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutQuint,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 56.h, left: 25.w, right: 25.w),
                      child: user.fromYou == null
                          ? currentIndex == 0
                              ? CustomButton(
                                  color: ColorStyles.accentColor,
                                  text: 'Продолжить бесплатно',
                                  validate: true,
                                  textColor: ColorStyles.white,
                                  onPressed: () async {
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(GetUser());
                                    if (user.fromYou == null) {
                                      await Repository().sendTestSub();
                                    }
                                    if (mounted) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                    // if (Navigator.of(context).canPop()) {
                                    //   Navigator.of(context).pop(true);
                                    // }
                                  },
                                )
                              : GestureDetector(
                                  onTap: () {
                                    payment();
                                  },
                                  child: SizedBox(
                                    width: 378.w,
                                    height: 60.h,
                                    child: Image.asset(Img.buyButton),
                                  ),
                                )
                          : SizedBox(
                              height: 108.h,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 378.w,
                                    height: 60.h,
                                    child: Image.asset(Img.partnerPays),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'Подписку оплачивает второй партнер, после оплаты перезайдите в приложение',
                                    style: TextStyles(context).grey_15_w800,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void payment() async {
    TokenizationModuleInputData tokenizationModuleInputData =
        TokenizationModuleInputData(
      clientApplicationKey: Config.url.applicationKey,
      title: "BeLoved",
      // testModeSettings: TestModeSettings(
      //     false, 10, Amount(value: 199, currency: Currency.rub), true),
      returnUrl: 'https://belovedapp.ru/processing',
      tokenizationSettings: const TokenizationSettings(
        PaymentMethodTypes(
          [
            PaymentMethod.sberbank,
            PaymentMethod.sbp,
            PaymentMethod.bankCard,
          ],
        ),
      ),
      subtitle: "Подписка BeLoved",
      customerId:
          context.read<AuthBloc>().user!.me.phoneNumber.replaceAll('+', ''),
      isLoggingEnabled: true,
      amount: Amount(value: 199, currency: Currency.rub),
      shopId: Config.url.shopId,
      savePaymentMethod: SavePaymentMethod.userSelects,
    );
    var result = await YookassaPaymentsFlutter.tokenization(
      tokenizationModuleInputData,
    );
    if (result is SuccessTokenizationResult) {
      print('alarm');
      // subscriptionVariant[index].id;
      print('token is: ${result.token}');
      var response = await Repository().createPayment(
        result.token,
        context.read<AuthBloc>().user!.me.phoneNumber,
      );
      print(context.read<AuthBloc>().user!.me.phoneNumber);
      if (response != null) {
        if (response.confirmation != null) {
          // if (response.status != 'pending') {
          await YookassaPaymentsFlutter.confirmation(
            response.confirmation!.confirmationUrl,
            getPaymentMethod(response.paymentMethod.type),
            Config.url.applicationKey,
          ).then(
            (value) async {
              var response2 = await Repository().confirmPayment(response.id);

              if (response2 != null) {
                if (response2.status == 'succeeded') {
                  bool? isAccepted = await Repository().sendPaymentSubscription(
                    '123123123',
                    subscriptionVariant[0].id!,
                  );
                  if (isAccepted != null) {
                    if (isAccepted) {
                      // showSuccessAlertToast('Подписка оформлена');
                      // ignore: use_build_context_synchronously
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop(true);
                      }
                      return;
                    }
                    return;
                  }
                  return;
                } else {
                  // Navigator.pop(context);
                  showAlertToast('Оплата не прошла.');
                }
                return;
              } else {
                showAlertToast('Оплата не прошла.');
              }
              return;
            },
          );
          // } else {
          //   showAlertToast('Оплата не прошла.');
          // }
          // showAlertToast('Оплата не прошла.');
        } else {
          var response2 = await Repository().confirmPayment(response.id);

          if (response2 != null) {
            if (response2.status == 'succeeded') {
              bool? isAccepted = await Repository().sendPaymentSubscription(
                '123123123',
                subscriptionVariant[0].id!,
              );
              if (isAccepted != null) {
                if (isAccepted) {
                  // showSuccessAlertToast('Подписка оформлена');
                  // ignore: use_build_context_synchronously
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop(true);
                  }
                  return;
                }
                return;
              }
              return;
            } else {
              showAlertToast('Оплата не прошла.');
            }
            return;
          } else {
            showAlertToast('Оплата не прошла.');
          }
          return;
        }
        return;
      } else {
        showAlertToast('Оплата не прошла.');
      }
      // showAlertToast('Оплата не прошла.');
    } else {
      // showAlertToast('Оплата не прошла.');
    }
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
    } else if (period == 12000) {
      monthName = 'Навсегда';
    }

    return GestureDetector(
      onTap: () => _streamController.sink.add(index),
      child: Container(
        height: 50.h,
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
                    '${period == 12000 ? '' : period} $monthName',
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
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 35),
                alignment: Alignment.center,
                child: Text(
                    item.overCountGb == 10000000
                        ? ''
                        : '+${item.overCountGb} ГБ архива',
                    style: TextStyle(
                      color: selectIndex == index ? Colors.white : Colors.grey,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PaymentMethod getPaymentMethod(String result) {
    if (result == 'bank_card') {
      return PaymentMethod.bankCard;
    }
    if (result == 'sberbank') {
      return PaymentMethod.sberbank;
    }
    if (result == 'sbp') {
      return PaymentMethod.sbp;
    }
    return PaymentMethod.bankCard;
  }
}
