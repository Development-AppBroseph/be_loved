import 'dart:io';
import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/main_config_app.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/functions.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/domain/entities/purposes/actual_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/promos_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/moments/moments_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/empty_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/promos_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_menu_card.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_cubit.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_state.dart';
import 'package:be_loved/features/profile/presentation/views/subscription_view.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../relationships/relation_ships_page.dart';

class PurposesPage extends StatefulWidget {
  const PurposesPage({Key? key}) : super(key: key);

  @override
  State<PurposesPage> createState() => _PurposesPageState();
}

class _PurposesPageState extends State<PurposesPage> {
  List<String> data = ['Цели', 'Доступные', 'В процессе', 'История'];

  int selectedType = 0;
  static const _indicatorSize = 30.0;
  static const _imageSize = 30.0;

  ScrollController controller = ScrollController();

  void completePurpose(int id) {
    // showLoaderWrapper(context);
    context.read<PurposeBloc>().add(CompletePurposeEvent(target: id));
    context.read<MomentsBloc>().add(GetMomentsEvent());
  }

  void cancelPurpose(int id) {
    // showLoaderWrapper(context);
    context.read<PurposeBloc>().add(CancelPurposeEvent(target: id));
  }

  void sendPhotoPurpose(int id, File file) {
    // showLoaderWrapper(context);
    context.read<PurposeBloc>().add(
          SendPhotoPurposeEvent(path: file.path, target: id),
        );
    context.read<MomentsBloc>().add(GetMomentsEvent());
  }

