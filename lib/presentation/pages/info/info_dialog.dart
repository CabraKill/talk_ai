import 'package:flutter/material.dart';

class ChatGPTDialog extends StatefulWidget {
  const ChatGPTDialog({Key? key}) : super(key: key);

  @override
  ChatGPTDialogState createState() => ChatGPTDialogState();
}

class ChatGPTDialogState extends State<ChatGPTDialog>
    with SingleTickerProviderStateMixin {
  static const String _aboutAppText =
      'TalkAI uses ChatGPT, a language model trained by OpenAI, to generate answers to your questions. It is instructed to act like a therapist, so it will try to answer your questions in a way that is similar to how a therapist would answer with focus of helping you with your problems. Your can write in your own language.';

  late final AnimationController _animationController;
  late final Animation<double> _animationAlign;

  @override
  void initState() {
    super.initState();

    _startAnimation();
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
    return GestureDetector(
      onTap: () {
        _animationController.reverse();
        Navigator.of(context).pop();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment(0, 2.5 - _animationAlign.value * 2.5),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16.0,
                        spreadRadius: 4.0,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'About the App',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _aboutAppText,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _animationController.reverse();
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
