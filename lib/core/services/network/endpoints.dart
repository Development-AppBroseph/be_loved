import 'config.dart';
import 'dart:core';

enum Endpoints {
  // Authentication
  register,
  phoneNumber,
  editProfile,
  

  //Events
  getEvents,
  addEvent,
  deleteEvent,
  editEvent,
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
        return "/events/${params![0]}/";  
      case Endpoints.editEvent:
        return "/events/${params![0]}/";  
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

