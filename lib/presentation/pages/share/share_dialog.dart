import 'package:talk_ai/presentation/pages/share/share_file_non_web.dart'
    if (dart.library.html) 'package:talk_ai/presentation/pages/share/share_file_web.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:talk_ai/presentation/pages/share/sharable_container.dart';
import 'dart:ui' as ui;

class ShareDialog extends StatefulWidget {
  final String userMessage;
  final String botMessage;

  const ShareDialog({
    required this.userMessage,
    required this.botMessage,
    super.key,
  });

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
    static const double _widthProportion = 0.8;

  final _globalKey = GlobalKey();

  Future<void> _onShare() async {
    //TODO analyse this
    // final boundary = SharableContainer(
    //   botMessage: widget.botMessage,
    //   userMessage: widget.userMessage,
    // ).build(context).createElement().findRenderObject()
    //     as RenderRepaintBoundary;
    final boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;
    shareFile(byteData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Preview",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Flexible(
          child: Container(
            width: MediaQuery.of(context).size.width * _widthProportion,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SharableContainer(
                userMessage: widget.userMessage,
                botMessage: widget.botMessage,
                key: _globalKey,
              ),
            ),
          ),
        ),
        Dialog(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
              _onShare();
            },
            icon: Icon(Icons.share),
          ),
        )
      ],
    );
  }
}
