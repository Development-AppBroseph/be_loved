

import 'package:be_loved/constants/main_config_app.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

String convertToRangeDates(GalleryGroupFilesEntity entity){ 
  DateTime startDate = entity.mainPhoto.dateTime;
  DateTime? toDate;

  String result = DateFormat('dd.MM.yyyy').format(startDate);


  if((entity.mainVideo != null && entity.mainVideo!.dateTime.day != startDate.day)){
    toDate = entity.mainVideo!.dateTime;
  }
  if(entity.additionalFiles.isNotEmpty && entity.additionalFiles.last.dateTime.day != startDate.day){
    toDate = entity.additionalFiles.last.dateTime;
  }

  if(toDate != null){
    result = '${startDate.day} — ${DateFormat('d MMM', 'ru').format(toDate)}';
  }

  if(toDate == null){
    DateTime now = DateTime.now();
    //Is today
    if(DateTime.now().difference(startDate).inDays == 0){
      return 'Сегодня';
    }
  }

  return result;

}







int galleryGroupingCount(GalleryGroupFilesEntity entity){
  int files = entity.additionalFiles.length;
  if(files > 9){
    files = 9;
  }else if(files < 9 && files > 6){
    files = 6;
  }else if(files < 6 && files > 3){
    files = 3;
  }else if(files < 3){
    files = 0;
  }
  return files; 
}






double getCoordinateFromExifString(String item){
  List<String> coordinates = item.replaceAll(RegExp('\\['), '').replaceAll(RegExp('\\]'), '').split(', ');
  List<String> crds = coordinates.last.split('/');
  return int.parse(coordinates[0]) + int.parse(coordinates[1])/60;
}

Future<String> getPlaceFromCoordinate(double lat, double long) async{
  String place = '';
  final YandexGeocoder geocoder = YandexGeocoder(apiKey: MainConfigApp.mapAPI);
  final GeocodeResponse geocodeFromPoint = await geocoder.getGeocode(GeocodeRequest(
        geocode: PointGeocode(latitude: lat, longitude: long),
        lang: Lang.ru,
        kind: KindRequest.house
      ));
  if(geocodeFromPoint.response!.geoObjectCollection!.metaDataProperty!.geocoderResponseMetaData!.found != '0' && geocodeFromPoint.firstAddress != null && geocodeFromPoint.firstAddress!.components != null){
    geocodeFromPoint.firstAddress!.components!.forEach((component) {
      if(component.kind == KindResponse.locality){
        if(place == ''){
          place = 'г.${component.name ?? ''}';
        }else{
          place = '$place, г.${component.name ?? ''}';
        }
      }else if(component.kind == KindResponse.country){
        if(place == ''){
          place = component.name ?? '';
        }else{
          place = '${component.name ?? ''}, $place';
        }
      }
    });
  }
  print('PLACE: ${place} ----');

  return place;
}