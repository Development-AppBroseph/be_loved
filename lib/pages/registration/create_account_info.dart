import 'package:be_loved/pages/registration/registration_page_view_screens/input_name.dart';
import 'package:be_loved/pages/registration/registration_page_view_screens/set_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CreateAccountInfo extends StatefulWidget {
  const CreateAccountInfo({Key? key}) : super(key: key);

  @override
  State<CreateAccountInfo> createState() => _CreateAccountInfoState();
}

class _CreateAccountInfoState extends State<CreateAccountInfo> {

  final controller = PageController(viewportFraction: 1.0,keepPage: false);
  late int choosenPage;

  @override
  void initState() {
    setState(() {
      choosenPage = 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80.sp,
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
        title: Padding(
            padding: EdgeInsets.only(left: 20.sp, top: 40.sp, right: 6.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Image.asset('assets/back.png', width: 15.sp,),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  height: 5.sp,
                  width: 55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.sp),
                        height: 5.sp,
                        width: 5.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: choosenPage == index ? Colors.blue : choosenPage > index ? Colors.black : Colors.white,
                          border: choosenPage+1 > index ? null : Border.all(width: 1, color: Color.fromRGBO(255, 29, 29, 1.0)),
                        ),
                      );
                    },
                  ),
                )
              ],
            )
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          bottom: true,
          child: PageView(
            controller: controller,
            onPageChanged: (value) {
              setState(() {
                choosenPage = value + 1;
              });
            },
            children: const [
              InputName(),
              SetAvatar(),
            ],
          )
      ),
    );
  }
}

