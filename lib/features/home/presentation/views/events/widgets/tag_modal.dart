import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/main_config_app.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/core/widgets/text_fields/default_text_form_field.dart';
import 'package:be_loved/features/home/data/models/home/hashTag.dart';
import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/tags/tags_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/user_tag.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_widget.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../relationships/modals/icon_select_modal.dart';
import 'color_select.dart';

class TagModal extends StatefulWidget {
  final bool isCreate;
  const TagModal({Key? key, required this.isCreate}) : super(key: key);

  @override
  State<TagModal> createState() => _TagModalState();
}

class _TagModalState extends State<TagModal> {
  bool isPointed = false;
  ScrollController scrollController = ScrollController();
  int iconIndex = 1;
  GlobalKey iconBtn = GlobalKey();
  List<int> selectedItems = [];


  showColorModal() async {
    await scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutQuint);
    colorSelectModal(
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

  bool isValidate(){
    return titleController.text.length > 3;
  }

  void onComplete(){
    if(isValidate()){
      showLoaderWrapper(context);
      context.read<TagsBloc>().add(TagAddEvent(
        tagEntity: TagEntity(
          color: MainConfigApp.tagColors[iconIndex],
          title: titleController.text.trim(),
          relationId: sl<AuthConfig>().user!.relationId ?? 0,
          events: selectedItems,
          id: 0
        )
      ));
    }
  }

  final TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    TagsBloc tagsBloc = context.read<TagsBloc>();
    EventsBloc eventsBloc = context.read<EventsBloc>();
    return BlocListener<TagsBloc, TagsState>(
      listener: (context, state) {
        if (state is TagErrorState) {
          Loader.hide();
          showAlertToast(state.message);
        }
        if (state is TagInternetErrorState) {
          Loader.hide();
          showAlertToast('Проверьте соединение с интернетом!');
        }
        if(state is TagAddedState){
          Loader.hide();
          Navigator.pop(context);
        }
      },
      child: CupertinoCard(
        radius: BorderRadius.vertical(
          top: Radius.circular(80.r),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
        child: SizedBox(
          height: 750.h,
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              children: [
                Container(
                  height: 5.h,
                  width: 100.w,
                  margin: EdgeInsets.only(top: 7.h, bottom: 10.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: const Color(0xff969696)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 38.h),
                  child: Text(
                    widget.isCreate
                        ? "Создать тег"
                        : "Редактировать тег",
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: const Color(0xff969696),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DefaultTextFormField(
                  hint: 'Название',
                  maxLines: 1,
                  controller: titleController,
                  maxLength: 40,
                  hideCounter: true,
                  onChange: (s){
                    setState(() {});
                  },
                ),
                Container(
                  height: 57.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: ColorStyles.backgroundColorGrey),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  margin: EdgeInsets.only(top: 18.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Цвет',
                        style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 18.sp,
                            color: const Color(0xff2C2C2E),
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: showColorModal,
                          onPanEnd: (d) {
                            showColorModal();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                MainConfigApp.tagColors[iconIndex].assetPath,
                                key: iconBtn,
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              SvgPicture.asset(
                                SvgImg.upDownIcon,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 39.h),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Добавить события',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff171717),
                            ),
                          ),
                          Text(
                            'Выделено: ${selectedItems.length} событий',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff969696),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedItems = [];
                          });
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          height: 35.h,
                          width: 35.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: const Color(0xffFF1D1D),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              SvgImg.add,
                              height: 17.h,
                              width: 17.w,
                              color: const Color(0xffFF1D1D),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 308.h,
                  width: 378.w,
                  margin: EdgeInsets.only(top: 16.h),
                  child: BlocConsumer<EventsBloc, EventsState>(listener: (context, state) {
                    if (state is EventErrorState) {
                      showAlertToast(state.message);
                    }
                    if (state is EventInternetErrorState) {
                      showAlertToast('Проверьте соединение с интернетом!');
                    }
                  }, builder: (context, state) {
                    if (state is EventLoadingState) {
                      return Container();
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: eventsBloc.events.length,
                      itemBuilder: (context, i){
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          child: UserTag(
                            eventEntity: eventsBloc.events[i],
                            isSelected: selectedItems.contains(eventsBloc.events[i].id),
                            onSelect: (val) {
                              setState(() {
                                if(val){
                                  selectedItems.add(eventsBloc.events[i].id);
                                }else{
                                  selectedItems.remove(eventsBloc.events[i].id);
                                }
                              });
                            },
                          )
                        );
                      }
                      );
                    }
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 17.h),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60.h,
                        child: CustomButton(
                          color: ColorStyles.redColor,
                          text: 'Создать событие',
                          validate: true,
                          code: false,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          svg: 'assets/icons/close_event_create.svg',
                          svgHeight: 22.h,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: CustomButton(
                            color: ColorStyles.accentColor,
                            text: 'Создать тег',
                            validate: isValidate(),
                            code: false,
                            textColor: Colors.white,
                            onPressed: onComplete),
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 308.h,
                //   child: ListView.builder(
                //     itemBuilder: (context, index) {
                //       return Container();
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ),
      )
    );
  }
}
