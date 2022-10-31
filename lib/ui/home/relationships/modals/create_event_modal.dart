

import 'package:be_loved/widgets/buttons/switch_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/widgets/text_fields/default_text_form_field.dart';


showModalCreateEvent(
    BuildContext context,
    Function() onTap
  ){
  showMaterialModalBottomSheet(
    elevation: 12,
    barrierColor: Color.fromRGBO(0, 0, 0, 0.2),
    duration: Duration(milliseconds: 600),
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28.h),
        topRight: Radius.circular(28.h),
      )
    ),
    context: context, 
    builder: (context){
      TextStyle style1 = TextStyle(
        color: greyColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.w800
      );
      TextStyle style2 = TextStyle(
        color: blackColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w800
      );
      TextStyle styleBtn = TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700
      );
      
      bool switchVal1 = false;
      bool switchVal2 = false;
      bool switchVal3 = false;
      TextEditingController _controllerName = TextEditingController();
      TextEditingController _controllerDescription = TextEditingController();
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height*0.8,
            width: MediaQuery.of(context).size.width,
            color: Color.fromRGBO(0, 0, 0, 0),
            
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 78.h,),
                          DefaultTextFormField(
                            hint: 'Название',
                            controller: _controllerName,
                          ),
                          SizedBox(height: 20.h,),
                          DefaultTextFormField(
                            hint: 'Описание',
                            maxLines: 3,
                            onChange: (b){
                              setState((){});
                            },
                            controller: _controllerDescription,
                            maxLength: 50,
                          ),
                          SizedBox(height: 20.h,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: backgroundColorGrey
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                SizedBox(height: 12.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Весь день', style: style2,),
                                    SwitchBtn(
                                      onChange: (val){
                                        setState((){
                                          switchVal1 = val;
                                        });
                                      }, 
                                      value: switchVal1
                                    )
                                  ],
                                ),
                                SizedBox(height: 12.h,),
                                Container(
                                  color: greyColor,
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.h,
                                ),
                                SizedBox(height: 20.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Начало', style: style2,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        _buildTimeItem(context, '16 мар. 2022 г.'),
                                        SizedBox(width: 15.w,),
                                        _buildTimeItem(context, '23:59'),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 20.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Конец', style: style2,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        _buildTimeItem(context, '16 мар. 2022 г.'),
                                        SizedBox(width: 15.w,),
                                        _buildTimeItem(context, '23:59'),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 32.h,),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: backgroundColorGrey
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Повтор', style: style2,),
                                SwitchBtn(
                                  onChange: (val){
                                    setState((){
                                      switchVal2 = val;
                                    });
                                  }, 
                                  value: switchVal2
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: backgroundColorGrey
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Напоминание', style: style2,),
                                SwitchBtn(
                                  onChange: (val){
                                    setState((){
                                      switchVal3 = val;
                                    });
                                  }, 
                                  value: switchVal3
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h,),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: backgroundColorGrey
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Иконка', style: style2,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('😎', style: TextStyle(fontSize: 30.sp),),
                                    SizedBox(width: 20.w,),
                                    SvgPicture.asset('assets/icons/up_down_icon.svg', height: 20.h,)
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 40.h,),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: 60.h,
                                  height: 60.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: redColor,
                                    borderRadius: BorderRadius.circular(10.r)
                                  ),
                                  child: SvgPicture.asset('assets/icons/close_event_create.svg'),
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              Expanded(
                                child: GestureDetector(
                                  onTap: onTap,
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    height: 60.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: BorderRadius.circular(10.r)
                                    ),
                                    child: Text('Создать событие', style: styleBtn,),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 74.h+MediaQuery.of(context).padding.bottom,),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28.h),
                        topRight: Radius.circular(28.h),
                      ),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(0, 7.h, 0, 18.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100.w,
                          height: 5.h,
                          color: greyColor,
                        ),
                        SizedBox(height: 10.h,),
                        Text('Создать событие', style: style1,)
                      ],
                    )

                  )
                )
              ],
            )
          );
        }
      );
    }
  );
}


Widget _buildTimeItem(BuildContext context, String text){
  TextStyle style3 = TextStyle(
    color: Colors.white,
    fontSize: 15.sp,
    fontWeight: FontWeight.w700
  );
  return Container(
    decoration: BoxDecoration(
      color: greyColor3,
      borderRadius: BorderRadius.circular(7.r)
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.5.h),
    child: Text(text, style: style3,),
  );
}