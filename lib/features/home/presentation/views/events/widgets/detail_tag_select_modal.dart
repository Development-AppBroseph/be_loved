import 'dart:math';
import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/main_config_app.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/tags/tags_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/add_tag_icon.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/show_create_tag_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_modal.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


void tagSelectModal(
  BuildContext context,
  Offset offset,
  EventEntity event,
  Function(EventEntity id) onSelectTag
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        TagsBloc tagsBloc = context.read<TagsBloc>();
        bool isInit = false;
        bool isInitOpacity = false;
        return AlertDialog(
          insetPadding: EdgeInsets.only(top: offset.dy + 47.h, left: offset.dx - 45.h),
          // insetPadding: EdgeInsets.only(top: offset.dy + 47.h, left: offset.dx - 80.h),
          alignment: Alignment.topLeft,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconColor: Colors.transparent,
          content: SizedBox(
            height: 140.h,
            child: StatefulBuilder(builder: ((context, setState) {
              initWidgets() {
                if (isInit == false) {
                  setState(() {
                    isInit = true;
                  });
                  Future.delayed(const Duration(milliseconds: 300-100), () {
                    setState(() {
                      isInitOpacity = true;
                    });
                  });
                }
              }

              WidgetsBinding.instance
                  .addPostFrameCallback((_) => initWidgets());
                return BlocConsumer<TagsBloc, TagsState>(listener: (context, state) {
                  if (state is TagErrorState) {
                    Loader.hide();
                    showAlertToast(state.message);
                  }
                  if (state is TagInternetErrorState) {
                    Loader.hide();
                    showAlertToast('Проверьте соединение с интернетом!');
                  }
                  if (state is TagAddedState || state is TagDeletedState) {
                    Loader.hide();
                    if(state is TagAddedState){
                      state.tagEntity.events.contains(event.id);
                      context.read<EventsBloc>().add(GetEventsEvent());
                      setState((){
                        event.tagIds.add(state.tagEntity.id);
                      });
                    }
                  }
                }, builder: (context, state) {
                  if (state is TagLoadingState) {
                    return Container();
                  }

                  List<TagEntity> tagOfEvent = tagsBloc.tags.where((element) => element.events.contains(event.id),).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200-100),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 20.h,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          borderRadius: BorderRadius.circular(15.r)),
                          height: isInit ? (tagOfEvent.length == 1 ? (140.h-25.h) : 140.h): 100.h,
                          width: 160.w,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200-100),
                                opacity: isInitOpacity ? 1 : 0,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 23.w),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: tagOfEvent.length + 1,
                                    itemBuilder: (context, index) {
                                      bool isLast = tagOfEvent.isEmpty || tagOfEvent.length==index;
                                      return GestureDetector(
                                        onTap: () async {
                                          if(isLast){
                                            showModalCreateTag(context, true, null, event.id);
                                          }else{
                                            await showModalCreateTag(context, false, tagOfEvent[index]);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: isLast
                                        ? Padding(
                                          padding: EdgeInsets.symmetric(vertical: 9.h),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1.w, color: ColorStyles.greyColor),
                                              borderRadius: BorderRadius.circular(10.r)
                                            ),
                                            height: 38.h,
                                            width: 113.w,
                                            child: Center(
                                                child: Transform.rotate(
                                                      angle: pi / 4,
                                                      child:
                                                          SvgPicture.asset(SvgImg.add, height: 14.h,))
                                              )
                                          ),
                                        )
                                        : TagItemWidget(tagEntity: tagOfEvent[index]),
                                      );
                                      // return GestureDetector(
                                      //   onTap: () {
                                      //     if(isLast){
                                      //       showModalCreateTag(context, true);
                                      //     }else{
                                      //       setState((){
                                      //         if(event.tagIds.contains(tagsBloc.tags[index].id)){
                                      //           event.tagIds.remove(tagsBloc.tags[index].id);
                                      //         }else{
                                      //           event.tagIds.add(tagsBloc.tags[index].id);
                                      //         }
                                      //       });
                                      //       for(int i = 0; i < tagsBloc.tags.length; i++){
                                      //         if(tagsBloc.tags[i].id == tagsBloc.tags[index].id){
                                      //           if(tagsBloc.tags[i].events.contains(event.id)){
                                      //             tagsBloc.tags[i].events.remove(event.id);
                                      //           }else{
                                      //             tagsBloc.tags[i].events.add(event.id);
                                      //           }
                                      //         }
                                      //       }
                                      //       onSelectTag(event);
                                      //     }
                                      //   },
                                      //   child: isLast
                                      //   ? Padding(
                                      //     padding: EdgeInsets.symmetric(vertical: 9.h),
                                      //     child: Container(
                                      //       decoration: BoxDecoration(
                                      //         border: Border.all(width: 1.w, color: ColorStyles.greyColor),
                                      //         borderRadius: BorderRadius.circular(10.r)
                                      //       ),
                                      //       height: 38.h,
                                      //       width: 113.w,
                                      //       child: Center(
                                      //           child: Transform.rotate(
                                      //                 angle: pi / 4,
                                      //                 child:
                                      //                     SvgPicture.asset(SvgImg.add, height: 14.h,))
                                      //         )
                                      //     ),
                                      //   )
                                      //   : AnimatedOpacity(
                                      //     duration: const Duration(milliseconds: 400-100),
                                      //     curve: Curves.easeInOutQuint,
                                      //     opacity: event.tagIds.contains(tagsBloc.tags[index].id)
                                      //     ? 1
                                      //     : 0.5,
                                      //     child: _buildTagItem(context, tagsBloc.tags[index])
                                      //   )
                                      // );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
              );
            })),
          ),
        );
      },
    );







class TagItemWidget extends StatelessWidget {
  final TagEntity tagEntity;
  final Key? key;
  const TagItemWidget({required this.tagEntity, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 57.h,

      child: CupertinoCard(
        color: tagEntity.color.color,
        elevation: 0,
        margin: EdgeInsets.zero,
        radius: BorderRadius.circular(20.r),
        child: Container(
          width: 113.w,
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.center,
          child: Text('#${tagEntity.title}', style: TextStyles(context).white_15_w800, overflow: TextOverflow.ellipsis,)
          )
      ),
    );
  }
}
