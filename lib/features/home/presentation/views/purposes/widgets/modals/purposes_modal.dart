import 'dart:io';

import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/purpose/purpose_bloc.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/empty_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_card.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_menu_card.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PurposesModal extends StatefulWidget {
  final Function(PurposeEntity purposeEntity) onSelect;
  PurposesModal({required this.onSelect});
  @override
  State<PurposesModal> createState() => _PurposesModalState();
}

class _PurposesModalState extends State<PurposesModal> {
  List<String> data = [
    'Все',
    'Доступные',
    'В процессе',
  ];

  int selectedType = 0;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (context.read<PurposeBloc>().state is PurposeInitialState) {
      context.read<PurposeBloc>().add(GetAllPurposeDataEvent());
      
    }
  }

  @override
  Widget build(BuildContext context) {
    PurposeBloc bloc = context.read<PurposeBloc>();

    return BlocListener<PurposeBloc, PurposeState>(
        listener: (context, state) {
          if (state is PurposeErrorState) {
            Loader.hide();
            showAlertToast(state.message);
          }
          if (state is PurposeInternetErrorState) {
            Loader.hide();
            showAlertToast('Проверьте соединение с интернетом!');
          }
        },
        child: CupertinoCard(
          radius: BorderRadius.vertical(
            top: Radius.circular(80.r),
          ),
          color: ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
          elevation: 0,
          margin: EdgeInsets.zero,
          child: SizedBox(
            height: 750.h,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
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
                    Container(
                      height: 5.h,
                      width: 100.w,
                      margin: EdgeInsets.only(top: 7.h, bottom: 10.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: const Color(0xff969696)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 18.5.h),
                      child: Text(
                        "Выбрать цель",
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: const Color(0xff969696),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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
                                    selectedType: selectedType,
                                    isGrey: true,
                                  )));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 39.h,
                    ),

                    //..

                    //All purposes
                    if (listPurposes.isNotEmpty)
                      ...listPurposes
                          .map(
                            (e) => Container(
                              margin: EdgeInsets.only(bottom: 15.h),
                              child: GestureDetector(
                                onTap: () {
                                  widget.onSelect(e);
                                },
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
                            ),
                          )
                          .toList()
                    else
                      EmptyCard(isAvailable: selectedType == 1, isModal: true),
                  ],
                );
              }),
            ),
          ),
        ));
  }
}
