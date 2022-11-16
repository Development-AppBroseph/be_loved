import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

showLoaderWrapper(BuildContext context){
  return Loader.show(
    context,
    progressIndicator: LoadingAnimationWidget.fallingDot(
      color: ColorStyles.greyColor,
      size: 35,
    ),
  );
}