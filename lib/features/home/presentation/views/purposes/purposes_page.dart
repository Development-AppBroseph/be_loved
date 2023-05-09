import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/main_config_app.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/home/domain/entities/purposes/actual_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/promos_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/moments/moments_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/empty_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/promos_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_menu_card.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
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
  bool isLoading = false;
  bool isOpacity = false;
  final StreamController<bool> streamController = StreamController();
  final ScrollController scrollController = ScrollController();

  ScrollController controller = ScrollController();
  void _showLoader() {
    setState(() {
      isLoading = true;
    });

    context.read<PurposeBloc>().add(GetAllPurposeDataEvent());
    streamController.sink.add(true);
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutQuint,
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isOpacity = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isOpacity = false;
      });
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      isLoading = false;
      streamController.sink.add(false);
    });
  }

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
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset.toInt() < -40 && !isLoading) {
        _showLoader();
      }
      // print('offset: ' + scrollController.offset.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PurposeBloc bloc = context.read<PurposeBloc>();
    return Stack(
      children: [
        SizedBox(
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
                  controller: scrollController,
                  // physics: const ClampingScrollPhysics(),
                  slivers: [
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        StreamBuilder<bool>(
          stream: streamController.stream,
          initialData: false,
          builder: (context, snapshot) {
            print('Изменения');
            if (snapshot.data!) {
              return Stack(
                children: [
                  backdropFilterExample(
                    context,
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      // color: Colors.black,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOutQuint,
                    top: isOpacity ? 80.h : -100,
                    left: MediaQuery.of(context).size.width / 2 - 20.w,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 40.h,
                        width: 40.w,
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
                  )
                ],
              );
            } else {
              return const SizedBox(
                width: 0,
                height: 0,
              );
            }
          },
        ),
      ],
    );
  }

  Widget backdropFilterExample(BuildContext context, Widget child) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        child,
        AnimatedOpacity(
          opacity: isOpacity ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: const Color.fromRGBO(44, 44, 46, 0.1),
            ),
          ),
        )
      ],
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
