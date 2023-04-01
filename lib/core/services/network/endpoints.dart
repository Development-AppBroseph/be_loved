import 'config.dart';
import 'dart:core';

enum Endpoints {
  // Authentication
  register,
  phoneNumber,
  editProfile,

  //Releation
  editRelations,
  sendFilesToMail,

  //Events
  getEvents,
  addEvent,
  deleteEvent,
  editEvent,
  changePositionEvent,

  //Tags
  getTags,
  addTag,
  editTag,
  deleteTag,

  //Archive
  //Gallery
  getGalleryFiles,
  addGalleryFile,
  deleteGalleryFiles,
  //Memory
  getSizeOfMemory,

  //Purposes
  getSeasonPurpose,
  getAvailablePurposes,
  getInProcessPurposes,
  getHistoryPurposes,
  sendPurpose,
  sendPhotoPurpose,
  getPromos,
  getActual,

  //Albums
  getAlbums,
  createAlbum,
  updateFilesAlbum,
  deleteAlbum,

  //Moments
  getMoments,
  addFavorites,

  //Events
  oldEvents,

  //Statics
  getStats,

  //Backs
  getBacks,
  setBacks,

  //Main widgets
  getMainWidgets,
  addFileWidget,
  addPurposeWidget,
  deleteFileWidget,
  deletePurposeWidget,

  //VK
  vkAuth,
  //SendNoti
  sendNoti,
  //statusSub
  statusSub
}

extension EndpointsExtension on Endpoints {
  String getPath({List<dynamic>? params}) {
    switch (this) {
      case Endpoints.register:
        return "/auth/users/";
      case Endpoints.phoneNumber:
        return "/auth/change_number";
      case Endpoints.editProfile:
        return "/auth/users";
      case Endpoints.getEvents:
        return "/events/";
      case Endpoints.addEvent:
        return "/events/";
      case Endpoints.deleteEvent:
        return "/events/";
      case Endpoints.editEvent:
        return "/events/${params![0]}";
      case Endpoints.editRelations:
        return "/relations/";
      case Endpoints.getTags:
        return "/events/tags";
      case Endpoints.addTag:
        return "/events/tags";
      case Endpoints.editTag:
        return "/events/tags/${params![0]}";
      case Endpoints.deleteTag:
        return "/events/tags/${params![0]}";
      case Endpoints.changePositionEvent:
        return "/events/";
      case Endpoints.getGalleryFiles:
        return "/archive/";
      case Endpoints.addGalleryFile:
        return "/archive/";
      case Endpoints.deleteGalleryFiles:
        return "/archive/del";
      case Endpoints.getSizeOfMemory:
        return "/archive/size";
      case Endpoints.getSeasonPurpose:
        return "/targets/season";
      case Endpoints.getAvailablePurposes:
        return "/targets/";
      case Endpoints.sendPurpose:
        return "/targets/main";
      case Endpoints.getInProcessPurposes:
        return "/targets/main";
      case Endpoints.getHistoryPurposes:
        return "/targets/completed";
      case Endpoints.sendPhotoPurpose:
        return "/targets/main/${params![0]}";
      case Endpoints.getAlbums:
        return "/archive/album";
      case Endpoints.createAlbum:
        return "/archive/album";
      case Endpoints.updateFilesAlbum:
        return "/archive/album/${params![0]}";
      case Endpoints.deleteAlbum:
        return "/archive/album/${params![0]}";
      case Endpoints.getMoments:
        return "/archive/moments";
      case Endpoints.addFavorites:
        return "/archive/${params![0]}";
      case Endpoints.oldEvents:
        return "/events/prev";
      case Endpoints.getStats:
        return "/auth/stat";
      case Endpoints.getMainWidgets:
        return "/auth/widgets";
      case Endpoints.addFileWidget:
        return "/archive/pos";
      case Endpoints.addPurposeWidget:
        return "/targets/pos";
      case Endpoints.deleteFileWidget:
        return "/archive/pos/${params![0]}";
      case Endpoints.deletePurposeWidget:
        return "/targets/pos/${params![0]}";
      case Endpoints.vkAuth:
        return "/auth/vk";
      case Endpoints.sendFilesToMail:
        return "/relations/send";
      case Endpoints.getBacks:
        return "/relations/background";
      case Endpoints.setBacks:
        return "/relations/background";
      case Endpoints.sendNoti:
        return "/notifications/send_push";
      case Endpoints.statusSub:
        return '/sub/appstatus';
      case Endpoints.getPromos:
        return '/promos/';
      case Endpoints.getActual:
        return '/promos/actual';
      default:
        return '';
    }
  }

  String get hostName {
    return Config.baseUrl.value;
  }

  String get scheme {
    return Config.baseScheme.value;
  }

  String get path {
    return Config.baseAPIpath.value;
  }

  Map<String, String> getHeaders(
      {String token = '', required Map<String, String> defaultHeaders}) {
    return {
      if (defaultHeaders != null) ...defaultHeaders,
      if (defaultHeaders == null) ...{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      if (token != '') ...{'Authorization': 'Token $token'}
    };
  }

  Uri buildURL(
      {Map<String, dynamic>? queryParameters, List<dynamic>? urlParams}) {
    var url = Uri(
        scheme: this.scheme,
        host: this.hostName,
        path: this.getPath(params: urlParams),
        queryParameters: queryParameters ?? {});
    return url;
  }
}
