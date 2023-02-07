import 'package:be_loved/core/utils/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// {@template on_finished}
/// Коллбэк при успешной оплате
/// {@endtemplate}
typedef OnFinished = void Function(String? orderId);

/// {@template on_load}
/// Коллбэк при загрузки
/// {@endtemplate}
typedef OnLoad = void Function(bool isLoading);

/// {@template on_error}
/// Коллбэк при ошибки
/// {@endtemplate}
typedef OnError = void Function();

/// {@template web_view_payment}
/// WebView для оплаты транзакции и прохождения 3-D Secure
/// {@endtemplate}
class WebViewPayment extends StatefulWidget {
  /// {@macro web_view_payment}
  const WebViewPayment({
    Key? key,
    required this.logger,
    required this.formUrl,
    required this.returnUrl,
    this.failUrl,
    this.onFinished,
    this.onLoad,
    this.onError,
    this.onWebViewCreated,
  }) : super(key: key);

  /// {@macro sberbank_acquiring_config}
  final BaseLogger logger;

  /// URL-адрес платёжной формы, на который нужно перенаправить браузер клиента.
  /// Не возвращается, если регистрация заказа не удалась по причине ошибки, детализированной в errorCode.
  /// Можно получить из `RegisterResponse` поле `failUrl`.
  final String formUrl;

  /// Адрес, на который требуется перенаправить пользователя в случае успешной оплаты.
  /// Можно получить из `RegisterRequest` поле `returnUrl`.
  final String returnUrl;

  /// Адрес, на который требуется перенаправить пользователя в случае неуспешной оплаты.
  /// Можно получить из `RegisterRequest` поле `failUrl`.
  final String? failUrl;

  /// {@macro on_finished}
  final OnFinished? onFinished;

  /// {@macro on_load}
  final OnLoad? onLoad;

  /// {@macro on_error}
  final OnError? onError;

  /// Контроллер для управления webview
  final WebViewCreatedCallback? onWebViewCreated;

  @override
  _WebViewPaymentState createState() => _WebViewPaymentState();
}

class _WebViewPaymentState extends State<WebViewPayment> {
  bool hasSent = false;

  @override
  Widget build(BuildContext context) {
    final String? failUrl = widget.failUrl;

    return WebView(
      initialUrl: widget.formUrl,
      gestureNavigationEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: widget.onWebViewCreated,
      onPageStarted: (String url) {
        print('object ${url}');
        // widget.logger
        //     .log(name: 'WebViewPayment', message: 'onPageStarted: $url');

        // if (url == widget.formUrl) {
        //   widget.onLoad?.call(true);
        // }

        if (url.contains(widget.failUrl!)) {
          hasSent = true;
          print('object orderId ${getOrderId(url)}');
          widget.onFinished?.call(getOrderId(url));
          // Navigator.of(context).pop();
        }

        // if (failUrl != null && url.contains(failUrl)) {
        //   hasSent = true;
        //   widget.onError?.call();
        // }
      },
      onPageFinished: (String url) async {
        // widget.logger
        //     .log(name: 'WebViewPayment', message: 'onPageFinished: $url');

        // if (url == widget.formUrl) {
        //   widget.onLoad?.call(false);
        // }

        // if (!hasSent && url.contains(widget.returnUrl)) {
        //   widget.onFinished?.call(getOrderId(url));
        // }

        // if (!hasSent && (failUrl != null && url.contains(failUrl))) {
        //   widget.onError?.call();
        // }
      },
    );
  }

  String? getOrderId(String url) {
    final Uri? _url = Uri.tryParse(url);

    return _url?.queryParameters['orderId'];
  }
}
