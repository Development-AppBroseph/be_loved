import 'dart:async';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/core/widgets/text_fields/default_text_form_field.dart';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/albums/albums_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/modals/add_file/add_file_modal.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/selecting_gallery_page.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/add_photo_card.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/icon_select_modal.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../../core/utils/helpers/widget_position_helper.dart';

class NewAlbumWidget extends StatefulWidget {
  const NewAlbumWidget({Key? key}) : super(key: key);

  @override
  State<NewAlbumWidget> createState() => _NewAlbumWidgetState();
}

class _NewAlbumWidgetState extends State<NewAlbumWidget> {
  final ScrollController scrollController = ScrollController();
  GlobalKey iconBtn = GlobalKey();
  int iconIndex = 15;

  showIconModal() async {
    await scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOutQuint);
    iconSelectModal(
      context,
      getWidgetPosition(iconBtn),
      (index) {
        setState(() {
          iconIndex = index;
        });
        Navigator.pop(context);
      },
      iconIndex,
    );
  }

  TextStyle style2 = TextStyle(
      color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
      fontSize: 18.sp,
      fontWeight: FontWeight.w800);

  TextEditingController _controller = TextEditingController();

  List<GalleryFileEntity> selectedFiles = [];
  bool keyboardOpened = false;
  late StreamSubscription<bool> keyboardSub;


  bool isValidate() {
    return _controller.text.length > 3 && selectedFiles.isNotEmpty;
  }

  createAlbum(){
    showLoaderWrapper(context);
    context.read<AlbumsBloc>().add(AlbumAddEvent(
      albumEntity: AlbumEntity(
        id: 0,
        relationId: 0,
        name: _controller.text.trim(),
        files: selectedFiles
      )
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keyboardSub = KeyboardVisibilityController().onChange.listen((event) {
      setState(() {
        keyboardOpened = event;
      });
    });
  }


  addFiles() async{
    GalleryBloc bloc = context.read<GalleryBloc>();
    if(bloc.files.isEmpty){
      showModalAddFile(context, (){});
      return;
    }
    resetPositions();
    List<int>? files = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SelectingGalleryPage(
          files: selectedFiles.map((e) => e.id).toList(),
        ),
        transitionDuration: Duration(milliseconds: 400),
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    ));
    resetPositions();
    if(files != null){

      setState(() {
        selectedFiles = bloc.files.where((element) => files.contains(element.id)).toList();
      });
    }
  }


  resetPositions(){
    GalleryBloc bloc = context.read<GalleryBloc>();
    for(int i = 0; i < bloc.groupedFiles.length; i++){
      bloc.groupedFiles[i].topPosition = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    AlbumsBloc bloc = context.read<AlbumsBloc>();
    return BlocListener<AlbumsBloc, AlbumsState>(
      listener: (context, state) {
        if(state is AlbumAddedState){
          Loader.hide();
          Navigator.pop(context);
          bloc.add(GetAlbumsEvent());
        }
      },
      child: GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: CupertinoCard(
          radius: BorderRadius.vertical(
            top: Radius.circular(80.r),
          ),
          color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
          elevation: 0,
          margin: EdgeInsets.zero,
          child: SizedBox(
            height: 455.h + (keyboardOpened ? 100.h : 0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.h+27.h,
                        ),
                        DefaultTextFormField(
                          hint: 'Название',
                          maxLines: 1,
                          controller: _controller,
                          maxLength: 40,
                          hideCounter: true,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                          height: 57.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: ClrStyle.backToBlack2C[sl<AuthConfig>().idx]),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Иконка',
                                style: style2,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: showIconModal,
                                  onPanEnd: (d) {
                                    showIconModal();
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    children: [
                                      iconIndex == 15
                                          ? SvgPicture.asset(
                                              'assets/icons/no_icon.svg',
                                              height: 28.h,
                                              key: iconBtn,
                                            )
                                          : Image.asset(
                                              Img.smile,
                                              height: 33.h,
                                              width: 33.h,
                                              key: iconBtn,
                                            ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      SvgPicture.asset(
                                        SvgImg.upDownIcon,
                                        color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: AddPhotoCard(
                            onTap: addFiles,
                            color: ClrStyle.backToBlack2C[sl<AuthConfig>().idx],
                            text: selectedFiles.length == 0
                            ? 'Добавить файлы'
                            : selectedFiles.length == 1
                            ? 'Добавлено 1 файл'
                            : selectedFiles.length < 5 
                            ? 'Добавлено ${selectedFiles.length} файла'
                            : 'Добавлено ${selectedFiles.length} файлов',
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        CustomButton(
                          color: ColorStyles.primarySwath,
                          text: 'Создать альбом',
                          textColor: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                          validate: isValidate(),
                          onPressed: createAlbum,
                        ),
                      ],
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
                      color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
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
                          'Новый альбом',
                          style: TextStyles(context).grey_15_w800,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
