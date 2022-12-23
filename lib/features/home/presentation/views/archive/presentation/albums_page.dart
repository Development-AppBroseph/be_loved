import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/new_event_btn.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/event_photo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlbumsPage extends StatefulWidget {
  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    GalleryBloc galleryBloc = context.read<GalleryBloc>();
    EventsBloc eventsBloc = context.read<EventsBloc>();

    return BlocConsumer<GalleryBloc, GalleryState>(
      listener: (context, state) {
        if(state is GalleryFilesErrorState){
          Loader.hide();
          showAlertToast(state.message);
        }
        if(state is GalleryFilesInternetErrorState){
          Loader.hide();
          showAlertToast('Проверьте соединение с интернетом!');
        }
        if(state is GalleryFilesAddedState){
          Loader.hide();
        }
      },
      builder: (context, state) {
        if(state is GalleryFilesInitialState || state is GalleryFilesLoadingState){
          return Container();
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: Text('Избранное', style: TextStyles(context).black_25_w800,),
              ),
              SizedBox(height: 25.h,),
              SizedBox(
                height: 378.w,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: eventsBloc.events.length <= 3 ? eventsBloc.events.length : 3,
                  itemBuilder:(context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 25.w : 0, right: 10.w),
                      child: EventPhotoCard(
                        additionKey: null, 
                        onAdditionTap: (){}, 
                        onTap: (){

                        }, 
                        url: 'http://158.160.43.61/files/nyc_tower_smaller_bK51vN6.jpeg',
                        title: 'Парк 300-летия г.Санкт-Петербург',
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15.h,),

              NewEventBtn(
                onTap: (){}, 
                text: 'Новый альбом',
                isActive: false
              )

            ]
          ),
        );
      }, 
    );
  }
}
