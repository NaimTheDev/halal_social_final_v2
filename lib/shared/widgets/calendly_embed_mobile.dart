import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CalendlyEmbed extends StatefulWidget {
  final String calendlyUrl;

  const CalendlyEmbed({super.key, required this.calendlyUrl});

  @override
  State<CalendlyEmbed> createState() => _CalendlyEmbedState();
}

class _CalendlyEmbedState extends State<CalendlyEmbed> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final formattedUrl = '${widget.calendlyUrl}?embed_domain=yourapp.com&embed_type=Mobile';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(formattedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule a Call')),
      body: WebViewWidget(controller: _controller),
    );
  }
}