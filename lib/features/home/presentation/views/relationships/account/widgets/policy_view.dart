import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PolicyView extends StatelessWidget {
  const PolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.grey[200]!.withOpacity(0.3),
        foregroundColor: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
        title: Text(
          'Политика конфиденциальности',
          style: TextStyles(context).black_17_w700,
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(
            'https://beloved-app.ru/policy/index.htm',
          ),
        ),
      ),
    );
  }
}
