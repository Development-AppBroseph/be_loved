import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:be_loved/core/helpers/shared_prefs.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(14.w),
              child: CustomButton(
                color: accentColor,
                text: 'Выйти',
                validate: true,
                textColor: Colors.white,
                onPressed: () {
                  MySharedPrefs().logOut(context);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14.w),
              child: CustomButton(
                color: redColor,
                text: 'Разорвать отношения)',
                validate: true,
                textColor: Colors.white,
                onPressed: () async {
                  BlocProvider.of<AuthBloc>(context).add(LogOut(context));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
