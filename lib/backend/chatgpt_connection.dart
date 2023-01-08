import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getResponseFromChatGPT(String prompt) async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer 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',
  };

  var data =
      '{"model": "text-davinci-003", "prompt": "$prompt", "temperature": 0, "max_tokens": 256}';

  var url = Uri.parse('https://api.openai.com/v1/completions');
  var res = await http.post(url, headers: headers, body: data);

  if (res.statusCode == 200) {
    // Success! Parse the response and return the text.
    try {
      Map<String, dynamic> responseJson = json.decode(res.body);
      print(responseJson['choices'][0]['text']);
      return responseJson['choices'][0]['text'];
    } catch (e) {
      print("Error parsing response: $e");
      throw e; // Throw the exception
    }
  } else if (res.statusCode >= 400 && res.statusCode < 500) {
    // Client error (e.g. 4xx)
    print("Error ${res.statusCode}: ${res.reasonPhrase}");
    throw Exception("Client error: ${res.statusCode}"); // Throw an exception
  } else if (res.statusCode >= 500 && res.statusCode < 600) {
    // Server error (e.g. 5xx)
    print("Error ${res.statusCode}: ${res.reasonPhrase}");
    throw Exception("Server error: ${res.statusCode}"); // Throw an exception
  } else {
    // Other error
    print("Error ${res.statusCode}: ${res.reasonPhrase}");
    throw Exception("Unknown error: ${res.statusCode}"); // Throw an exception
  }
}
