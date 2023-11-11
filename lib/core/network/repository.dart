import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:be_loved/core/error/exceptions.dart';
import 'package:be_loved/core/models/payment/payment_model.dart';
import 'package:be_loved/core/models/subscriptions/subscription_variant.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/services/network/endpoints.dart';
import 'package:be_loved/core/utils/helpers/events.dart';
import 'package:be_loved/core/widgets/alerts/auth_alert.dart';
import 'package:be_loved/core/widgets/alerts/succes_auth_alert.dart';
import 'package:be_loved/features/profile/data/models/subscription_model.dart';
import 'package:be_loved/features/profile/domain/entities/subscription_entiti.dart';
import 'package:be_loved/locator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_api_availability/google_api_availability.dart';

import '../../features/auth/data/models/auth/check_is_user_exist.dart';
import '../../features/auth/data/models/auth/check_nickName.dart';
import '../../features/auth/data/models/auth/init_user.dart';
import '../../features/auth/data/models/auth/user.dart';

class Repository {
  static var uri = Uri.parse(Config.url.url);
  var dio = Dio(
    BaseOptions(
        baseUrl: Config.url.url, validateStatus: (status) => status! <= 400),
  );

  Future<PaymentModel?> createPayment(
      String paymentToken, String userPhone) async {
    String username = Config.url.shopId;
    String password = Config.url.secretKey;
    var newDio = Dio(
      BaseOptions(
        baseUrl: 'https://api.yookassa.ru/v3/',
        validateStatus: (status) => status! <= 400,
      ),
    );
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var options = Options(
      headers: {
        'Authorization': basicAuth,
        HttpHeaders.contentTypeHeader: "application/json",
        "Idempotence-Key": Random().nextInt(1000000)
      },
      validateStatus: (status) => status! <= 500,
    );

    try {
      var response = await newDio.post(
        'payments',
        options: options,
        data: {
          "payment_token": paymentToken,
          "amount": {"value": "199.00", "currency": "RUB"},
          // "capture": true,
          "description": "Заказ №${Random().nextInt(1000)}",
          "receipt": {
            // "id": "rt-1da5c87d-0984-50e8-a7f3-8de646dd9ec9",
            // "type": "payment",
            // "payment_id": "215d8da0-000f-50be-b000-0003308c89be",
            // "status": "succeeded",
            // "fiscal_document_number": "3986",
            // "fiscal_storage_number": "9288000100115785",
            // "fiscal_attribute": "2617603921",
            // "registered_at": "2019-05-13T17:56:00.000+03:00",
            // "fiscal_provider_id": "fd9e9404-eaca-4000-8ec9-dc228ead2345",
            "tax_system_code": 2,
            "customer": {
              // "full_name": "Ivanov Ivan Ivanovich",
              // "email": "email@email.ru",
              "phone": userPhone,
              // "inn": "6321341814"
            },
            "items": [
              {
                "description": "Подписка BeLoved",
                "quantity": 1.000,
                "amount": {"value": "199.00", "currency": "RUB"},
                "vat_code": 2,
                "payment_mode": "full_payment",
                "payment_subject": "commodity"
              }
            ]
          }
        },
      );
      print('RES: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200) {
        print(123);
        return PaymentModel.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        return null;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<PaymentModel?> confirmPayment(String paymentId) async {
    String username = Config.url.shopId;
    String password = Config.url.secretKey;
    var newDio = Dio(
      BaseOptions(
        baseUrl: 'https://api.yookassa.ru/v3/',
        validateStatus: (status) => status! <= 400,
      ),
    );
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var options = Options(
      headers: {
        'Authorization': basicAuth,
        HttpHeaders.contentTypeHeader: "application/json",
        "Idempotence-Key": Random().nextInt(1000000)
      },
      validateStatus: (status) => status! <= 500,
    );

    // try {
    var response = await newDio.post(
      'payments/$paymentId/capture',
      options: options,
      data: {
        "amount": {"value": "199.00", "currency": "RUB"}
      },
    );
    print('RES: ${response.statusCode} ${response.data}');
    if (response.statusCode == 200) {
      return PaymentModel.fromJson(response.data);
    }
    if (response.statusCode == 400) {
      return null;
    }
    //   return null;
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

  Future<bool?> sendPaymentSubscription(String orderId, int id) async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);

    try {
      var response = await dio.post(
        '/sub/',
        options: options,
        data: {
          "payment_id": orderId,
          "sub_id": id,
        },
      );
      print('RES: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 400) {}
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool?> sendTestSub() async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);

    try {
      var response = await dio.post(
        '/auth/test',
        options: options,
      );
      print('RES: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 400) {}
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<SubscriptionVariant>> getSuscriptionsList() async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);

    try {
      var response = await dio.get('/sub/', options: options);
      print('RES: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200) {
        List<SubscriptionVariant> list = [];
        if (response.data != '' || response.data != []) {
          for (var element in response.data) {
            list.add(SubscriptionVariant.fromJson(element));
          }
        }
        return list;
      }
      if (response.statusCode == 400) {}
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool?> editUser(File? file) async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);

    try {
      var response = await dio.put('auth/users',
          options: options,
          data: FormData.fromMap({
            'photo': MultipartFile.fromFileSync(file!.path, filename: file.path)
          }));
      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 400) {}
      return false;
    } catch (e) {
      return false;
    }
  }

  Future registration(String number) async {
    try {
      var response =
          await dio.post('auth/code_phone', data: {'phone_number': number});
      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 204) {
        return 1234;
      }
      if (response.statusCode == 400) {}
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<SubEntiti?> getStatusSub() async {
    Response response = await dio.get(
      Endpoints.statusSub.getPath(),
      options: Options(
        followRedirects: false,
        validateStatus: (status) => status! < 599,
        headers: {"Authorization": "Token ${await MySharedPrefs().token}"},
      ),
    );
    print('ResStatusCode: ${response.statusCode}\tResData: ${response.data}');
    if (response.statusCode == 200) {
      return SubModel.fromJson(response.data);
    } else if (response.statusCode == 401) {
    } else {
      // throw ServerException(message: 'Ошибка с сервером');
      return null;
    }
  }

  Future<CheckIsUserExist?> checkIsUserExist(String number, int code) async {
    GooglePlayServicesAvailability availability = await GoogleApiAvailability
        .instance
        .checkGooglePlayServicesAvailability();
    print(code);
    try {
      var response = await dio.put('auth/code_phone', data: {
        'phone_number': number,
        'code': code,
        'fcm_token': availability.value == 0 || Platform.isIOS
            ? await FirebaseMessaging.instance.getToken()
            : '',
      });
      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        return CheckIsUserExist.fromJson(response.data);
      }
      if (response.statusCode == 204) {
        return CheckIsUserExist.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        throw 'Введен неверный код';
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> checkNickName(String name) async {
    try {
      var response = await dio.get(
        'auth/code_phone',
        queryParameters: {
          'username': name,
        },
      );
      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        return CheckNickName.fromJson(response.data).exists;
      }
      if (response.statusCode == 400) {}
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> checkPhoneNumber(String phone) async {
    try {
      var response = await dio.get(
        '/auth/code_phone',
        queryParameters: {
          'phone_number': phone,
        },
      );
      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        final bool res = response.data['exists'];
        return res;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  //VK Auth
  Future<String> authVK(String code) async {
    try {
      var response = await dio.post(
        '/auth/vk',
        data: FormData.fromMap({
          'code': code,
        }),
      );
      print(
          'RES VK: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      //Уже акк есть и сразу вход
      if (response.statusCode == 200 && response.data['token'] != null) {
        return response.data['token'];
      }
      //Аккаунта нет можно продолжать регу
      if (response.statusCode == 201) {
        return 'register';
      }
      //Аккаунт уже есть
      // if (response.statusCode == 403) {
      //   return 'exist';
      // }
      return 'retry';
    } catch (e) {
      return 'retry';
    }
  }

  Future<String?> initUser(
      String secretKey, String nickname, File? xFile, String? vkCode) async {
    GooglePlayServicesAvailability availability = await GoogleApiAvailability
        .instance
        .checkGooglePlayServicesAvailability();
    try {
      final data = xFile != null
          ? {
              'secret_key': secretKey,
              'username': nickname,
              if (vkCode != null) 'code': vkCode,
              'photo':
                  MultipartFile.fromFileSync(xFile.path, filename: xFile.path),
              'fcm_token': availability.value == 0 || Platform.isIOS
                  ? await FirebaseMessaging.instance.getToken()
                  : null,
            }
          : {
              'secret_key': secretKey,
              'username': nickname,
              if (vkCode != null) 'code': vkCode,
              'fcm_token': availability.value == 0 || Platform.isIOS
                  ? await FirebaseMessaging.instance.getToken()
                  : null
            };
      var response = await dio.post(
        'auth/users',
        data: FormData.fromMap(data),
        options: Options(
          validateStatus: (status) => status! <= 450,
        ),
      );
      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');

      if (response.statusCode == 200) {
        return InitUserAnswer.fromJson(response.data).authToken;
      }
      if (response.statusCode == 400) {}
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserAnswer?> inviteUser(String phone) async {
    print('PHNE: $phone ::: ${await MySharedPrefs().token}');
    var options = Options(headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Token ${await MySharedPrefs().token}",
    }, validateStatus: (status) => status! <= 600);
    try {
      var response = await dio.post(
        '/relations/',
        data: FormData.fromMap({
          "to_phone_number": phone,
        }),
        options: options,
      );
      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        SmartDialog.show(
          animationType: SmartAnimationType.fade,
          maskColor: Colors.transparent,
          displayTime: const Duration(seconds: 5),
          clickMaskDismiss: false,
          usePenetrate: true,
          builder: (context) => const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SuccesAuthAlert(),
            ),
          ),
        );
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode! >= 400) {
        SmartDialog.show(
          animationType: SmartAnimationType.fade,
          maskColor: Colors.transparent,
          displayTime: const Duration(seconds: 5),
          clickMaskDismiss: false,
          usePenetrate: true,
          builder: (context) => const SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: AuthAlert(),
            ),
          ),
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserAnswer?> deleteInviteUser(int relationId) async {
    String? token = await MySharedPrefs().token;
    var options = Options(headers: {
      'Authorization': 'Token $token',
    }, validateStatus: (status) => status! <= 500);

    try {
      var response = await dio.put(
        '/relations/',
        data: {"relation_id": relationId, "status": 'Отменено'},
        options: options,
      );
      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode == 400) {}
      if (response.statusCode == 400) {}

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserAnswer?> getUser() async {
    String? token = await MySharedPrefs().token;
    print('token user is: $token');
    var options = Options(headers: {
      'Authorization': 'Token $token',
    });
    try {
      var response = await dio.get(
        'auth/users',
        options: options,
      );

      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        sl<AuthConfig>().token = token;
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode == 400) {}
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserAnswer?> startRelationships(String date, int relationId) async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);
    try {
      var response = await dio.put(
        '/relations/',
        data: {"date": date, "relation_id": relationId},
        options: options,
      );

      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode == 400) {}
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserAnswer?> acceptRelationships(int relationId) async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);
    try {
      var response = await dio.put(
        '/relations/',
        data: {"relation_id": relationId, "status": 'Принято'},
        options: options,
      );

      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode == 400) {}
      if (response.statusCode == 400) {}

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Events>?> getEvents() async {
    String? token = await MySharedPrefs().token;
    var options = Options(headers: {
      'Authorization': 'Token $token',
    });
    try {
      var response = await dio.get(
        'events/',
        options: options,
      );

      print(
          'RES: ${response.statusCode} ||| ${response.requestOptions.uri} ||| ${response.data}');
      if (response.statusCode == 200) {
        List<Events> events = [];
        for (final val in response.data) {
          events.add(Events.fromJson(val));
        }
        // sl<AuthConfig>().token = token;
        // return Events.fromJson(response.data);
        return events;
      }
      if (response.statusCode == 400) {}
      return null;
    } catch (e) {
      return null;
    }
  }
}
