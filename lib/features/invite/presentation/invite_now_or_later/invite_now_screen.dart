import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/invite/presentation/invite_now_or_later/invite_now_block.dart';
import 'package:be_loved/features/invite/presentation/widgets/bang_dialog.dart';
import 'package:be_loved/features/invite/presentation/widgets/header_dialog.dart';
import 'package:flutter/material.dart';

class InviteNowOrLaterScreen extends StatefulWidget {
  const InviteNowOrLaterScreen({super.key});

  @override
  State<InviteNowOrLaterScreen> createState() => _InviteNowOrLaterScreenState();
}

class _InviteNowOrLaterScreenState extends InviteNowBloc {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 7, bottom: 55),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BangDialog(text: "Пригласить партнера"),
            const HeaderDialog(
              headerDescription:
                  "Ты можешь пользоваться приложением один или вместе со своим партнером",
              headerText: "Пригласи партнера сейчас или позже",
            ),
            Column(
              children: [
                Stack(
                  children: <Widget>[
                    Image.asset('assets/images/invite_now.png'),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        child: CustomButton(
                          color: const Color.fromRGBO(32, 203, 131, 1.0),
                          text: "Пригласить",
                          textColor: Colors.white,
                          onPressed: goToInvite,
                          validate: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    onPressed: goBack,
                    child: const Text(
                      "Пригласить позже",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
