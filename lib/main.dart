import 'dart:io';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/bloc/common_socket/web_socket_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/features/auth/presentation/views/login/auth_page.dart';
import 'package:be_loved/features/auth/presentation/views/login/phone.dart';
import 'package:be_loved/features/home/presentation/bloc/albums/albums_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_screen/main_screen_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_widgets/main_widgets_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/moments/moments_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/old_events/old_events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/stats/stats_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/tags/tags_bloc.dart';
import 'package:be_loved/features/home/presentation/views/home.dart';
import 'package:be_loved/features/profile/presentation/bloc/decor/decor_bloc.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:be_loved/features/theme/bloc/theme_bloc.dart';
import 'package:be_loved/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/route_manager.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:overlay_support/overlay_support.dart';
import 'features/auth/data/models/auth/user.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

void main() async {
  AppMetrica.runZoneGuarded(() async {
    AppMetrica.activate(const AppMetricaConfig("416e2567-76ea-42d1-adce-c786faf3ada5"));
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  setupInjections();
  HttpOverrides.global = MyHttpOverrides();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  var user = await MySharedPrefs().user;
  GooglePlayServicesAvailability availability = await GoogleApiAvailability
      .instance
      .checkGooglePlayServicesAvailability();

  if (availability.value == 0) {
    await Firebase.initializeApp();

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
  // MySharedPrefs().setUser(
  //   '123123123123123213',
  //   UserAnswer(
  //     me: User(username: 'Максим', phoneNumber: '+79035749646', photo: null),
  //     love:
  //         User(username: 'Ананстасия', phoneNumber: '+79939009646', photo: ''),
  //     relationId: 16,
  //     status: 'Принято',
  //     fromYou: true,
  //     date: '2022-05-05 21:30:00',
  //   ),
  // );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<WebSocketBloc>(
          create: (context) => WebSocketBloc(),
        ),
        // BlocProvider<AccountCubit>(
        //   create: (context) => sl<AccountCubit>(),
        // ),
        BlocProvider<EventsBloc>(
          create: (context) => sl<EventsBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => sl<ProfileBloc>(),
        ),
        BlocProvider<TagsBloc>(
          create: (context) => sl<TagsBloc>(),
        ),
        BlocProvider<MainScreenBloc>(
          create: (context) => sl<MainScreenBloc>(),
        ),
        BlocProvider<GalleryBloc>(
          create: (context) => sl<GalleryBloc>(),
        ),
        BlocProvider<ArchiveBloc>(
          create: (context) => sl<ArchiveBloc>(),
        ),
        BlocProvider<PurposeBloc>(
          create: (context) => sl<PurposeBloc>(),
        ),
        BlocProvider<DecorBloc>(
          create: (context) => sl<DecorBloc>(),
        ),
        BlocProvider<AlbumsBloc>(
          create: (context) => sl<AlbumsBloc>(),
        ),
        BlocProvider<MomentsBloc>(
          create: (context) => sl<MomentsBloc>(),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => sl<ThemeBloc>()..add(GetThemeLocalEvent()),
        ),
        // BlocProvider<OldEventsBloc>(
        //   create: (context) => sl<OldEventsBloc>(),
        // ),
        BlocProvider<StaticsBloc>(
          create: (context) => sl<StaticsBloc>(),
        ),
        BlocProvider<MainWidgetsBloc>(
          create: (context) => sl<MainWidgetsBloc>(),
        ),
      ],
      child: OverlaySupport.global(
        child: MyApp(user: user),
      ),
    ));
  });
  });
}

class MyApp extends StatelessWidget {
  final UserAnswer? user;
  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MySharedPrefs().logOut(context);
    // if(context.read<ThemeBloc>().state is ThemeInitialState){
    //   context.read<ThemeBloc>().add(GetThemeLocalEvent());
    // }
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) {
        return BlocConsumer<ThemeBloc, ThemeState>(listener: (context, state) {
          if (state is ThemeEditedSuccessState &&
              sl<AuthConfig>().user != null) {
            if (state.isChanges) {
              print('UPDATE THEME -------');
              context.read<ProfileBloc>().add(EditRelationNameEvent(
                    name: sl<AuthConfig>().user!.name ?? '',
                  ));
            }
          }
        }, builder: (context, state) {
          return GetMaterialApp(
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
              home: user != null
                  ? user?.date != null
                      ? HomePage()
                      : const AuthPage()
                  : const AuthPage()
              // home: HomePage(),
              );
        });
      },
    );
  }
}

// Анекдот ;)
//
// Муравей таскает камешки, веточки, строит дом. Подъезжает стрекоза на кабриолете:
// — Что делаешь
// — Дом строю.
// — А зачем?
// — Ну, зима придет, холодно будет, а я в домике согреюсь.
// — Ну ладно, строй, а я в ночной клуб поеду. И уехала.
// Муравьишка тащит камень и думает: "Ну ладно. Придет зима — посмотрим..."
// Наступила зима. Муравьишка пилит дрова, подъезжает стрекоза вся в мехах:
// — Что делаешь?
// — Дровишки пилю, холодно, сейчас печку затоплю и согреюсь.
// — Да, холодно. А я в аэропорт еду, полечу в Рио–де–Жанейро, там богема вся собирается, художники, писатели, с ними и перезимую.
// — А Крылов будет?
// — Конечно будет, все собираются.
// — Ну, увидишь — передай, что я его маму ебал.

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
