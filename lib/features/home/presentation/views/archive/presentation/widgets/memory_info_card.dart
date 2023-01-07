import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MemoryInfoCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ArchiveBloc archiveBloc = context.read<ArchiveBloc>();
    return BlocConsumer<ArchiveBloc, ArchiveState>(listener: (context, state) {
      if (state is ArchiveErrorState) {
        Loader.hide();
        showAlertToast(state.message);
      }
      if (state is ArchiveInternetErrorState) {
        Loader.hide();
        showAlertToast('Проверьте соединение с интернетом!');
      }
    }, builder: (context, state) {
      return SizedBox(
        width: 378.w,
        height: 38.h,
        child: archiveBloc.memoryEntity == null
        ? Container(color: ColorStyles.blackColor,) 
        : archiveBloc.memoryEntity!.fullFilled()
        ? _buildFullFilled(context)
        : ClipPath.shape(
            shape: SquircleBorder(
                radius: BorderRadius.circular(20.r)),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: ColorStyles.blackColor,
                  ),
                ),
                Positioned.fill(
                  right: 378.w-(378.w/100 * double.parse(archiveBloc.memoryEntity!.getFilledMemoryInPercent())),
                  child: Container(
                    color: ColorStyles.primarySwath,
                  ),
                ),
                Positioned.fill(
                  left: 20.w,
                  right: 20.w,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Хранилище:',
                        style: TextStyles(context)
                            .white_15_w800,
                      ),
                      Text(
                        sl<AuthConfig>().memoryEntity ==
                              null
                          ? '0/10 ГБ'
                          : '${sl<AuthConfig>().memoryEntity!.getInGigabytesCurrentSize()}/${sl<AuthConfig>().memoryEntity!.getInGigabytesMaxSize()} ГБ',
                        style: TextStyles(context)
                            .white_15_w800,
                      ),
                    ],
                  ),
                )
              ],
            )),
        );
      }
    );
  }




  Widget _buildFullFilled(BuildContext context){
    return CupertinoCard(
      margin: EdgeInsets.zero,
      elevation: 0,
      padding: EdgeInsets.zero,
      color: ColorStyles.blackColor,
      radius: BorderRadius.circular(20.r),
      child: Stack(
        children: [
          Positioned.fill(
            child: CupertinoCard(
                elevation: 0,
                margin: EdgeInsets.fromLTRB(3.w, 3.5.w, 3.w, 3.w),
                radius: BorderRadius.circular(12.r),
                color: Colors.white),
          ),
          Positioned.fill(
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                Text(
                  'Хранилище:',
                  style: TextStyles(context)
                      .black_15_w800,
                ),
                Text(
                  sl<AuthConfig>().memoryEntity ==
                        null
                    ? '0/10 ГБ'
                    : '${sl<AuthConfig>().memoryEntity!.getInGigabytesMaxSize()}/${sl<AuthConfig>().memoryEntity!.getInGigabytesMaxSize()} ГБ',
                  style: TextStyles(context)
                      .black_15_w800,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}