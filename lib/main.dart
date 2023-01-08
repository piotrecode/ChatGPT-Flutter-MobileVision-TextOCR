import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';

import 'backend/chatgpt_connection.dart';

class ChatGPTResponse extends StatelessWidget {
  final String response;

  ChatGPTResponse({
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(response),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<OcrText> _texts = [];

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ChatGPT + FLutter Mobilevision'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                List<OcrText> texts = await FlutterMobileVision.read(
                  flash: false,
                  autoFocus: true,
                  multiple: false,
                  waitTap: true,
                  showText: true,
                );
                setState(() => _texts = texts);
              },
              child: Text('Read text from Camera'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _texts.length,
                itemBuilder: (context, index) {
                  OcrText text = _texts[index];

                  return Expanded(
                    child: FutureBuilder(
                      future: getResponseFromChatGPT(text.value),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ChatGPTResponse(response: snapshot.data!);
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
