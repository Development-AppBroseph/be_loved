import 'dart:async';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_screen/main_screen_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_widgets/main_widgets_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/archive.dart';
import 'package:be_loved/features/home/presentation/views/bottom_navigation.dart';
import 'package:be_loved/features/home/presentation/views/events/view/main_event_page.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/main_page/events_page.dart';
import 'package:be_loved/features/home/presentation/views/purposes/purposes_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/main_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/main_relation_ships_page.dart';
import 'package:be_loved/features/profile/presentation/bloc/decor/decor_bloc.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_cubit.dart';
import 'package:be_loved/features/theme/bloc/theme_bloc.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/colors/color_styles.dart';
import '../bloc/tags/tags_bloc.dart';
import 'events/view/event_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();

  List<Widget> pages = [
    const MainPage(),
    const MainEventPage(), //(nextPage: (int id) {  },),//MainEventPage
    PurposesPage(),
    ArchivePage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<EventsBloc>().add(GetEventsEvent());

    context.read<DecorBloc>().add(GetBackgroundEvent());

    context.read<AuthBloc>().add(GetUser());
    context.read<TagsBloc>().add(GetTagsEvent());
    context.read<PurposeBloc>().add(GetAllPurposeDataEvent());
    context.read<PurposeBloc>().add(GetPromosEvent());
    context.read<SubCubit>().getStatus();
    context.read<PurposeBloc>().add(GetActualEvent());

    if (context.read<ArchiveBloc>().memoryEntity == null ||
        sl<AuthConfig>().memoryEntity == null) {
      context.read<ArchiveBloc>().add(GetMemoryInfoEvent());
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MainScreenBloc mainScreenBloc = context.read<MainScreenBloc>();
    return BlocListener<EventsBloc, EventsState>(
      listener: (context, state) {
        if (state is GotSuccessEventsState) {
          context.read<MainWidgetsBloc>().add(GetMainWidgetsEvent());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // var loader = showLoaderWrapper(context);
          if (state is GetUserSuccess ||
              state is GetUserError ||
              state is RefreshUser) {
            if (state is GetUserSuccess) {
              // if(context.read<ThemeBloc>().state is ThemeInitialState){
              //   context.read<ThemeBloc>().add(SetThemeEvent(index: state.user.theme == 'dark' ? 1 : 0));
              // }
            }
            // Loader.hide();
            return BlocConsumer<MainScreenBloc, MainScreenState>(
                listener: (context, state) {
              if (state is MainScreenChangedState) {
                if (state.currentView == 2 &&
                    context.read<PurposeBloc>().state is PurposeInitialState) {
                  context.read<PurposeBloc>().add(GetAllPurposeDataEvent());
                }
                pageController.jumpToPage(state.currentView);
              }
              if (state is MainScreenSetStateState) {
                setState(() {});
              }
            }, builder: (context, state) {
              return Scaffold(
                bottomNavigationBar: BottomNavigation(),
                // mainScreenBloc.currentView == 1 ? Colors.white : null
                backgroundColor: mainScreenBloc.currentView == 1
                    ? ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx]
                    : mainScreenBloc.currentView == 3
                        ? ClrStyle.whiteTo17[sl<AuthConfig>().idx]
                        : sl<AuthConfig>().idx == 1
                            ? ColorStyles.blackColor
                            : null,
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    if (mainScreenBloc.currentWidget != null)
                      mainScreenBloc.currentWidget!
                    else
                      PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        children: pages,
                      ),
                  ],
                ),
              );
            });
          } else {
            return Container(
              color: ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/heart.svg',
                color: ColorStyles.redColor,
              ),
            );
          }
        },
      ),
    );
  }
}
