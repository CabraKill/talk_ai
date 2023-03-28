import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talk_ai/presentation/pages/info/info_dialog_item_widget.dart';

class ChatGPTDialog extends StatefulWidget {
  const ChatGPTDialog({Key? key}) : super(key: key);

  @override
  ChatGPTDialogState createState() => ChatGPTDialogState();
}

class ChatGPTDialogState extends State<ChatGPTDialog>
    with SingleTickerProviderStateMixin {
  static const _instruction =
      'Its goal is to act like a therapist, so it will try to answer your questions in a way that may sound similar to how a therapist would behave. The success here is helping you with your problems.';

  static const _language = 'You can write in your own language.';
  static const _data =
      'TalkAI uses ChatGPT, a language model trained by OpenAI, to generate answers to your questions.';
  static const double _maxDialogWidth = 600;

  late final AnimationController _animationController;
  late final Animation<double> _animationAlign;

  @override
  void initState() {
    super.initState();

    _startAnimation();
  }

  double _getYAlignment(double animationValue) {
    const bottomYAlignment = 2.5;

    return bottomYAlignment - animationValue * bottomYAlignment;
  }

  void _exit(BuildContext context) {
    _animationController.reverse();
    Navigator.of(context).pop();
  }

  void _startAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationAlign = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        final animationValue = _animationAlign.value;
        final yAlignment = _getYAlignment(animationValue);

        return Dialog(
          alignment: Alignment(0, yAlignment),
          insetPadding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: _maxDialogWidth,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'About the App',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                InfoDialogItemWidget(
                  iconData: FontAwesomeIcons.database,
                  title: _data,
                ),
                InfoDialogItemWidget(
                  iconData: FontAwesomeIcons.solidHeart,
                  title: _instruction,
                ),
                InfoDialogItemWidget(
                  iconData: FontAwesomeIcons.language,
                  title: _language,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () => _exit(context),
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
