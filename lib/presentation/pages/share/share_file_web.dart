import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void shareFile(
  BuildContext _,
  ByteData imageBytes,
) {
  _download(imageBytes);
}

void _download(ByteData imageBytes) {
  final uint8ListFromBytes = imageBytes.buffer.asUint8List();
  final base64 = base64Encode(uint8ListFromBytes);
  final href = 'data:application/octet-stream;base64,$base64';

  html.AnchorElement anchorElement = new html.AnchorElement(href: href);
  anchorElement.download = "talk_ai.png";
  anchorElement.click();
}

void _shareFile(ByteData imageBytes) {
  final uint8ListFromBytes = imageBytes.buffer.asUint8List();
  final base64 = base64Encode(uint8ListFromBytes);
  final href = 'data:application/octet-stream;base64,$base64';
  final anchor = html.AnchorElement(href: href)..target = 'blank';

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
  final imageBlob = html.Blob([uint8ListFromBytes], 'image/png');

  final imageUrl = html.Url.createObjectUrl(imageBlob);

  html.window.open(imageUrl, '_blank');
}
