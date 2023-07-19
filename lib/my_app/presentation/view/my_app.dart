import 'dart:io';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/auth/presentation/views/login/auth_page.dart';
import 'package:be_loved/features/home/presentation/views/home.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:be_loved/features/theme/bloc/theme_bloc.dart';
import 'package:be_loved/locator.dart';
import 'package:be_loved/my_app/presentation/controller/my_app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/my_app_state.dart';

class MyApp extends StatefulWidget {
  final UserAnswer? user;
  const MyApp({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<MyAppStatusCubit>().getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) {
        return BlocConsumer<ThemeBloc, ThemeState>(
          listener: (context, state) {
            if (state is ThemeEditedSuccessState &&
                sl<AuthConfig>().user != null) {
              if (state.isChanges) {
                print('UPDATE THEME -------');
                context.read<ProfileBloc>().add(
                      EditRelationNameEvent(
                        name: sl<AuthConfig>().user!.name ?? '',
                      ),
                    );
              }
            }
          },
          builder: (context, state) {
            return BlocBuilder<MyAppStatusCubit, MyAppStatusState>(
              builder: (context, state) {
                var apple =
                    'https://apps.apple.com/us/app/beloved/id6443919068';
                var android =
                    'https://play.google.com/store/apps/details?id=dev.broseph.belovedapp';
                if (state is MyAppHaveUpdateState) {
                  return GetMaterialApp(
                    navigatorObservers: [FlutterSmartDialog.observer],
                    builder: FlutterSmartDialog.init(),
                    debugShowCheckedModeBanner: false,
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: const [Locale('ru')],
                    home: UpdatePage(
                      url: Platform.isIOS
                          ? state.apple ?? apple
                          : state.android ?? android,
                    ),
                  );
                }
                return GetMaterialApp(
                  navigatorObservers: [FlutterSmartDialog.observer],
                  builder: FlutterSmartDialog.init(),
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [Locale('ru')],
                  theme: ThemeData(
                      scaffoldBackgroundColor: sl<AuthConfig>().idx == 1
                          ? ColorStyles.blackColor
                          : const Color.fromRGBO(240, 240, 240, 1.0),
                      fontFamily: 'Inter'),
                  home: widget.user != null
                      ? widget.user?.date != null
                          ? const HomePage()
                          : const AuthPage()
                      : const AuthPage(),
                );
              },
            );
          },
        );
      },
    );
  }
}

class UpdatePage extends StatefulWidget {
  final String url;
  const UpdatePage({super.key, required this.url});

  @override
  State<UpdatePage> createState() => UpdatePageState();
}

class UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // AppBar(
          //   backgroundColor: Colors.transparent,
          // ),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/update_image.png',
                  ),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter),
            ),
          ),
          // Image.asset(
          //   width: MediaQuery.of(
          //     context,
          //   ).size.width,
          //   height: 690.h,
          //   fit: BoxFit.cover,
          // ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height,
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black,
                  Colors.black,
                  Colors.black,
                  Colors.black87,
                  Colors.transparent
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 146),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Обновите приложение',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'Доступное новое обновление',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff969696),
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: CustomButton(
                      color: ColorStyles.white,
                      text: 'Обновить',
                      textColor: ColorStyles.blackColor,
                      validate: true,
                      onPressed: () {
                        launchUrl(
                          Uri.parse(widget.url),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
