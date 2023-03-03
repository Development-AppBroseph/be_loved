import 'dart:io';
import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/empty_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_menu_card.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../relationships/relation_ships_page.dart';

class PurposesPage extends StatefulWidget {
  @override
  State<PurposesPage> createState() => _PurposesPageState();
}

class _PurposesPageState extends State<PurposesPage> {
  List<String> data = ['Все', 'Доступные', 'В процессе', 'История'];

  int selectedType = 0;
  static const _indicatorSize = 30.0;
  static const _imageSize = 30.0;

  ScrollController controller = ScrollController();

  void completePurpose(int id) {
    showLoaderWrapper(context);
    context.read<PurposeBloc>().add(CompletePurposeEvent(target: id));
  }

  void cancelPurpose(int id) {
    showLoaderWrapper(context);
    context.read<PurposeBloc>().add(CancelPurposeEvent(target: id));
  }

  void sendPhotoPurpose(int id, File file) {
    showLoaderWrapper(context);
    context
        .read<PurposeBloc>()
        .add(SendPhotoPurposeEvent(path: file.path, target: id));
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: [
          CustomRefreshIndicator(
            onRefresh: () async {
              context.read<PurposeBloc>().add(GetAllPurposeDataEvent());
              return;
            },
            builder: (BuildContext context, Widget child,
                IndicatorController controller) {
              return Stack(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget? _) {
                      return SizedBox(
                        height: controller.value * _indicatorSize,
                        child: Stack(
                          children: <Widget>[
                            /// check if it is a spoon build animated builed and attach spoon controller

                            _buildImage(
                                controller,
                                ParalaxConfig(
                                    level: 5, image: 'assets/icons/add.svg')),
                          ],
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    builder: (context, _) {
                      return Transform.translate(
                        offset: Offset(0.0, controller.value * 0),
                        child: child,
                      );
                    },
                    animation: controller,
                  ),
                ],
              );
            },
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.zero,
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
                }
              }, builder: (context, state) {
                List<PurposeEntity> listPurposes = [];
                //All purposes
                if (selectedType == 0) {
                  listPurposes = bloc.allPurposes;
                  //Available purposes
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
                return Column(
                  children: [
                    Stack(
                      children: [
                        // Image.asset(
                        //   'assets/images/purpose1.png',
                        //   width: double.infinity,
                        //   height: 416.h+MediaQuery.of(context).padding.top,
                        //   fit: BoxFit.cover,
                        // ),
                        if (bloc.seasonPurpose != null)
                          CachedNetworkImage(
                            imageUrl: bloc.seasonPurpose!.photo.contains('http')
                                ? bloc.seasonPurpose!.photo
                                : Config.url.url + bloc.seasonPurpose!.photo,
                            width: double.infinity,
                            height: 416.h + MediaQuery.of(context).padding.top,
                            fit: BoxFit.cover,
                          ),
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: SizedBox(
                              width: double.infinity,
                              height:
                                  416.h + MediaQuery.of(context).padding.top,
                            ),
                          ),
                        ),
                        Positioned.fill(
                            top: 76.h + MediaQuery.of(context).padding.top,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Сезонная цель',
                                  style: TextStyles(context).white_35_w800,
                                ),
                                SizedBox(
                                  height: 23.h,
                                ),
                                bloc.seasonPurpose == null
                                    ? const SizedBox.shrink()
                                    : PurposeCard(
                                        onCompleteTap: () {
                                          completePurpose(
                                              bloc.seasonPurpose!.id);
                                        },
                                        onPickFile: (f) {
                                          sendPhotoPurpose(
                                              bloc.seasonPurpose!.id, f);
                                        },
                                        onCancelTap: () {
                                          cancelPurpose(bloc.seasonPurpose!.id);
                                        },
                                        purposeEntity: bloc.seasonPurpose!,
                                      )
                              ],
                            ))
                      ],
                    ),

                    //Content
                    //List horizontal
                    SizedBox(
                      height: 18.h,
                    ),
                    SizedBox(
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
                                      right: 15.w, left: index == 0 ? 25.w : 0),
                                  height: 37.h,
                                  child: PurposeMenuCard(
                                      text: data[index],
                                      index: index,
                                      selectedType: selectedType)));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 39.h,
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
                    else
                      EmptyCard(
                        isAvailable: selectedType == 1,
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
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
