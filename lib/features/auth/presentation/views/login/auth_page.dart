import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/bloc/common_socket/web_socket_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/auth/presentation/views/login/phone.dart';
import 'package:be_loved/features/auth/presentation/widgets/option_btn.dart';
import 'package:be_loved/features/auth/presentation/widgets/preview_indicator.dart';
import 'package:be_loved/features/auth/presentation/widgets/preview_item.dart';
import 'package:be_loved/features/home/presentation/views/home.dart';
import 'package:be_loved/features/theme/bloc/theme_bloc.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int currentIndex = 0;

  bool isRouted = false;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is VKError) {
          showAlertToast(state.error);
        }
        if (state is VKRequiredRegister) {
          isRouted = true;
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PhonePage(
                        vkCode: state.code,
                      )));
          isRouted = false;
        }
        if (state is VKLoggin) {
          print('LOGGED IN VK');
          BlocProvider.of<AuthBloc>(context).add(GetUser());
        }
        if (state is GetUserSuccess && !isRouted) {
          print('GOT USER VK');
          isRouted = true;
          BlocProvider.of<WebSocketBloc>(context)
              .add(WebSocketEvent(authBloc.token ?? ''));
          MySharedPrefs().setUser(authBloc.token ?? '',
              BlocProvider.of<AuthBloc>(context, listen: false).user!);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor:
            sl<AuthConfig>().idx == 1 ? ColorStyles.blackColor : null,
        body: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Stack(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    children: const [
                      PreviewItem(
                        title: 'Сохраняй моменты',
                        text:
                            'Пользуйтесь совместным архивом для\nсохранения общих фотографий, видео и\nсобытий',
                        image: Img.onboardingFirst,
                      ),
                      PreviewItem(
                        title: 'Планируй события',
                        text:
                            'Отметьте самые важные события для ваших\nотношений, а BeLoved напомнит о них',
                        image: Img.onboardingSecond,
                      ),
                      PreviewItem(
                        title: 'Достигай целей',
                        text:
                            'Выполняйте милые достижения для ваших\nотношений, и получайте приятные призы',
                        image: Img.onboardingThird,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 220.h,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 9.h,
                        ),
                        PreviewIndicator(currentIndex: currentIndex),
                        SizedBox(
                          height: 25.h,
                        ),
                        OptionBtn(
                            onTap: () async {
                              isRouted = true;
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const PhonePage()));
                              isRouted = false;
                            },
                            text: 'По номеру телефона',
                            isPhone: true),
                        SizedBox(
                          height: 15.h,
                        ),
                        // OptionBtn(
                        //     onTap: () {
                        //       // Navigator.push(
                        //       //     context,
                        //       //     CupertinoPageRoute(
                        //       //         builder: (BuildContext context) =>
                        //       //             VKView(onCodeReturn: (code) {
                        //       //               Navigator.pop(context);
                        //       //               authBloc.add(TryAuthVK(code));
                        //       //             })));
                        //     },
                        //     text: 'Через Вконтакте',
                        //     isPhone: false),
                        // SizedBox(
                        //   height: 50.h,
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
