import 'package:flutter/material.dart';
import 'package:talk_ai/infra/design/design_colors.dart';

class InfoDialogItemWidget extends StatelessWidget {
  final IconData iconData;
  final String title;
  const InfoDialogItemWidget({
    required this.iconData,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: DesignColors.cyan,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        ],
      ),
    );
  }
}
