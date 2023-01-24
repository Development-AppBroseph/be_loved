import 'dart:io';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/profile/presentation/bloc/decor/decor_bloc.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class SlidingBackgroundCard extends StatelessWidget {
  final double? height;
  SlidingBackgroundCard({this.height});


  PageController pageController = PageController(); 

  animateToPage(int index, [bool isJump = false]){
    if(isJump){
      pageController.jumpToPage(index);
    }else{
      pageController.animateToPage(index, duration: const Duration(milliseconds: 1000), curve: Curves.easeInOutQuint);
    }
  }
  @override
  Widget build(BuildContext context) {
    DecorBloc decorBloc = context.read<DecorBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) => animateToPage(decorBloc.selectedIndex, true));
    return BlocConsumer<DecorBloc, DecorState>(
      listener: (context, state) {
        if (state is DecorErrorState) {
          Loader.hide();
          showAlertToast(state.message);
        }
        if (state is DecorInternetErrorState) {
          Loader.hide();
          showAlertToast(
              'Проверьте соединение с интернетом!');
        }
        if(state is DecorEditedSuccessState){
          print('ANIMATE');
          animateToPage(decorBloc.selectedIndex);
        }
      },
      builder: (context, state) {

        return SizedBox(
          width: double.infinity,
          height: height ?? 448.h,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: decorBloc.images.map((e) 
              => e.contains('assets/')
                ? Image(
                  width: double.infinity,
                  height: height ?? 448.h,
                  image: AssetImage(e),
                  fit: BoxFit.cover,
                )
                : Image(
                  width: double.infinity,
                  height: 448.h,
                  image: FileImage(File(e)),
                  fit: BoxFit.cover,
                )
            ).toList(),
          ),
        );
        // return decorBloc.images[decorBloc.selectedIndex].contains('assets/')
        //   ? Image(
        //     width: double.infinity,
        //     height: height ?? 448.h,
        //     image: AssetImage(decorBloc.images[decorBloc.selectedIndex]),
        //     fit: BoxFit.cover,
        //   )
        //   : Image(
        //     width: double.infinity,
        //     height: 448.h,
        //     image: FileImage(File(decorBloc.images[decorBloc.selectedIndex])),
        //     fit: BoxFit.cover,
        //   );
      }
    );
  }
}