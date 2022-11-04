import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/profile/presentation/widget/avatar_and_name_user.dart';
import 'package:be_loved/features/profile/presentation/widget/devides_settings.dart';
import 'package:be_loved/features/profile/presentation/widget/grey_line_for_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParametrsUserBottomsheet extends StatelessWidget {
  const ParametrsUserBottomsheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const BottomSheetGreyLine(),
        const AvatarAndNameUser(),
        const DevideSettings(
          title: "Аккаунт",
          subtitle: "Информация",
          haveToggleSwitch: false,
          icon: SvgImg.person,
        ),
        const DevideSettings(
          title: "Отношения",
          subtitle: "Настроить",
          haveToggleSwitch: false,
          icon: SvgImg.logov2,
        ),
        const DevideSettings(
          title: "Виджеты",
          subtitle: "Настроить",
          haveToggleSwitch: false,
          icon: SvgImg.widgets,
        ),
        const DevideSettings(
          title: "Оформление",
          subtitle: "Изменить",
          haveToggleSwitch: false,
          icon: SvgImg.documents,
        ),
        SizedBox(
          height: 87.h - 24.h,
        ),
        const DevideSettings(
          title: "Оформление",
          subtitle: "Изменить",
          haveToggleSwitch: false,
          icon: SvgImg.person,
        ),
        const DevideSettings(
          title: "Оформление",
          subtitle: "Изменить",
          haveToggleSwitch: true,
          icon: SvgImg.notification,
        ),
        const SizedBox(
          height: 60,
        ),
      ],
    );
  }
}
