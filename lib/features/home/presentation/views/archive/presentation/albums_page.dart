import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/new_event_btn.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/albums/albums_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/gallery/gallery_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/main_widgets/main_widgets_bloc.dart';
import 'package:be_loved/features/home/presentation/bloc/moments/moments_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/video_view_v2.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/albums/album_settings_modal.dart';
import 'package:be_loved/features/home/presentation/views/events/view/photo_view.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/event_photo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/new_album_modal.dart/new_album_modal.dart';

class AlbumsPage extends StatefulWidget {
  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  ScrollController scrollController = ScrollController();

  showAlbumSettingsModal(GlobalKey key, AlbumEntity albumEntity,
      GalleryFileEntity galleryFileEntity, bool isFavor) async {
    Future.delayed(Duration(milliseconds: 300), () {
      albumItemSettingsModal(context, getWidgetPosition(key), isFavor, () {
        Navigator.pop(context);
        showLoaderWrapper(context);
        context
            .read<AlbumsBloc>()
            .add(DeleteAlbumEvent(albumEntity: albumEntity));
      }, () {
        Navigator.pop(context);
        showLoaderWrapper(context);
        context
            .read<GalleryBloc>()
            .add(GalleryFileDeleteEvent(ids: [galleryFileEntity.id]));
      });
    });
  }

  void scrollToCenter(
      ScrollController controller, int index, AlbumEntity album) {
    controller.animateTo(
        index == 0
            ? 0
            : (album.files.length - 1) == index
                ? controller.position.maxScrollExtent
                : 388.w * index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutQuint);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (context.read<AlbumsBloc>().isResetAll) {
      context.read<AlbumsBloc>().add(GetAlbumsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    AlbumsBloc bloc = context.read<AlbumsBloc>();

    return BlocListener<GalleryBloc, GalleryState>(
      listener: (context, state) {
        if (state is GalleryFilesDeletedState) {
          Loader.hide();
          bloc.add(GetAlbumsEvent());
          context.read<MainWidgetsBloc>().add(GetMainWidgetsEvent());
          context.read<MomentsBloc>().add(GetMomentsEvent());
          context.read<GalleryBloc>().add(GetGalleryFilesEvent(isReset: true));
        }
      },
      child: BlocConsumer<AlbumsBloc, AlbumsState>(
        listener: (context, state) {
          if (state is AlbumErrorState) {
            Loader.hide();
            showAlertToast(state.message);
          }
          if (state is AlbumInternetErrorState) {
            Loader.hide();
            showAlertToast('Проверьте соединение с интернетом!');
          }
          if (state is AlbumDeletedState) {
            Loader.hide();
            bloc.add(GetAlbumsEvent());
            context
                .read<GalleryBloc>()
                .add(GetGalleryFilesEvent(isReset: true));
          }
        },
        builder: (context, state) {
          if (state is AlbumInitialState || state is AlbumLoadingState) {
            return Container();
          }
          return SingleChildScrollView(
            controller: scrollController,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (bloc.album.favorites.isNotEmpty)
                _buildAlbum(
                    context,
                    AlbumEntity(
                        id: 0,
                        relationId: 0,
                        name: 'Избранное',
                        files: bloc.album.favorites)),
              ...bloc.album.otherAlbums
                  .map((e) => _buildAlbum(context, e))
                  .toList(),
              NewEventBtn(
                  onTap: () {
                    showModalNewAlbum(context);
                  },
                  text: 'Новый альбом',
                  isActive: true),
              SizedBox(
                height: bloc.album.favorites.isEmpty &&
                        bloc.album.otherAlbums.isEmpty
                    ? (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        330.h)
                    : 140.h,
              ),
            ]),
          );
        },
      ),
    );
  }

  Widget _buildAlbum(BuildContext context, AlbumEntity albumEntity,
      {bool isFavor = false}) {
    ScrollController scrollController = ScrollController();
    print(
        'ALBUM "${albumEntity.name}" files length is: ${albumEntity.files.length}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: Text(
            albumEntity.name,
            style: TextStyles(context).black_25_w800,
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        SizedBox(
          height: 378.w,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: albumEntity.files.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.only(left: index == 0 ? 25.w : 0, right: 10.w),
                child: EventPhotoCard(
                  isVideo: albumEntity.files[index].isVideo,
                  additionKey: GlobalKey(),
                  onAdditionTap: () {},
                  onAdditionWithKeyTap: (g) {
                    scrollToCenter(scrollController, index, albumEntity);
                    showAlbumSettingsModal(g!, albumEntity,
                        albumEntity.files[index], albumEntity.id == 0);
                  },
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => albumEntity
                              .files[index].isVideo
                          ? VideoView(
                              url: albumEntity.files[index].urlToFile,
                              duration: const Duration(seconds: 0),
                            )
                          : PhotoFullScreenView(
                              file: albumEntity.files,
                              urlToImage: albumEntity.files[index].urlToFile,
                              index: index,
                            ),
                      transitionDuration: Duration(milliseconds: 400),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ));
                  },
                  url: albumEntity.files[index].isVideo
                      ? (albumEntity.files[index].urlToPreviewVideoImage ?? '')
                      : albumEntity.files[index].urlToFile,
                  title: albumEntity.files[index].place ?? '',
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
