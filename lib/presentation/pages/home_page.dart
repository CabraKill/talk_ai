import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:talk_ai/data/repositories/send_message_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StateMachineController? _riveAnimationController;
  final _textController = TextEditingController();
  SendMessageRepositoryImpl _sendMessageRepositoryImpl =
      SendMessageRepositoryImpl();

  String _answer = "";

  @override
  Widget build(BuildContext context) {
    const outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Flexible(
              //   child: SingleChildScrollView(
              //     child: Column(
              //       mainAxisSize: MainAxisSize.min,
              //     ),
              //   ),
              // ),
              Text(_answer),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: outlineInputBorder,
                        focusedBorder: outlineInputBorder,
                        enabledBorder: outlineInputBorder,
                        labelText: 'Message',
                      ),
                      controller: _textController,
                      onChanged: _onChanged,
                      onSubmitted: (_) => _onSendMessage(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _onSendMessage,
                    child: SizedBox.square(
                      dimension: 52,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: RiveAnimation.asset(
                          "assets/rive/chat.riv",
                          fit: BoxFit.cover,
                          artboard: "enterChat",
                          onInit: _onInit,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _startMessaging,
            tooltip: 'Message',
            child: const Icon(Icons.text_increase),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _startTyping,
            tooltip: 'Type',
            child: const Icon(Icons.text_increase),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _send,
            tooltip: 'Increment',
            child: const Icon(Icons.send),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _removeMessage,
            tooltip: 'Increment',
            child: const Icon(Icons.remove),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _startMessaging() {
    var trigger = (_riveAnimationController?.findInput<bool>('startMessaging')
        as SMITrigger);
    trigger.fire();
  }

  void _startTyping() {
    var trigger = (_riveAnimationController?.findInput<bool>('startTyping')
        as SMITrigger);
    trigger.fire();
  }

  void _send() {
    var trigger = (_riveAnimationController?.findInput<bool>('sendMessage')
        as SMITrigger);
    trigger.fire();
  }

  void _removeMessage() {
    var trigger = (_riveAnimationController?.findInput<bool>('removeMessage')
        as SMITrigger);
    trigger.fire();
  }

  void _onInit(Artboard artboard) {
    _riveAnimationController =
        StateMachineController.fromArtboard(artboard, 'State Machine 1')
            as StateMachineController;
    artboard.addController(_riveAnimationController!);
  }

  void _onChanged(String value) {
    if (value.isEmpty) {
      _removeMessage();
    } else {
      _startMessaging();
      _startTyping();
    }
  }

  void _onSendMessage() {
    var text = _textController.text;
    _sendMessageToBot(text);
    _textController.clear();
    _send();
  }

  void _sendMessageToBot(String message) async {
    try {
      final result = await _sendMessageRepositoryImpl(message);
      _updateMessage(result);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
    }
  }

  void _updateMessage(String result) {
    setState(() {
      _answer = result;
    });
  }
}
