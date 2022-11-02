import 'package:be_loved/core/helpers/images.dart';
import 'package:be_loved/ui/profile/widget/devides_settings.dart';
import 'package:be_loved/ui/profile/widget/grey_line_for_bottomsheet.dart';
import 'package:flutter/material.dart';

import '../avatar_and_name_user.dart';

class ParametrsUserBottomsheet extends StatelessWidget {
  const ParametrsUserBottomsheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        BottomSheetGreyLine(),
        AvatarAndNameUser(),
        DevideSettings(
          title: "Аккаунт",
          subtitle: "Информация",
          haveToggleSwitch: false,
          icon: SvgImg.person,
        ),
        DevideSettings(
          title: "Отношения",
          subtitle: "Настроить",
          haveToggleSwitch: false,
          icon: SvgImg.logov2,
        ),
        DevideSettings(
          title: "Виджеты",
          subtitle: "Настроить",
          haveToggleSwitch: false,
          icon: SvgImg.widgets,
        ),
        DevideSettings(
          title: "Оформление",
          subtitle: "Изменить",
          haveToggleSwitch: false,
          icon: SvgImg.documents,
        ),
        SizedBox(
          height: 87,
        ),
        DevideSettings(
          title: "Оформление",
          subtitle: "Изменить",
          haveToggleSwitch: false,
          icon: SvgImg.person,
        ),
        DevideSettings(
          title: "Оформление",
          subtitle: "Изменить",
          haveToggleSwitch: true,
          icon: SvgImg.notification,
        ),
        SizedBox(
          height: 60,
        ),
      ],
    );
  }
}
