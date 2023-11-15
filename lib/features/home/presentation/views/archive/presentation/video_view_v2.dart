import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoView extends StatefulWidget {
  final String url;
  final Duration? duration;
  VideoView({required this.url, required this.duration});

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  _initPlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.url);
    await videoPlayerController.initialize();

    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        customControls: const MaterialControls(
          showPlayButton: true,
        ));
    seekTo(widget.duration);
    setState(() {});
  }

  seekTo(Duration? duration) async {
    await Future.delayed(Duration(seconds: 1));
    if (widget.duration != null) {
      setState(() {
        chewieController!.videoPlayerController.seekTo(duration!);
      });
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: chewieController != null
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Stack(
                  children: [
                    Chewie(
                      controller: chewieController!,
                    ),
                    Positioned(
                      top: 5.h,
                      left: 0,
                      child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20.w,
                              ),
                              Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30.w,
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
