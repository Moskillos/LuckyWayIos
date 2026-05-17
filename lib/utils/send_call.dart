import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> sendCall(String caller, String receiver) async {
  final url = Uri.parse("https://startcall-5hlqch2ypq-uc.a.run.app");
  await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"caller": caller, "receiver": receiver}),
  );
}