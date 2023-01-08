import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/albums/albums_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/moments/moments_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/video_view_v2.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/albums/album_settings_modal.dart';
import 'package:be_loved/features/home/presentation/views/events/view/photo_view.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/event_photo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MomentsPage extends StatefulWidget {
  @override
  State<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends State<MomentsPage> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MomentsBloc bloc = context.read<MomentsBloc>();

    if (bloc.state is MomentInitialState) {
      bloc.add(GetMomentsEvent());
    }
  }


  showAlbumSettingsModal(GlobalKey key, GalleryFileEntity galleryFileEntity, bool isFavor) async {
    Future.delayed(Duration(milliseconds: 300), (){
      albumItemSettingsModal(
        context,
        getWidgetPosition(key),
        isFavor,
        () {},
        (){
          Navigator.pop(context);
          showLoaderWrapper(context);
          context.read<GalleryBloc>().add(GalleryFileDeleteEvent(ids: [galleryFileEntity.id]));
        }
      );
    });
  }

  void scrollToCenter(ScrollController controller, int index, AlbumEntity album) {
    controller.animateTo(index == 0
    ? 0
    : (album.files.length-1) == index
    ? controller.position.maxScrollExtent
    : 388.w*index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutQuint
    );
  }


  @override
  Widget build(BuildContext context) {
    MomentsBloc bloc = context.read<MomentsBloc>();

    return BlocListener<GalleryBloc, GalleryState>(
      listener: (context, state) {
        if(state is GalleryFilesDeletedState){
          Loader.hide();
          bloc.add(GetMomentsEvent());
          context.read<AlbumsBloc>().add(GetAlbumsEvent());
          context.read<GalleryBloc>().add(GetGalleryFilesEvent(isReset: true));
        }
      },
      child: BlocConsumer<MomentsBloc, MomentsState>(
        listener: (context, state) {
          if(state is MomentErrorState){
            Loader.hide();
            showAlertToast(state.message);
          }
          if(state is MomentInternetErrorState){
            Loader.hide();
            showAlertToast('Проверьте соединение с интернетом!');
          }
          if(state is MomentFavoriteChangeState){
            print('FAVORITE CHANGED STATE');
            Loader.hide();
            context.read<AlbumsBloc>().isResetAll = true;
          }
        },
        builder: (context, state) {
          if(state is MomentInitialState || state is MomentLoadingState){
            return Container();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(bloc.moments.forYou.isNotEmpty)
                ...[_buildForYouBlock(context),
                SizedBox(height: 30.h,)],

                // _buildOthersBlock(context),
                ...bloc.moments.groupedOtherFiles.map((e) 
                    => _buildAlbum(context, e)
                  ).toList(),

                SizedBox(height: 50.h,),

              ]
            ),
          );
        }, 
      ),
    );
  }




  Widget _buildForYouBlock(BuildContext context){
    ScrollController scrollController = ScrollController();
    MomentsBloc bloc = context.read<MomentsBloc>();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: Text('Для вас', style: TextStyles(context).black_25_w800,),
        ),
        SizedBox(height: 25.h,),
        SizedBox(
          height: 471.w,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: bloc.moments.forYou.length,
            itemBuilder:(context, index) {
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 25.w : 0, right: 10.w),
                child: EventPhotoCard(
                  onAdditionTap: (){
                  }, 
                  onAdditionWithKeyTap: (g){
                    scrollToCenter(scrollController, index, AlbumEntity(id: 0, relationId: 0, name: '', files: bloc.moments.forYou));
                    showAlbumSettingsModal(g!, bloc.moments.forYou[index], true);
                  }, 
                  isFavorite: true,
                  isFavoriteVal: bloc.moments.forYou[index].isFavorite,
                  onFavoriteTap: (){
                    bloc.add(AddFavoritesFileEvent(id: bloc.moments.forYou[index].id));
                  },
                  height: 471.w,
                  onTap: (){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => bloc.moments.forYou[index].isVideo
                          ? VideoView(url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', duration: const Duration(seconds: 0)) 
                          : PhotoFullScreenView(urlToImage: bloc.moments.forYou[index].urlToFile),
                        transitionDuration: Duration(milliseconds: 400),
                        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                    ));
                  }, 
                  url: bloc.moments.forYou[index].isVideo 
                    ? (bloc.moments.forYou[index].urlToPreviewVideoImage ?? '') 
                    : bloc.moments.forYou[index].urlToFile,
                  title: 'Для вас', 
                  additionKey: GlobalKey(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }






  Widget _buildAlbum(BuildContext context, AlbumEntity albumEntity){
    MomentsBloc bloc = context.read<MomentsBloc>();
    ScrollController scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: albumEntity.name.substring(0, 6),
                  style: TextStyles(context).black_25_w800
                ),
                TextSpan(
                  text: albumEntity.name.substring(6),
                  style: TextStyles(context).grey_25_w800
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 25.h,),
        SizedBox(
          height: 378.w,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: albumEntity.files.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 25.w : 0, right: 10.w),
                child: EventPhotoCard(
                  isVideo: albumEntity.files[index].isVideo,
                  additionKey: GlobalKey(), 
                  isFavorite: true,
                  isFavoriteVal: albumEntity.files[index].isFavorite,
                  onFavoriteTap: (){
                    bloc.add(AddFavoritesFileEvent(id: albumEntity.files[index].id));
                  },
                  onAdditionTap: (){
                  }, 
                  onAdditionWithKeyTap: (g){
                    scrollToCenter(scrollController, index, albumEntity);
                    showAlbumSettingsModal(g!, albumEntity.files[index], true);
                  },
                  onTap: (){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => albumEntity.files[index].isVideo
                          ? VideoView(url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', duration: const Duration(seconds: 0)) 
                          : PhotoFullScreenView(urlToImage: albumEntity.files[index].urlToFile),
                        transitionDuration: Duration(milliseconds: 400),
                        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                    ));
                  }, 
                  url: albumEntity.files[index].isVideo ? (albumEntity.files[index].urlToPreviewVideoImage ?? '') : albumEntity.files[index].urlToFile,
                  title: albumEntity.files[index].place,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h,),
      ],
    );
  }
}
