import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void shareFile(
  BuildContext context,
  ByteData byteData,
) async {
  final directory = (await getApplicationDocumentsDirectory()).path;
  final path = '$directory\\photo.png';
  final imgFile = File(path);
  final pngBytes = byteData.buffer.asUint8List();
  imgFile.writeAsBytes(pngBytes);
  _showFileSavedSnackBar(context, imgFile.path);
  Share.shareXFiles([
    XFile(
      imgFile.path,
    )
  ]);
}

void _showFileSavedSnackBar(
  BuildContext context,
  String path,
) {
  final snackBar = SnackBar(
    content: Text('File saved to $path'),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
