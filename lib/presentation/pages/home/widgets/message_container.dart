import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  final String message;
  final Color color;
  const MessageContainer({
    required this.message,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.only(
        left: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: color,
            width: 2,
          ),
        ),
      ),
      child: Text(
        message,
      ),
    );
  }
}
