import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

void shareFile(
  ByteData imageBytes,
) {
  _openTab(imageBytes);
}

void _shareFile(ByteData imageBytes) {
  final uint8ListFromBytes = imageBytes.buffer.asUint8List();
  final base64 = base64Encode(uint8ListFromBytes);
  final anchor =
      html.AnchorElement(href: 'data:application/octet-stream;base64,$base64')
        ..target = 'blank';

  anchor.download = "talk_ai.png";

  final body = html.document.body;
  if (body == null) {
    throw Exception("body is null");
  }
  body.append(anchor);
  anchor.click();
  anchor.remove();
}

Future<void> _shareFile1(
  ByteData imageBytes,
) async {
  if (!kIsWeb) {
    throw UnimplementedError('Share is only implemented on Web');
  }
  final uint8ListFromBytes = imageBytes.buffer.asUint8List();

  final blob = html.Blob(
    <Uint8List>[uint8ListFromBytes],
    // mimetype,
  );
  final url = html.Url.createObjectUrl(blob);
  final html.HtmlDocument doc = js.context['document'];
  final html.AnchorElement link = doc.createElement('a') as html.AnchorElement;
  link.href = url;
  link.download = "filename.png";
  link.click();
}

void _openTab(ByteData imageBytes) {
  final uint8ListFromBytes = imageBytes.buffer.asUint8List();
  html.Blob imageBlob = html.Blob([uint8ListFromBytes], 'image/png');

  String imageUrl = html.Url.createObjectUrl(imageBlob);

  html.window.open(imageUrl, '_blank');
}
