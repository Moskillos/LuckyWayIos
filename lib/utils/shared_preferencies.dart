import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> settingKeyStorage(String id, String password, String userType) async {
  try{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Salva il token localmente
    await prefs.setString('lucky_way_user', jsonEncode({
      'id': id,
      "password": password,
      "userType": userType
    }) );

  } catch(e){
    print(e);
  }

}

Future<void> removeKeyStorage() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('lucky_way_user');
  } catch (e) {
    print(e);
  }
}