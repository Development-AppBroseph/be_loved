import 'dart:math';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/models/subscriptions/subscription_variant.dart';
import 'package:be_loved/core/network/repository.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/presentation/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yookassa_payments_flutter/yookassa_payments_flutter.dart';

class SecondSubscriptionView extends StatefulWidget {
  const SecondSubscriptionView({super.key});

  @override
  State<SecondSubscriptionView> createState() => _SecondSubscriptionViewState();
}

class _SecondSubscriptionViewState extends State<SecondSubscriptionView> {
  bool isPayment = false;
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
    return Scaffold(
      backgroundColor: ColorStyles.mainBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: 274.h),
            Text(
              'Пробный период закончился',
              style: TextStyles(context).black_35_w800,
            ),
            SizedBox(height: 24.h),
            Image.asset(Img.subButtonFourth),
            SizedBox(height: 66.h),
            if (user != null)
              if (user.fromYou != null)
                AnimatedOpacity(
                  opacity: !isPayment ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutQuint,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          payment();
                        },
                        child: SizedBox(
                          width: 378.w,
                          height: 60.h,
                          child: Image.asset(
                            Img.buyButton,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Никаких обязательств. Подписку можно отменить в любой момент.',
                        style: TextStyles(context).grey_15_w800.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    SizedBox(
                      width: 378.w,
                      height: 60.h,
                      child: Image.asset(
                        Img.partnerPays,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Подписку оплачивает второй партнер, после оплаты перезайдите в приложение',
                      style: TextStyles(context).grey_15_w800,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  void payment() async {
    TokenizationModuleInputData tokenizationModuleInputData =
        TokenizationModuleInputData(
      clientApplicationKey: Config.url.applicationKey,
      title: "BeLoved",
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
    print(result);
    if (result is SuccessTokenizationResult) {
      print('alarm');
      // subscriptionVariant[index].id;
      print('token is: ${result.token}');
      var response = await Repository().createPayment(
        result.token,
        context.read<AuthBloc>().user!.me.phoneNumber.replaceAll('+', ''),
      );
      print(context.read<AuthBloc>().user!.me.phoneNumber);
      if (response != null) {
        if (response.confirmation != null) {
          await YookassaPaymentsFlutter.confirmation(
            response.confirmation!.confirmationUrl,
            getPaymentMethod(response.paymentMethod.type),
            "live_OTI4NDAw8ttALVIt1VXrCwQMffW9HleBw1GPZ7Cu5eU",
          ).then(
            (value) async {
              var response2 = await Repository().confirmPayment(response.id);

              if (response2 != null) {
                if (response2.status == 'succeeded') {
                  bool? isAccepted = await Repository().sendPaymentSubscription(
                    context.read<AuthBloc>().user!.relationId.toString() +
                        Random().nextInt(10000).toString(),
                    subscriptionVariant[0].id!,
                  );
                  if (isAccepted != null) {
                    if (isAccepted) {
                      // showSuccessAlertToast('Подписка оформлена');
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                        (route) => false,
                      );
                      return;
                    }
                    return;
                  }
                  return;
                } else {
                  showAlertToast('Оплата не прошла.');
                }
                return;
              }
              return;
            },
          );
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (route) => false,
                  );
                  return;
                }
                return;
              }
              return;
            } else {
              showAlertToast('Оплата не прошла.');
            }
            return;
          }
          return;
        }
        return;
      } else {
        showAlertToast('Оплата не прошла.');
      }
      // showAlertToast('Оплата не прошла.');
      // showSuccessAlertToast(
      //     'Подписка оформлена');
      // Navigator.of(context).pop();
    } else {
      // showAlertToast('Оплата не прошла.');
    }
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
