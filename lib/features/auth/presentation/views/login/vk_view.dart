// import 'package:be_loved/core/services/database/auth_params.dart';
// import 'package:be_loved/features/theme/data/entities/clr_style.dart';
// import 'package:be_loved/locator.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class VKView extends StatefulWidget {
//   final Function(String code) onCodeReturn;
//   VKView({required this.onCodeReturn});

//   @override
//   State<VKView> createState() => _VKViewState();
// }

// class _VKViewState extends State<VKView> {
//   late WebViewController controller;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx])
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.contains('code=')) {
//               String code = request.url.split('code=').last;
//               print('VK CODE: $code');
//               widget.onCodeReturn(code);
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(
//           'https://oauth.vk.com/authorize?client_id=51521402&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends&response_type=code&v=5.52'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 5,
//         shadowColor: Colors.grey[200]!.withOpacity(0.2),
//       ),
//       body: WebViewWidget(controller: controller),
//     );
//   }
// }
