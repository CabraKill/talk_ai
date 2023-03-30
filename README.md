# talk_ai

A conversation app made with Chat GPT-3 API to help.

## Enjoy the app 🎉
* [Web version](https://cabrakill.github.io/talk_ai/)

## ChatGPT-3 API 🤖
The app uses the ChatGPT-3.5-Turbo model to guide the conversation right after some instructions about how to proceed during the conversations. 

On the **Web** the stream response is not enabled but in Windows and Android platforms they are tested and working great. Perhaps in the future the stream response will be enabled on the web version too and probably it is already working fine on mac and linux.

![chatgpt](./README/openai.webp)

## Chat Animation 🍥
The chat animation was made with ![Rive](https://rive.app/). The animation uses a simple circle with the *State Machine* to make the app more beautiful and fun. The fluid transition between states is a result of this technology.

## Contributing 🫰
Contributions are welcome! Feel free to open an issue or a pull request.

## run the build runner
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

