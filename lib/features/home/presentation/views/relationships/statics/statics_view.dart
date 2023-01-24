import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/home/presentation/bloc/stats/stats_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/tags/tags_bloc.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';




class StaticsView extends StatelessWidget {
  final VoidCallback prevPage;
  const StaticsView({Key? key, required this.prevPage}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    StaticsBloc staticsBloc = context.read<StaticsBloc>();
    if(staticsBloc.staticsEntity == null){
      staticsBloc.add(GetStatsInfoEvent());
    }
    return Scaffold(
      backgroundColor: ClrStyle.backToBlack2C[sl<AuthConfig>().idx],
      body: BlocConsumer<StaticsBloc, StaticsState>(
        listener: (context, state) {
          if(state is StaticsErrorState){
            Loader.hide();
            showAlertToast(state.message);
          }
          if(state is StaticsInternetErrorState){
            Loader.hide();
            showAlertToast('Проверьте соединение с интернетом!');
          }
        },
        builder:(context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<TagsBloc, TagsState>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.only(top: 75.h, bottom: 46.h, left: 10.w),
                        child: GestureDetector(
                          onTap: () => prevPage(),
                          child: SizedBox(
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  SvgImg.back,
                                  height: 26.32.h,
                                  color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.w),
                                  child: Text(
                                    'Назад',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 20.sp,
                                      color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  


                  if(!(state is StaticsLoadingState || state is StaticsInitialState) && staticsBloc.staticsEntity != null)
                  ...[
                    Text('События', style: TextStyles(context).black_18_w800,),
                    _buildStatsItem(context, 'Созданных событий:', '${staticsBloc.staticsEntity!.events}'),
                    Text('Архив', style: TextStyles(context).black_18_w800,),
                    _buildStatsItem(context, 'Добавленных файлов:', '${staticsBloc.staticsEntity!.archive}'),
                    Text('Цели', style: TextStyles(context).black_18_w800,),
                    _buildStatsItem(context, 'Достигнутых целей:', '${staticsBloc.staticsEntity!.completeTargets}'),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  _buildStatsItem(BuildContext context, String title, String text){
    return SizedBox(
      width: double.infinity,
      child: CupertinoCard(
        margin: EdgeInsets.symmetric(vertical: 16.h),
        elevation: 0,
        padding: EdgeInsets.only(top: 11.h, left: 20.w, bottom: 22.h),
        color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
        decoration: BoxDecoration(
          color: ClrStyle.whiteTo17[sl<AuthConfig>().idx]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyles(context).grey_15_w700,),
            SizedBox(height: 9.h,),
            Text(text, 
              style: TextStyle(
                color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                fontSize: 50.sp,
                fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }
}
