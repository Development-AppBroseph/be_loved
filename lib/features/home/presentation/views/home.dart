import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/bloc/common_socket/web_socket_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_screen/main_screen_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_widgets/main_widgets_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/archive.dart';
import 'package:be_loved/features/home/presentation/views/bottom_navigation.dart';
import 'package:be_loved/features/home/presentation/views/events/view/main_event_page.dart';
import 'package:be_loved/features/home/presentation/views/purposes/purposes_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/main_page.dart';
import 'package:be_loved/features/profile/presentation/bloc/decor/decor_bloc.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_cubit.dart';
import 'package:be_loved/features/profile/presentation/views/parting_second_view.dart';
import 'package:be_loved/features/profile/presentation/views/second_subcription.dart';
import 'package:be_loved/features/profile/presentation/views/subscription_view.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:be_loved/my_app/presentation/controller/my_app_cubit.dart';
import 'package:be_loved/my_app/presentation/controller/my_app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/colors/color_styles.dart';
import '../bloc/tags/tags_bloc.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  bool isFirst;
  HomePage({Key? key, this.isFirst = false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();

  bool isSubOpen = false;

  List<Widget> pages = [
    const MainPage(),
    const MainEventPage(),
    const PurposesPage(),
    const ArchivePage(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetStatusUser(context: context));
    context.read<MyAppCubit>().getImage();
    context.read<EventsBloc>().add(GetEventsEvent());

    context.read<DecorBloc>().add(GetBackgroundEvent());
    context.read<AuthBloc>().add(GetUser(isFirst: widget.isFirst));
    context.read<TagsBloc>().add(GetTagsEvent());
    context.read<PurposeBloc>().add(GetAllPurposeDataEvent());
    context.read<PurposeBloc>().add(GetPromosEvent());
    context.read<SubCubit>().getStatus();
    context.read<PurposeBloc>().add(GetActualEvent());
    context.read<WebSocketBloc>().add(WebSocketEvent(sl<AuthConfig>().token!));
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
    return BlocListener<WebSocketBloc, WebSocketState>(
      listener: (context, state) {
        print(sl<AuthConfig>().user!.love!.username);
        if (state is WebSocketInviteCloseState &&
            sl<AuthConfig>().user!.love!.username.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 400), () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (BuildContext context) => const PartingSecondView(),
              ),
            );
          });
        }
      },
      child: BlocBuilder<MyAppCubit, MyAppState>(builder: (context, state) {
        if (state is MyAppLoadedState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Container(
                  color: ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/icons/heart.svg',
                    color: ColorStyles.redColor,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                        image: NetworkImage(
                            "${Config.url.url}${state.image.image}"),
                        fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          );
        } else if (state is MyAppGotoState || state is MyAppErrorState) {
          return BlocListener<EventsBloc, EventsState>(
            listener: (context, state) {
              if (state is GotSuccessEventsState) {
                context.read<MainWidgetsBloc>().add(GetMainWidgetsEvent());
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (previous, current) {
                print('state is: ' + current.toString());
                if (current is UserNeedSubscription) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondSubscriptionView(),
                    ),
                    (route) => false,
                  );
                }
                return true;
              },
              builder: (context, state) {
                if (!isSubOpen) {
                  if (state is UserNeedSubscription) {
                    isSubOpen = true;
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondSubscriptionView(),
                        ),
                        (route) => false,
                      );
                    });
                  }
                  if (widget.isFirst &&
                      BlocProvider.of<AuthBloc>(context).paymentEnabled! &&
                      context.read<AuthBloc>().user!.isSub == false &&
                      context.read<AuthBloc>().user?.testEnd == null) {
                    print('payment is: 123132');
                    isSubOpen = true;
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscriptionView(),
                        ),
                      );
                    }).then((value) {
                      setState(() {
                        if (value is bool) {
                          widget.isFirst = false;
                          isSubOpen = false;
                        }
                        widget.isFirst = false;
                        // isSubOpen = false;
                      });
                    });
                  } else if (context.read<AuthBloc>().user?.testEnd == null &&
                      context.read<AuthBloc>().user?.isSub == false) {
                    isSubOpen = true;
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SecondSubscriptionView(),
                        ),
                        (route) => false,
                      );
                    });
                  }
                }
                if (state is GetUserSuccess ||
                    state is GetUserError ||
                    state is RefreshUser) {
                  if (state is GetUserSuccess) {
                    if (state.user.love == null) {
                      Future.delayed(const Duration(milliseconds: 400), () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                const PartingSecondView(),
                          ),
                        );
                      });
                    }
                    // if (!state.user.isSub && widget.isFirst) {
                    //   Future.delayed(const Duration(milliseconds: 400), () {
                    //     Navigator.push(
                    //       context,
                    //       CupertinoPageRoute(
                    //         builder: (BuildContext context) =>
                    //             SubscriptionView(),
                    //       ),
                    //     );
                    //   });
                    // }
                  }
                  return BlocConsumer<MainScreenBloc, MainScreenState>(
                    listener: (context, state) {
                      if (state is MainScreenChangedState) {
                        if (state.currentView == 2 &&
                            context.read<PurposeBloc>().state
                                is PurposeInitialState) {
                          context
                              .read<PurposeBloc>()
                              .add(GetAllPurposeDataEvent());
                        }
                        pageController.jumpToPage(state.currentView);
                      }
                      if (state is MainScreenSetStateState) {
                        setState(() {});
                      }
                    },
                    builder: (context, state) {
                      return Scaffold(
                        bottomNavigationBar: BottomNavigation(),
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
                    },
                  );
                }
                return Container(
                  color: ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/icons/heart.svg',
                    color: ColorStyles.redColor,
                  ),
                );
              },
            ),
          );
        }
        return Container(
          color: ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/heart.svg',
            color: ColorStyles.redColor,
          ),
        );
      }),
    );
  }
}
