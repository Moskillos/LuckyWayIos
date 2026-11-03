import 'package:http/http.dart' as http;
import 'dart:convert';


Future<void> sendNotification(String token, String title, String body, String type, String? expeditionId, String? trackId) async {
  final url = Uri.parse("https://sendnotification-5hlqch2ypq-uc.a.run.app");
  print("token");
  print(token);
  final res = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "token": token, // Inserisci qui il token FCM dell'utente
      "title": title,
      "body": body,
      "data": {"expeditionId": expeditionId ?? '', "type": type, "trackId": trackId},
    }),
  );
  print("res");
  print(res.body);
}
