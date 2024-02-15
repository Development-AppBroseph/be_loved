import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/invite/presentation/invite_real_or_imaginated/invite_bloc.dart';
import 'package:be_loved/features/invite/presentation/widgets/bang_dialog.dart';
import 'package:be_loved/features/invite/presentation/widgets/header_dialog.dart';
import 'package:flutter/material.dart';

class InviteRealOrImaginated extends StatefulWidget {
  const InviteRealOrImaginated({super.key});

  @override
  State<InviteRealOrImaginated> createState() => _InviteRealOrImaginatedState();
}

class _InviteRealOrImaginatedState extends InviteRealBloc {
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
            const SizedBox(
              height: 5,
            ),
            const BangDialog(text: "Партнер"),
            const HeaderDialog(
              headerDescription:
                  "Ты можешь пригласить своего партнера, или создать вымышленного",
              headerText: "Добавь реального или создай своего партнера",
            ),
            Column(
              children: [
                Stack(
                  children: <Widget>[
                    Image.asset('assets/images/invite_real.png'),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                color: const Color.fromRGBO(32, 203, 131, 1.0),
                                text: "Создать",
                                textColor: Colors.white,
                                onPressed: goToCreateJoker,
                                validate: true,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomButton(
                                color: const Color.fromRGBO(32, 203, 131, 1.0),
                                text: "Пригласить",
                                textColor: Colors.white,
                                onPressed: goToInvite,
                                validate: true,
                              ),
                            ),
                          ],
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
                      "Назад",
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