  Widget _buildImage(IndicatorController controller, ParalaxConfig asset) {
    return Transform.translate(
      offset: Offset(
        0,
        (2 * (controller.value * 30.clamp(1, 10) - 5) * 6) + 30.h,
      ),
      child: OverflowBox(
        maxHeight: 50.h,
        minHeight: 50.h,
        child: Container(
          height: 50.h,
          width: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.all(10.h),
          child: Image.asset(
            'assets/images/smile.png',
            fit: BoxFit.contain,
            height: _imageSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PurposeBloc bloc = context.read<PurposeBloc>();
    return Scaffold(
      body: CustomRefreshIndicator(
        onRefresh: () async {
          context.read<PurposeBloc>().add(GetAllPurposeDataEvent());
          return;
        },
        builder: (BuildContext context, Widget child,
            IndicatorController controller) {
          return Stack(
            children: <Widget>[
              AnimatedBuilder(
                builder: (context, _) {
                  return Transform.translate(
                    offset: Offset(0.0, controller.value * 0),
                    child: child,
                  );
                },
                animation: controller,
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget? _) {
                  return SizedBox(
                    height: controller.value * _indicatorSize,
                    child: Stack(
                      children: <Widget>[
                        _buildImage(
                          controller,
                          const ParalaxConfig(
                              level: 5, image: 'assets/icons/add.svg'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
        child: BlocConsumer<PurposeBloc, PurposeState>(
          listener: (context, state) {
            if (state is PurposeErrorState) {
              Loader.hide();
              showAlertToast(state.message);
            }
            if (state is PurposeInternetErrorState) {
              Loader.hide();
              showAlertToast('Проверьте соединение с интернетом!');
            }
            if (state is CompletedPurposeState) {
              Loader.hide();
              bloc.add(GetAllPurposeDataEvent());
              bloc.add(GetPromosEvent());
            }
          },
          builder: (context, state) {
            if (state is PurposeLoadingState) {
              return SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.w),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 28.h,
                            width: 154.w,
                            margin: EdgeInsets.only(top: 56.h, bottom: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffD9D9D9),
                            ),
                          ),
                          SizedBox(
                            height: 189,
                            width: double.infinity,
                            child: CupertinoCard(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              color: const Color(0xffD9D9D9),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 38.h, bottom: 19.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  height: 38.h,
                                  width: 98.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffD9D9D9)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  height: 38.h,
                                  width: 121.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffD9D9D9)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  height: 38.h,
                                  width: 121.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xffD9D9D9)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: CupertinoCard(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              color: const Color(0xffD9D9D9),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: CupertinoCard(
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              color: const Color(0xffD9D9D9),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            List<PurposeEntity> listPurposes = [];
            List<PromosEntiti> listPromos = [];
            List<ActualEntiti> listActuals = [];
            listActuals = bloc.actual;
            //All purposes
            if (selectedType == 0) {
              listPurposes = bloc.allPurposes;
              //Available purposes
            // } else if (selectedType == 1) {
              // listPromos = bloc.promos;
            } else if (selectedType == 1) {
              listPurposes = bloc.availablePurposes;
            } else if (selectedType == 2) {
              listPurposes =
                  bloc.getPurposeListFromFullData(bloc.inProcessPurposes);
            } else if (selectedType == 3) {
              listPurposes = bloc.getPurposeListFromFullData(
                  bloc.historyPurposes,
                  isHistory: true);
            }
            return SafeArea(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  // SliverToBoxAdapter(
                  //   child: BlocBuilder<SubCubit, SubState>(
                  //     builder: (context, state) {
                  //       return Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           if (selectedType == 1 && state is SubNotHaveState)
                  //             Column(
                  //               children: [
                  //                 Container(
                  //                   margin: EdgeInsets.only(
                  //                       top: 26.h, left: 25.w, bottom: 10.h),
                  //                   child: Align(
                  //                     alignment: Alignment.centerLeft,
                  //                     child: RichText(
                  //                       text: TextSpan(
                  //                         children: <TextSpan>[
                  //                           TextSpan(
                  //                             text: 'Подписка',
                  //                             style: TextStyles(context)
                  //                                 .black_25_w800,
                  //                           ),
                  //                           TextSpan(
                  //                             text: 'Beloved++',
                  //                             style: TextStyles(context)
                  //                                 .black_25_w800
                  //                                 .copyWith(
                  //                                   color:
                  //                                       const Color(0xffFF1D1D),
                  //                                 ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 189.h,
                  //                   width: 377.w,
                  //                   child: CupertinoCard(
                  //                     margin: EdgeInsets.zero,
                  //                     color: const Color(0xff8C8C8C),
                  //                     child: Stack(
                  //                       fit: StackFit.expand,
                  //                       children: [
                  //                         Image.asset(
                  //                           Img.back,
                  //                           fit: BoxFit.cover,
                  //                           alignment: Alignment.topCenter,
                  //                         ),
                  //                         GestureDetector(
                  //                           onTap: () {
                  //                             Navigator.push(
                  //                               context,
                  //                               MaterialPageRoute(
                  //                                 builder: (context) =>
                  //                                     SubscriptionView(),
                  //                               ),
                  //                             );
                  //                           },
                  //                           child: Align(
                  //                             alignment: Alignment.bottomLeft,
                  //                             child: Container(
                  //                               margin: EdgeInsets.only(
                  //                                   left: 20.w, bottom: 15.h),
                  //                               child: CupertinoCard(
                  //                                 margin: EdgeInsets.zero,
                  //                                 elevation: 0,
                  //                                 padding: EdgeInsets.symmetric(
                  //                                     horizontal: 15.w,
                  //                                     vertical: 8.h),
                  //                                 color: ColorStyles.white,
                  //                                 radius: BorderRadius.circular(
                  //                                     20.r),
                  //                                 child: Text('Приобрести',
                  //                                     style: TextStyles(context)
                  //                                         .black_18_w800),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Align(
                  //                           alignment: Alignment.bottomRight,
                  //                           child: Container(
                  //                             margin: EdgeInsets.only(
                  //                                 bottom: 23.h, right: 70.w),
                  //                             child: Text('199₽ в месяц',
                  //                                 style: TextStyles(context)
                  //                                     .white_18_w800),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             )
                  //           else
                  //             Column(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 Container(
                  //                   margin: EdgeInsets.only(
                  //                       top: 36.h, left: 25.w, bottom: 10.h),
                  //                   child: Align(
                  //                     alignment: Alignment.centerLeft,
                  //                     child: Text(
                  //                       'Актуальное',
                  //                       style:
                  //                           TextStyles(context).black_25_w800,
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 189.h,
                  //                   child: ListView.separated(
                  //                     separatorBuilder: (context, index) =>
                  //                         Container(
                  //                       width: 10.w,
                  //                     ),
                  //                     itemCount: listActuals.length,
                  //                     shrinkWrap: true,
                  //                     scrollDirection: Axis.horizontal,
                  //                     padding: EdgeInsets.symmetric(
                  //                         horizontal: 25.w),
                  //                     physics: const BouncingScrollPhysics(),
                  //                     itemBuilder: (context, index) {
                  //                       return GestureDetector(
                  //                         onTap: () =>
                  //                             Functions.showActualDialog(
                  //                                 listActuals[index], context),
                  //                         child: SizedBox(
                  //                           height: 189.h,
                  //                           width: 358.w,
                  //                           child: CupertinoCard(
                  //                             margin: EdgeInsets.zero,
                  //                             color: const Color(0xff8C8C8C),
                  //                             child: Stack(
                  //                               fit: StackFit.expand,
                  //                               children: [
                  //                                 Image.network(
                  //                                   listActuals[index]
                  //                                       .promoDetailsEntiti
                  //                                       .photo,
                  //                                   fit: BoxFit.cover,
                  //                                 ),
                  //                                 Align(
                  //                                   alignment:
                  //                                       Alignment.bottomRight,
                  //                                   child: Container(
                  //                                     padding:
                  //                                         EdgeInsets.symmetric(
                  //                                             horizontal: 17.w,
                  //                                             vertical: 6.h),
                  //                                     decoration: BoxDecoration(
                  //                                       borderRadius:
                  //                                           BorderRadius
                  //                                               .circular(10),
                  //                                       color: sl<AuthConfig>()
                  //                                                   .idx ==
                  //                                               0
                  //                                           ? Colors.white
                  //                                               .withOpacity(
                  //                                                   0.9)
                  //                                           : ColorStyles
                  //                                               .black2Color
                  //                                               .withOpacity(
                  //                                                   0.9),
                  //                                     ),
                  //                                     margin: EdgeInsets.only(
                  //                                       top: 15.h,
                  //                                       right: 20.w,
                  //                                       bottom: 11.h,
                  //                                     ),
                  //                                     child: Text(
                  //                                       'до ${listActuals[index].promoDetailsEntiti.dateEnd!.day.toString()} ${MainConfigApp.monthsPromo[listActuals[index].promoDetailsEntiti.dateEnd!.month]}.',
                  //                                       style:
                  //                                           TextStyles(context)
                  //                                               .black_15_w800
                  //                                               .copyWith(
                  //                                                 color: sl<AuthConfig>()
                  //                                                             .idx ==
                  //                                                         0
                  //                                                     ? ColorStyles
                  //                                                         .blackColor
                  //                                                         .withOpacity(
                  //                                                             0.7)
                  //                                                     : ColorStyles
                  //                                                         .white
                  //                                                         .withOpacity(
                  //                                                         0.7,
                  //                                                       ),
                  //                                               ),
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       );
                  //                     },
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           SizedBox(
                  //             height: 38.5.h,
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ),
                  SliverAppBar(
                    backgroundColor: sl<AuthConfig>().idx == 1
                        ? ColorStyles.blackColor
                        : const Color.fromRGBO(240, 240, 240, 1.0),
                    pinned: true,
                    elevation: 0,
                    flexibleSpace: Center(
                      child: SizedBox(
                        height: 37.w,
                        child: ListView.builder(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedType = index;
                                  });
                                  if (index >= 2) {
                                    controller.animateTo(
                                        controller.position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOutQuint);
                                  } else {
                                    controller.animateTo(
                                        controller.position.minScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOutQuint);
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsets.only(
                                        right: 15.w,
                                        left: index == 0 ? 25.w : 0),
                                    height: 37.h,
                                    child: PurposeMenuCard(
                                        text: data[index],
                                        index: index,
                                        selectedType: selectedType)));
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Stack(
                        //   children: [
                        // Image.asset(
                        //   'assets/images/purpose1.png',
                        //   width: double.infinity,
                        //   height: 416.h+MediaQuery.of(context).padding.top,
                        //   fit: BoxFit.cover,
                        // ),
                        // if (bloc.seasonPurpose != null)
                        //   CachedNetworkImage(
                        //     imageUrl: bloc.seasonPurpose!.photo.contains('http')
                        //         ? bloc.seasonPurpose!.photo
                        //         : Config.url.url + bloc.seasonPurpose!.photo,
                        //     width: double.infinity,
                        //     height: 416.h + MediaQuery.of(context).padding.top,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ClipRRect(
                        //   child: BackdropFilter(
                        //     filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        //     child: SizedBox(
                        //       width: double.infinity,
                        //       height:
                        //           416.h + MediaQuery.of(context).padding.top,
                        //     ),
                        //   ),
                        // ),
                        // Positioned.fill(
                        //   top: 76.h + MediaQuery.of(context).padding.top,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         'Сезонная цель',
                        //         style: TextStyles(context).white_35_w800,
                        //       ),
                        //       SizedBox(
                        //         height: 23.h,
                        //       ),
                        //       bloc.seasonPurpose == null
                        //           ? const SizedBox.shrink()
                        //           : PurposeCard(
                        //               onCompleteTap: () {
                        //                 completePurpose(bloc.seasonPurpose!.id);
                        //               },
                        //               onPickFile: (f) {
                        //                 sendPhotoPurpose(
                        //                     bloc.seasonPurpose!.id, f);
                        //               },
                        //               onCancelTap: () {
                        //                 cancelPurpose(bloc.seasonPurpose!.id);
                        //               },
                        //               purposeEntity: bloc.seasonPurpose!,
                        //             )
                        //     ],
                        //   ),
                        // ),
                        //   ],
                        // ),

                        //Content
                        //List horizontal

                        SizedBox(
                          height: 19.5.h,
                        ),

                        //All purposes
                        if (listPurposes.isNotEmpty)
                          ...listPurposes
                              .map(
                                (e) => Container(
                                  margin: EdgeInsets.only(bottom: 15.h),
                                  child: PurposeCard(
                                    purposeEntity: e,
                                    onPickFile: (f) {
                                      sendPhotoPurpose(e.id, f);
                                    },
                                    onCompleteTap: () {
                                      completePurpose(e.id);
                                    },
                                    onCancelTap: () {
                                      cancelPurpose(e.id);
                                    },
                                  ),
                                ),
                              )
                              .toList()
                        else if (listPromos.isNotEmpty)
                          ...listPromos
                              .map(
                                (e) => Container(
                                  margin: EdgeInsets.only(bottom: 15.h),
                                  child: PromosCard(
                                    promosEntiti: e,
                                  ),
                                ),
                              )
                              .toList()
                        else
                          EmptyCard(
                            isAvailable: selectedType == 2,
                            inHistory: selectedType == 3,
                          ),

                        SizedBox(
                          height: 30.h,
                        ),

                        //Purposes
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 15.h),
                        //   child: PurposeCard(),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ActualDialog extends StatelessWidget {
  final ActualEntiti actualEntiti;
  const ActualDialog({Key? key, required this.actualEntiti}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: 25.w,
      ),
      backgroundColor: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 170.h,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: SizedBox(
                      height: 170.h,
                      width: double.infinity,
                      child: Image.network(
                        actualEntiti.promoDetailsEntiti.photo.contains('https')
                            ? actualEntiti.promoDetailsEntiti.photo
                            : 'https://beloved-app.ru${actualEntiti.promoDetailsEntiti.photo}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async => Navigator.of(context).pop(),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(9.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: sl<AuthConfig>().idx == 0
                              ? Colors.black.withOpacity(.7)
                              : ColorStyles.black2Color.withOpacity(0.7),
                        ),
                        margin: EdgeInsets.only(
                            top: 15.h, right: 20.w, bottom: 15.h),
                        child: SvgPicture.asset(
                          SvgImg.closeEventCreate,
                          height: 10.h,
                          width: 10,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 17.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: sl<AuthConfig>().idx == 0
                            ? Colors.white.withOpacity(0.9)
                            : ColorStyles.black2Color.withOpacity(0.9),
                      ),
                      margin:
                          EdgeInsets.only(top: 15.h, right: 20.w, bottom: 15.h),
                      child: Text(
                        'до ${actualEntiti.promoDetailsEntiti.dateEnd!.day.toString()} ${MainConfigApp.months[actualEntiti.promoDetailsEntiti.dateEnd!.month]}.',
                        style: TextStyles(context).black_15_w800.copyWith(
                            color: sl<AuthConfig>().idx == 0
                                ? ColorStyles.blackColor.withOpacity(0.7)
                                : ColorStyles.white.withOpacity(0.7)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 15.h, bottom: 5.h),
              child: Text(
                actualEntiti.promoDetailsEntiti.name,
                textAlign: TextAlign.start,
                style: TextStyles(context)
                    .black_24_w700
                    .copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 5.h, bottom: 30.h),
              child: Text(
                actualEntiti.promoDetailsEntiti.discription,
                textAlign: TextAlign.start,
                style: TextStyles(context)
                    .grey_15_w700
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
