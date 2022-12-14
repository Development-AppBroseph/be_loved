enum Config { baseUrl, baseScheme, baseAPIpath, url, ws }

const bool isDev = true;

//http://194.58.69.88/
// String myUrl = '';
// String myUrlIP = '158.160.40.127';
String myUrlIP = '158.160.43.61';

extension ConfigExtension on Config {
  String get value {
    switch (this) {
      case Config.baseUrl:
        return !isDev ? "REALURL" : myUrlIP;
      case Config.baseAPIpath:
        return '';
      case Config.ws:
        return 'ws';
      case Config.url:
        return url;
      default:
        return 'http';
    }
  }

  String get url {
    return Config.baseScheme.value +
        "://" +
        Config.baseUrl.value +
        '/' +
        Config.baseAPIpath.value;
  }

  String get ws {
    return Config.ws.value + "://" + myUrlIP + ":8000";
  }

  String get urlWithoutApi {
    return Config.baseScheme.value + "://" + Config.baseUrl.value;
  }
}
