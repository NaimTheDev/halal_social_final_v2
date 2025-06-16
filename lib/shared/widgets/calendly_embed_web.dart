import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CalendlyEmbed extends StatefulWidget {
  final String calendlyUrl;

  const CalendlyEmbed({super.key, required this.calendlyUrl});

  @override
  State<CalendlyEmbed> createState() => _CalendlyEmbedState();
}

class _CalendlyEmbedState extends State<CalendlyEmbed> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();

    final viewType = 'calendly-${widget.calendlyUrl.hashCode}';
    final element = html.DivElement()
      ..className = 'calendly-inline-widget'
      ..dataset = {'url': widget.calendlyUrl}
      ..style.height = '100%'
      ..style.width = '100%'
      ..style.border = 'none';

    final script = html.ScriptElement()
      ..type = 'text/javascript'
      ..src = 'https://assets.calendly.com/assets/external/widget.js'
      ..async = true;

    element.append(script);

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) => element);

    _viewType = viewType;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}