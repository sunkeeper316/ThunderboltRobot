import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  static final _privacyPolicyUrl = Uri.parse(
    'https://sunkeeper316.github.io/thunderbolt_privacy_policy/',
  );

  late final WebViewController _webViewController;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _loadingProgress = progress);
          },
        ),
      )
      ..loadRequest(_privacyPolicyUrl);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF020817),
    appBar: AppBar(
      title: const Text('隱私權政策與服務條款'),
      backgroundColor: const Color(0xFF020817),
      foregroundColor: const Color(0xFFEAFBFF),
      elevation: 0,
    ),
    body: Stack(
      children: [
        WebViewWidget(controller: _webViewController),
        if (_loadingProgress < 100)
          LinearProgressIndicator(
            value: _loadingProgress == 0 ? null : _loadingProgress / 100,
            backgroundColor: const Color(0xFF09182A),
            color: const Color(0xFF55DEFF),
          ),
      ],
    ),
  );
}
