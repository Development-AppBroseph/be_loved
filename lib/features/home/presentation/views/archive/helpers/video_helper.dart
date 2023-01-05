

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

Future<Uint8List?> getVideoFrame(String pathToVideo) async {
  final Uint8List? file = await VideoThumbnail.thumbnailData(
    imageFormat: ImageFormat.JPEG,
    video: pathToVideo,
    timeMs: 50,
  );

  return file;
}


Future<Duration> getVideoDuration(String path) async{
  VideoPlayerController controller = new VideoPlayerController.file(File(path));
  await controller.initialize();
  return controller.value.duration;
}


bool checkIsVideo(String val) {
  List<String> types = ['.mp4', '.mov'];
  bool isVideo = false;

  for(String type in types){
    if(val.contains(type) || val.contains(type.toUpperCase())){
      isVideo = true;
      break;
    }
  }
  return isVideo; 
}