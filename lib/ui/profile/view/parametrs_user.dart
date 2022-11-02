import 'package:be_loved/ui/profile/widget/main_file/parametrs_user_bottomsheet.dart';
import 'package:flutter/material.dart';

class ParametrsUserPage extends StatelessWidget {
  const ParametrsUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              builder: (context) => DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.8,
                maxChildSize: 0.85,
                builder: (context, scrollController) =>
                    SingleChildScrollView(
                      controller: scrollController,
                  child:const  ParametrsUserBottomsheet(),
                ),
              ),
            );
          },
          child: const Text('data'),
        ),
      ),
    );
  }
}
