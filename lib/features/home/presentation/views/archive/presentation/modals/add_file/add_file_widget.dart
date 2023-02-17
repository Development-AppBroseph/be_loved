import 'dart:io';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/archive/archive_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/helpers/video_helper.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/helpers/gallery_helper.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/modals/add_file/file_type_modal.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery/video_file_image.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/memory_info_card.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/add_photo_card.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:exif/exif.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../bloc/gallery/gallery_bloc.dart';

class AddFileWidget extends StatefulWidget {
  final Function() onTap;
  const AddFileWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  @override
  State<AddFileWidget> createState() => _AddFileWidgetState();
}

class _AddFileWidgetState extends State<AddFileWidget> {
  int iconIndex = 15;

  final ScrollController scrollController = ScrollController();

  GlobalKey selectKey = GlobalKey();

  String title = 'Загрузить файлы';

  List<GalleryFileEntity> filesFromGallery = [];

  bool isValidate() {
    return filesFromGallery.isNotEmpty;
  }

  complete() {
    if (isValidate()) {
      showLoaderWrapper(context);
      context.read<GalleryBloc>().add(
            GalleryFileAddEvent(galleryFileEntity: filesFromGallery),
          );
    }
  }

  showModal() {
    FileTypeModal(context, getWidgetPosition(selectKey), () {
      Navigator.pop(context);
      addFiles(false);
    }, () {
      Navigator.pop(context);
      addFiles(true);
    });
  }

  addFiles(bool isVideo) async {
    List<XFile> result = [];
    if (!isVideo) {
      result = await ImagePicker().pickMultiImage(imageQuality: 70);
    } else {
      var file = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (file != null) {
        result = [file];
      }
    }
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //     type: FileType.custom,
    //     allowMultiple: true,
    //     allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
    //     allowCompression: true,
    //     withData: true);
    for (var file in result) {
      if (filesFromGallery.length >= 10) {
        break;
      }
      Uint8List nf = await file.readAsBytes();
      await getAndSetFile(nf, file.path);
    }
    setState(() {});
  }

