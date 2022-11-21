import 'config.dart';
import 'dart:core';

enum Endpoints {
  // Authentication
  register,
  phoneNumber,
  editProfile,
  
  //Releation
  editRelations,

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
}

extension EndpointsExtension on Endpoints {
  String getPath({
    List<dynamic>? params,
  }) {
    var url = Config.url.url;
    var ws = Config.ws.ws;
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

