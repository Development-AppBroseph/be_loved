import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/invite/presentation/widgets/back_button.dart';
import 'package:be_loved/features/invite/presentation/widgets/bang_dialog.dart';
import 'package:be_loved/features/invite/presentation/widgets/header_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmRelations extends StatefulWidget {
  final String name;
  const ConfirmRelations({super.key, required this.name});

  @override
  State<ConfirmRelations> createState() => _ConfirmRelationsState();
}

class _ConfirmRelationsState extends State<ConfirmRelations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return Container(
      padding: const EdgeInsets.only(top: 7, bottom: 55),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 50.h),
          buildBangDialog(),
          SizedBox(height: 18.h),
          buildHeaderDialog(widget.name),
          const Spacer(),
          buildImageAndButtons(),
        ],
      ),
    );
  }

  Widget buildBangDialog() {
    return const BangDialog(text: "Приглашение");
  }

  Widget buildHeaderDialog(String name) {
    return HeaderDialog(
      headerDescription: "",
      headerText: "$name хочет стать твоим партнером",
    );
  }

  Widget buildImageAndButtons() {
    return Column(
      children: [
        buildImageWithButton(),
        buildBackButton(),
      ],
    );
  }

  Widget buildImageWithButton() {
    return Stack(
      children: <Widget>[
        Image.asset('assets/images/invite_real.png'),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: CustomButton(
              validate: true,
              color: const Color.fromRGBO(32, 203, 131, 1.0),
              text: 'Принять',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBackButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: BackCustomButton(onPressed: () {
        Navigator.pop(context);
      }),
    );
  }
}
