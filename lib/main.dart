import 'dart:io';

import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/bloc/common_socket/web_socket_bloc.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/features/home/presentation/bloc/albums/albums_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_screen/main_screen_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_widgets/main_widgets_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/moments/moments_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/stats/stats_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/tags/tags_bloc.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/controller/leveles_cubit.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_first/controller/home_info_first_cubit.dart';
import 'package:be_loved/features/profile/domain/usecases/create_virtual_partner_use_case.dart';
import 'package:be_loved/features/profile/presentation/bloc/create_virtual_partner/create_virtual_partner_bloc.dart';
import 'package:be_loved/features/profile/presentation/bloc/decor/decor_bloc.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_cubit.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:be_loved/features/theme/bloc/theme_bloc.dart';
import 'package:be_loved/locator.dart';
import 'package:be_loved/my_app/presentation/controller/my_app_cubit.dart';
import 'package:be_loved/my_app/presentation/view/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> check() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    Permission.notification.request();
  }
}

void main() async {
  // AppMetrica.runZoneGuarded(() async {
  //   AppMetrica.activate(
  //       const AppMetricaConfig("416e2567-76ea-42d1-adce-c786faf3ada5"));
  WidgetsFlutterBinding.ensureInitialized();
  // check();
  setupInjections();
  HttpOverrides.global = MyHttpOverrides();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  var user = await MySharedPrefs().user;
  // print('user: ${(user as UserAnswer).}');
  GooglePlayServicesAvailability availability = await GoogleApiAvailability
      .instance
      .checkGooglePlayServicesAvailability();

  if (availability.value == 0 || Platform.isIOS) {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(GetStatusUser(context: context)),
        ),
        BlocProvider<WebSocketBloc>(
          create: (context) => WebSocketBloc(),
        ),
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
        BlocProvider<HomeInfoFirstCubit>(
          create: (context) => sl<HomeInfoFirstCubit>(),
        ),
        BlocProvider<StaticsBloc>(
          create: (context) => sl<StaticsBloc>(),
        ),
        BlocProvider<MainWidgetsBloc>(
          create: (context) => sl<MainWidgetsBloc>(),
        ),
        BlocProvider<SubCubit>(
          create: (context) => sl<SubCubit>(),
        ),
        BlocProvider<LevelsCubit>(
          create: (context) => sl<LevelsCubit>(),
        ),
        BlocProvider<MyAppCubit>(
          create: (context) => MyAppCubit(),
        ),
        BlocProvider<MyAppStatusCubit>(
          create: (context) => MyAppStatusCubit(),
        ),
        BlocProvider<CreateVirtualPartnerBloc>(
          create: (context) => CreateVirtualPartnerBloc(
            sl<CreateVirtualPartnerUseCase>(),
          ),
        ),
      ],
      child: OverlaySupport.global(
        child: MyApp(
          user: user,
        ),
      ),
    ));
  });
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
