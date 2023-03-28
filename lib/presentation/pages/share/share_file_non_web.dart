import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void shareFile(ByteData byteData) async {
  final directory = (await getApplicationDocumentsDirectory()).path;
  File imgFile = File('$directory/photo.png');
  Uint8List pngBytes = byteData.buffer.asUint8List();
  imgFile.writeAsBytes(pngBytes);
  Share.shareXFiles([
    XFile(
      imgFile.path,
    )
  ]);
}
