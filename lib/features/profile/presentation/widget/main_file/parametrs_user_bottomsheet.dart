import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/profile/presentation/widget/avatar_and_name_user.dart';
import 'package:be_loved/features/profile/presentation/widget/decor/decor_modal.dart';
import 'package:be_loved/features/profile/presentation/widget/devides_settings.dart';
import 'package:be_loved/features/profile/presentation/widget/grey_line_for_bottomsheet.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParametrsUserBottomsheet extends StatelessWidget {
  final Function() onRelationSettingsTap;
  const ParametrsUserBottomsheet({Key? key, required this.onRelationSettingsTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoCard(
      radius: BorderRadius.vertical(
        top: Radius.circular(80.r),
      ),
      color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
      elevation: 0,
      margin: EdgeInsets.zero,
      child: SizedBox(
        height: 707.h,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const BottomSheetGreyLine(),
              const AvatarAndNameUser(),
              SizedBox(
                height: 16.h,
              ),
              DevideSettings(
                title: "Аккаунт",
                subtitle: "Информация",
                haveToggleSwitch: false,
                icon: SvgImg.person,
                onPressed: () => Navigator.pop(context, 'account'),
              ),
              DevideSettings(
                title: "Отношения",
                subtitle: "Настроить",
                haveToggleSwitch: false,
                icon: SvgImg.logov2,
                onPressed: onRelationSettingsTap,
              ),
              // DevideSettings(
              //   title: "Виджеты",
              //   subtitle: "Настроить",
              //   haveToggleSwitch: false,
              //   icon: SvgImg.widgets,
              // ),
              DevideSettings(
                title: "Оформление",
                subtitle: "Изменить",
                haveToggleSwitch: false,
                icon: SvgImg.documents,
                onPressed: () {
                  Navigator.pop(context);
                  showModalDecor(context, (){});
                },
              ),
              SizedBox(
                height: 87.h - 24.h,
              ),
              DevideSettings(
                title: "Подписка BeLoved+",
                subtitle: "Подробнее",
                haveToggleSwitch: false,
                icon: SvgImg.person,
              ),
              DevideSettings(
                title: "Уведомления",
                subtitle: "от приложения",
                haveToggleSwitch: true,
                icon: SvgImg.notification,
              ),
              SizedBox(
                height: 60.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
