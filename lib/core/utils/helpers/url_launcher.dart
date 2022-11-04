
import 'package:be_loved/core/utils/toasts.dart';
import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async {
  if (!await launch(url)) showAlertToast('Не смогли открыть ссылку');
}