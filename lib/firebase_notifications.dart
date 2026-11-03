import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lucky_way_ios/main.dart'; // dove hai navigatorKey
import 'package:shared_preferences/shared_preferences.dart';

class PushNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
  FlutterLocalNotificationsPlugin();

  // ====================== INIT ======================
  Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('lucky_way_token', token);
        print("FCM Token: $token");
      }
    } catch (e) {
      print("Errore token FCM: $e");
    }

    // Ascolta i messaggi FCM
    _setupFirebaseListeners();
  }

  // ====================== LISTENER FCM ======================
  void _setupFirebaseListeners() {
    // 1. App in FOREGROUND → mostra notifica locale
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'Nuova notifica';
      final body = message.notification?.body ?? '';
      final payload = jsonEncode(message.data); // salva i data

      showSimpleNotification(
        title: title,
        body: body,
        payload: payload,
      );
    });

    // 2. App in BACKGROUND → utente clicca la notifica
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data);
    });

    // 3. App TERMINATA → aperta da una notifica
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        // piccolo delay perché il navigator non è ancora pronto
        Future.delayed(const Duration(milliseconds: 800), () {
          _handleNotificationClick(message.data);
        });
      }
    });
  }

  // ====================== CLICK HANDLER ======================
  void _handleNotificationClick(Map<String, dynamic> data) {

    final String? type = data['type'];
    final String? expeditionId = data['expeditionId'];
    final String? trackId = data['trackId'];

    if (type == null) return;

    switch (type) {
      case 'acceptation':
          navigatorKey.currentState?.pushNamed(
            '/',
          );
        break;

      case 'expedition':
          navigatorKey.currentState?.pushNamed(
            '/expedition',
            arguments: jsonEncode({"expeditionId": expeditionId,
              "trackId": trackId
            }),
          );
        break;
    }
  }

  // ====================== LOCAL NOTIFICATIONS ======================
  Future localNotiInit() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _flutterLocalNotificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Click su notifica locale (foreground / background)
        if (response.payload != null) {
          final data = jsonDecode(response.payload!) as Map<String, dynamic>;
          _handleNotificationClick(data);
        }
      },
      // Attenzione: in background isolate non puoi usare navigatorKey facilmente
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationTap,
    );
  }

  // ====================== MOSTRA NOTIFICA ======================
  Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'lucky_way_channel',
      'Lucky Way Notifications',
      channelDescription: 'Notifiche Lucky Way',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _flutterLocalNotificationPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // id univoco
      title,
      body,
      details,
      payload: payload,
    );
  }
}

// Handler in isolate separato (background)
@pragma('vm:entry-point')
void onBackgroundNotificationTap(NotificationResponse response) {
  // Qui di solito salvi solo i dati e li gestisci al prossimo avvio
  // oppure usi un meccanismo tipo SharedPreferences + flag
  print("Background notification tapped: ${response.payload}");
}