import 'package:be_loved/constants/main_config_app.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/profile/domain/entities/back_entity.dart';
import 'package:be_loved/features/profile/presentation/bloc/decor/decor_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlidingBackgroundCard extends StatefulWidget {
  final double? height;
  SlidingBackgroundCard({this.height});

  @override
  State<SlidingBackgroundCard> createState() => _SlidingBackgroundCardState();
}

class _SlidingBackgroundCardState extends State<SlidingBackgroundCard> {
  PageController pageController = PageController();

  animateToPage(BackEntity back, [bool isJump = false]) {
    int index = 0;
    if (back.backPhoto != null) {
      index = back.photos.indexOf(
          back.photos.where((element) => element.id == back.backPhoto!).first);
    } else {
      index =
          (back.photos.isNotEmpty ? (back.photos.length) : 0) + back.assetPhoto;
    }
    if (isJump) {
      pageController.jumpToPage(index);
    } else {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutQuint);
    }
  }

  @override
  Widget build(BuildContext context) {
    DecorBloc decorBloc = context.read<DecorBloc>();
    // WidgetsBinding.instance.addPostFrameCallback((_) => animateToPage(decorBloc.back, true));
    return BlocConsumer<DecorBloc, DecorState>(listener: (context, state) {
      if (state is DecorErrorState) {
        Loader.hide();
        showAlertToast(state.message);
      }
      if (state is DecorInternetErrorState) {
        Loader.hide();
        showAlertToast('Проверьте соединение с интернетом!');
      }
      if (state is DecorEditedSuccessState) {
        print('ANIMATE');
        animateToPage(decorBloc.back!);
      }
      if (state is DecorGotSuccessState) {
        print('ANIMATE INIT');
        Future.delayed(const Duration(milliseconds: 400), () {
          animateToPage(decorBloc.back!, true);
        });
      }
    }, builder: (context, state) {
      if (state is DecorGotSuccessState) {
        print('ANIMATE INIT');
        Future.delayed(const Duration(milliseconds: 400), () {
          animateToPage(decorBloc.back!, true);
        });
      } else if (state is DecorInitialState || decorBloc.back == null) {
        return Container(
          color: Colors.black,
          width: double.infinity,
          height: widget.height ?? 500.h,
        );
      }
      return SizedBox(
        width: double.infinity,
        height: 500.h,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            ...decorBloc.back!.photos
                .map(
                  (e) => Stack(
                    children: [
                      CachedNetworkImage(
                        width: double.infinity,
                        height: 500.h,
                        fit: BoxFit.cover,
                        imageUrl: Config.url.url + e.file,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.24),
                      )
                    ],
                  ),
                )
                .toList(),
            ...MainConfigApp.decorBackgrounds
                .map(
                  (e) => Image(
                    width: double.infinity,
                    height: widget.height ?? 500.h,
                    image: AssetImage(e),
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
          ],
        ),
      );
    });
  }
}