  Future<void> getAndSetFile(Uint8List file, String path) async {
    final data = await readExifFromBytes(file);
    String? dateTimeShooting;
    double? lat;
    double? long;
    for (var item in data.entries) {
      print('ENTRY: ${item.key} : ${item.value}');
      //Get datetime from metadata
      if (item.key == 'Image DateTime') {
        dateTimeShooting = '${item.value}';
        print('DATETIME PHOTO: $dateTimeShooting');
        //Get latitude from metadata
      } else if (item.key == 'GPS GPSLatitude') {
        lat = getCoordinateFromExifString(item.value.toString());
        print('COORDINATES LAT: $lat');
        //Get longitude from metadata
      } else if (item.key == 'GPS GPSLongitude') {
        long = getCoordinateFromExifString(item.value.toString());
        print('COORDINATES LONG: $long');
      }
    }
    filesFromGallery.add(
      GalleryFileEntity(
          id: 0,
          isFavorite: false,
          isVideo: checkIsVideo(path),
          widgetId: null,
          urlToFile: path,
          // place: 'Алматы, где то!',
          place: long != null && lat != null
              ? (await getPlaceFromCoordinate(lat, long))
              : 'undefined',
          dateTime: dateTimeShooting != null
              ? DateFormat("yyyy:MM:dd hh:mm:ss").parse(dateTimeShooting)
              : DateTime.now(),
          // dateTime: DateTime.parse('2015-01-15T20:54:47.266980'),
          size: file.buffer.lengthInBytes,
          urlToPreviewVideoImage: null,
          memoryFilePhotoForVideo:
              !checkIsVideo(path) ? null : await getVideoFrame(path),
          duration: checkIsVideo(path)
              ? (await getVideoDuration(path)).inSeconds
              : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GalleryBloc, GalleryState>(
      listener: (context, state) {
        if (state is GalleryFilesErrorState) {
          Loader.hide();
          showAlertToast(state.message);
        }
        if (state is GalleryFilesInternetErrorState) {
          Loader.hide();
          showAlertToast('Проверьте соединение с интернетом!');
        }
        if (state is GalleryFilesAddedState) {
          Loader.hide();
          Navigator.pop(context);
          Loader.hide();
          context.read<GalleryBloc>().add(GetGalleryFilesEvent(isReset: true));
          context.read<ArchiveBloc>().add(GetMemoryInfoEvent());
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
          color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
          elevation: 0,
          margin: EdgeInsets.zero,
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutQuint,
              height: 455.h +
                  (filesFromGallery.isEmpty
                      ? 0
                      : filesFromGallery.length <= 3
                          ? 45.h
                          : filesFromGallery.length <= 6
                              ? 175.h
                              : 295.h),
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
                            MemoryInfoCard(),
                            SizedBox(
                              height: filesFromGallery.isEmpty ? 48.h : 20.h,
                            ),
                            AddPhotoCard(
                              keyAdd: selectKey,
                              onTap: () {
                                if (filesFromGallery.length >= 10) {
                                  showAlertToast(
                                      'Максимум можно выбрать 10 файлов');
                                } else {
                                  showModal();
                                }
                              },
                              color:
                                  ClrStyle.backToBlack2C[sl<AuthConfig>().idx],
                              text: filesFromGallery.length == 0
                                  ? 'Добавить файлы'
                                  : filesFromGallery.length == 1
                                      ? 'Добавлено 1 файл'
                                      : filesFromGallery.length < 5
                                          ? 'Добавлено ${filesFromGallery.length} файла'
                                          : 'Добавлено ${filesFromGallery.length} файлов',
                            ),
                            if (filesFromGallery.isEmpty) ...[
                              SizedBox(
                                height: 30.h,
                              ),
                              Text(
                                '*Можно добавить до 10 файлов за один раз',
                                style: TextStyles(context).grey_15_w700,
                              ),
                              SizedBox(
                                height: 77.h,
                              ),
                            ] else ...[
                              SizedBox(
                                height: 12.h,
                              ),
                              Wrap(
                                spacing: 4.w,
                                runSpacing: 4.w,
                                children: List.generate(
                                    filesFromGallery.length >= 9
                                        ? 9
                                        : filesFromGallery.length,
                                    (index) => _buildFileItem(
                                        index, filesFromGallery[index])),
                              ),
                              SizedBox(
                                height: 62.h,
                              ),
                            ],
                            CustomButton(
                              color: ColorStyles.primarySwath,
                              text: 'Готово',
                              textColor:
                                  ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                              validate: isValidate(),
                              onPressed: complete,
                            ),
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

  Widget _buildFileItem(int index, GalleryFileEntity e) {
    print('PATHL ${e.urlToFile}');
    return SizedBox(
      width: 123.w,
      height: 124.w,
      child: ClipPath.shape(
          shape: SquircleBorder(
              radius: index == 0
                  ? BorderRadius.only(topLeft: Radius.circular(20.r))
                  : index == 2
                      ? BorderRadius.only(topRight: Radius.circular(20.r))
                      : index == 6
                          ? BorderRadius.only(bottomLeft: Radius.circular(20.r))
                          : index == 8
                              ? BorderRadius.only(
                                  bottomRight: Radius.circular(20.r))
                              : BorderRadius.zero),
          child: Stack(
            children: [
              Positioned.fill(
                  child: e.isVideo && e.memoryFilePhotoForVideo != null
                      ? Image(
                          image: MemoryImage(e.memoryFilePhotoForVideo!),
                          fit: BoxFit.cover,
                        )
                      : Image(
                          image: FileImage(File(e.urlToFile)),
                          fit: BoxFit.cover,
                        )),
              Positioned.fill(
                child: Center(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      filesFromGallery.removeAt(index);
                    });
                  },
                  child: ClipPath.shape(
                      shape:
                          SquircleBorder(radius: BorderRadius.circular(22.r)),
                      child: Container(
                          width: 33.w,
                          height: 33.w,
                          color: Colors.white.withOpacity(0.7),
                          padding: EdgeInsets.all(10.5.w),
                          child: SvgPicture.asset(
                            SvgImg.add,
                            color: ColorStyles.blackColor.withOpacity(0.7),
                          ))),
                )),
              )
            ],
          )),
    );
  }
}
