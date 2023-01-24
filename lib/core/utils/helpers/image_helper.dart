
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

Future<File> flipHorizontalImage(File _image) async {
  final String tempPath = (await getTemporaryDirectory()).path;
  final int epoch = DateTime.now().millisecondsSinceEpoch;
  final String outputPath = "$tempPath/IMG_$epoch.jpeg";

  var bytes = await _image.readAsBytes();
  IMG.Image src = IMG.decodeImage(bytes)!;
  src = IMG.flipHorizontal(src);
  var jpg = IMG.encodeJpg(src);
  _image.delete();
  _image = await File(outputPath).writeAsBytes(jpg);
  return _image;
}



Future<File?> downloadFile(String url) async {
  HttpClient httpClient = new HttpClient();
  File file;
  String? filePath;
  String myUrl = '';

  try {
    myUrl = url;
    var request = await httpClient.getUrl(Uri.parse(myUrl));
    var response = await request.close();
    if(response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      final int epoch = DateTime.now().millisecondsSinceEpoch;
      
      final String tempPath = (await getTemporaryDirectory()).path;
      filePath = '$tempPath/VID_$epoch.mp3';
      file = File(filePath);
      await file.writeAsBytes(bytes);
    }
    else
      filePath = null;
  }
  catch(ex){
    filePath = null;
  }
  return filePath == null ? null : File(filePath);
}



Future<File> getImageFileFromAssets(String p) async {
  String path = p.replaceAll(RegExp('\\assets/'), '');
  print('PATH: ${path}');
  final byteData = await rootBundle.load('assets/$path');

  final String tempPath = (await getTemporaryDirectory()).path;
  final int epoch = DateTime.now().millisecondsSinceEpoch;
  final String outputPath = "$tempPath/IMG_$epoch.jpg";
  
  final file = File(outputPath);
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
}
