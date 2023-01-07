import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/bloc/common_socket/web_socket_bloc.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/features/auth/presentation/views/login/phone.dart';
import 'package:be_loved/features/home/presentation/bloc/albums/albums_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_screen/main_screen_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/tags/tags_bloc.dart';
import 'package:be_loved/features/home/presentation/views/home.dart';
import 'package:be_loved/features/profile/presentation/bloc/decor/decor_bloc.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/profile_bloc.dart';
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
import 'package:overlay_support/overlay_support.dart';
import 'features/auth/data/models/auth/user.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  setupInjections();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  var user = await MySharedPrefs().user;
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
      ],
      child: OverlaySupport.global(
        child: MyApp(user: user),
      ),
    ));
  });
}

class MyApp extends StatelessWidget {
  final UserAnswer? user;
  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MySharedPrefs().logOut(context);
    FlutterNativeSplash.remove();
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ru')],
          theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
              fontFamily: 'Inter'),
          home: user != null
              ? user?.date != null
                  ? HomePage()
                  : const PhonePage()
              : const PhonePage(),
          // home: HomePage(),
        );
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
