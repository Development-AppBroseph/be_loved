import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../constants/texts/text_styles.dart';

class EventPageInArchive extends StatefulWidget {
  final Function(int id) nextPage;
  final PageController pageController;
  const EventPageInArchive({Key? key, required this.pageController, required this.nextPage})
      : super(key: key);

  @override
  State<EventPageInArchive> createState() => _EventPageInArchiveState();
}

class _EventPageInArchiveState extends State<EventPageInArchive> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(
            30,
            (index) => GestureDetector(
              onTap: (){
                widget.nextPage(context.read<EventsBloc>().events.isNotEmpty ? context.read<EventsBloc>().events.first.id : 1);
              },
              child: CupertinoCard(
                margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                elevation: 0,
                child: Container(
                  height: 250.h,
                  padding: EdgeInsets.only(
                      right: 20.w, left: 20.w, top: 12.h, bottom: 21.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Прошедшее событие',
                            style: TextStyles(context).grey_15_w700,
                          ),
                          const Spacer(),
                          Text(
                            '16.03.2022',
                            style: TextStyles(context).grey_15_w800,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 33.h, bottom: 15.h),
                        child: Text(
                          'Название',
                          style: TextStyles(context).black_50_w800,
                        ),
                      ),
                      Text(
                        'Это описание, оно содержит 50 символов и располагается в 2 строки. Если оно выход...',
                        style: TextStyles(context).grey_15_w700,
                        maxLines: 2,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            'От Никнейм',
                            style: TextStyles(context).grey_15_w700,
                          ),
                          const Spacer(),
                          SvgPicture.asset(SvgImg.dots),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
