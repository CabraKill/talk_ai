import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    super.key,
    required this.onSendButtonTap,
    required double fieldDimension,
    required this.isReady,
    required this.borderColor,
    required this.disabledBorderColor,
    required this.onInit,
  }) : _fieldDimension = fieldDimension;

  static const _riveAsset = "assets/rive/chat.riv";
  static const double _size = 52;

  final void Function({Function(String message)? onError})? onSendButtonTap;
  final double _fieldDimension;
  final bool isReady;
  final Color borderColor;
  final MaterialColor disabledBorderColor;
  final void Function(Artboard artboard) onInit;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _size,
      child: GestureDetector(
        onTap: onSendButtonTap,
        child: Container(
          constraints: BoxConstraints(
            minWidth: _fieldDimension,
            minHeight: _fieldDimension,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isReady ? borderColor : disabledBorderColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: RiveAnimation.asset(
              _riveAsset,
              fit: BoxFit.cover,
              artboard: "enterChat",
              onInit: onInit,
            ),
          ),
        ),
      ),
    );
  }
}
