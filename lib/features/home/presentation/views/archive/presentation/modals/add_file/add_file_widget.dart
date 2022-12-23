import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/add_photo_card.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:exif/exif.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';




class AddFileWidget extends StatefulWidget {
  final Function() onTap;
  final EventEntity? editingEvent;
  const AddFileWidget({Key? key, required this.onTap, required this.editingEvent}) : super(key: key);
  @override
  State<AddFileWidget> createState() => _AddFileWidgetState();
}

class _AddFileWidgetState extends State<AddFileWidget> {
  int iconIndex = 15;

  final ScrollController scrollController = ScrollController();


  String title = 'Загрузить файлы';

  List<Uint8List> files = [];

  bool isValidate() {
    return false;
  }


  complete(){
    if(isValidate()){
    
      showLoaderWrapper(context);
     
      
    }
  }


  addFiles() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
      allowCompression: true,
      withData: true
    );
    if(result != null){
      for(var file in result.files){
        final data = await readExifFromBytes(file.bytes!);
        for(var item in data.entries){
          print('ENTRY: ${item.key} : ${item.value}');
        }
        files.add(file.bytes!);
      }
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<EventsBloc, EventsState>(
      listener: (context, state) {
        if(state is EventErrorState){
          Loader.hide();
          showAlertToast(state.message);
        }
        if(state is EventInternetErrorState){
          Loader.hide();
          showAlertToast('Проверьте соединение с интернетом!');
        }
        if(state is EventAddedState){
          Loader.hide();
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {});
        },
        child: CupertinoCard(
          radius: BorderRadius.vertical(
            top: Radius.circular(80.r),
          ),
          elevation: 0,
          margin: EdgeInsets.zero,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutQuint,
            height: 455.h+(
              files.isEmpty
              ? 0
              : files.length <= 3 
              ? 45.h
              : files.length <= 6
              ? 175.h
              : 295.h
            ),
            width: MediaQuery.of(context).size.width,
            color: const Color.fromRGBO(0, 0, 0, 0),
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 57.h,
                          ),
                          SizedBox(
                            width: 378.w,
                            height: 38.h,
                            child: ClipPath.shape(
                              shape: SquircleBorder(
                                radius: BorderRadius.circular(20.r)
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      color: ColorStyles.blackColor,
                                    ),
                                  ),
                                  Positioned.fill(
                                    right: 240.w,
                                    child: Container(
                                      color: ColorStyles.primarySwath,
                                    ),
                                  ),
                                  Positioned.fill(
                                    left: 20.w,
                                    right: 20.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Хранилище:', style: TextStyles(context).white_15_w800,),
                                        Text('10/100 ГБ', style: TextStyles(context).white_15_w800,),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                          SizedBox(
                            height: files.isEmpty ? 48.h : 20.h,
                          ),
                          AddPhotoCard(
                            onTap: addFiles,
                            color: ColorStyles.backgroundColorGrey,
                          ),
                          if(files.isEmpty)
                          ...[
                          SizedBox(
                            height: 30.h,
                          ),
                          Text('*Можно добавить до 10 файлов за один раз', style: TextStyles(context).grey_15_w700,),
                          SizedBox(
                            height: 77.h,
                          ),
                          ]
                          else
                          ...[
                            SizedBox(
                              height: 12.h,
                            ),
                            Wrap(
                              spacing: 4.w,
                              runSpacing: 4.w,
                              children: List.generate(files.length >= 9 ? 9 : files.length, (index) 
                                => _buildFileItem(index, files[index])
                              ),
                            ),
                            SizedBox(
                              height: 62.h,
                            ),
                          ],
                          CustomButton(
                            color: ColorStyles.primarySwath, 
                            text: 'Готово', 
                            textColor: Colors.white,
                            validate: isValidate(), 
                            onPressed: (){}
                          )
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: ColorStyles.greyColor,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          title,
                          style: TextStyles(context).grey_15_w800,
                        )
                      ],
                    )))
              ],
            )),
        ),
      ),
    );
  }








  Widget _buildFileItem(int index, Uint8List file){
    return SizedBox(
      width: 123.w,
      height: 124.w,
      child: ClipPath.shape(
        shape: SquircleBorder(
          radius: index == 0
          ? BorderRadius.only(
            topLeft: Radius.circular(20.r)
          )
          : index == 2
          ? BorderRadius.only(
            topRight: Radius.circular(20.r)
          )
          : index == 6
          ? BorderRadius.only(
            bottomLeft: Radius.circular(20.r)
          )
          : index == 8
          ? BorderRadius.only(
            bottomRight: Radius.circular(20.r)
          )
          : BorderRadius.zero
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                image: MemoryImage(file),
                fit: BoxFit.cover,
              )
            ),
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      files.removeAt(files.indexOf(file));
                    });
                  },
                  child: ClipPath.shape(
                    shape: SquircleBorder(
                      radius: BorderRadius.circular(22.r)
                    ),
                    child: Container(
                      width: 33.w,
                      height: 33.w,
                      color: Colors.white.withOpacity(0.7),
                      padding: EdgeInsets.all(10.5.w),
                      child: SvgPicture.asset(
                        SvgImg.add,
                        color: ColorStyles.blackColor.withOpacity(0.7),
                      )

                    )
                  ),
                )
              ),
            )
          ],
        )
      ),
    );
  }
}
