import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lucky_way_ios/screens/notification_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'app_localizations.dart';
import 'firebase_options.dart';
import 'firebase_notifications.dart';
import 'store/app_state.dart';
import 'screens/onboarding_screens/onboarding.dart';
import 'screens/onboarding_screens/login_screen.dart';
import 'screens/sender_screens/home.dart';
import 'screens/driver_screens/home_truck_driver.dart';
import 'screens/sender_screens/expedition_screen.dart';
import 'screens/driver_screens/driver_expedition_screen.dart';
import 'screens/sender_screens/sender_track_screen.dart';
import 'screens/driver_screens/driver_track_screen.dart';
import 'screens/sender_screens/sender_preferences.dart';
import 'screens/driver_screens/driver_preferences.dart';
import 'models/user_model.dart';
import 'database.dart';
import 'firebase_auth.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// BACKGROUND HANDLER
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ❗ NON navigare qui
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool isSimulator = false;
  if (Platform.isIOS) {
    final info = await DeviceInfoPlugin().iosInfo;
    isSimulator = !info.isPhysicalDevice;
  }

  Stripe.publishableKey = dotenv.get('PUBLISHABLE_KEY_TEST');
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  if (!isSimulator) {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
    await PushNotifications().init();
    await PushNotifications().localNotiInit();
  }

  PaintingBinding.instance.imageCache.maximumSize = 10;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Lucky Way',
        supportedLocales: const [
          Locale('it'),
          Locale('en'),
        ],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/expedition':
              final args = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => NotificationScreen(
                  data: args,
                ),
              );

            case '/login':
              return MaterialPageRoute(builder: (_) => const LogInScreen());
          }
        },
        home: UpgradeAlert(
          upgrader: Upgrader(countryCode: 'it'),
          child: const MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<String> menuIcons = [
  'home.svg',
  'truck.svg',
  'earth.svg',
  'preferences.svg',
];

List<String> menuIconsTitle(BuildContext context) {
  return [
    AppLocalizations.of(context).translate("home"),
    AppLocalizations.of(context).translate("expeditions"),
    AppLocalizations.of(context).translate("tracks"),
    AppLocalizations.of(context).translate("preferences"),
  ];
}

List<String> menuIconsSelected = [
  'home_filled.svg',
  'shipments_filled.svg',
  'routes_filled.svg',
  'profile_filled.svg',
];

class _MyHomePageState extends State<MyHomePage> {
  int itemSelected = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('lucky_way_user');

      if (raw == null) {
        setState(() => loading = false);
        return;
      }

      final data = jsonDecode(raw);
      final userId = data['id'];
      final password = data['password'];
      final userType = data['userType'];

      UserBase user;

      if (userType == 'TRUCKDRIVER') {
        user = await FirebaseDatabase().getTruckDriverById(userId);
        Provider.of<AppState>(context, listen: false)
            .fetchTruckDriver(user as TruckDriverModel);
      } else if (userType == 'LEGALPERSON') {
        user = await FirebaseDatabase().getlegalPerson(userId);
        Provider.of<AppState>(context, listen: false)
            .fetchLegalPerson(user as LegalPerson);
      } else {
        user = await FirebaseDatabase().getPhysicPerson(userId);
        Provider.of<AppState>(context, listen: false)
            .fetchPhysicPerson(user as PhysicPerson);
      }

      await Auth().signInWithEMailAndPassword(
        email: user.email,
        password: password,
      );

      Provider.of<AppState>(context, listen: false).logIn();
    } catch (_) {}
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!appState.logged) {
      return Onboarding(showLoader: false);
    }

    final user = appState.user;

    final screens = [
      user is TruckDriverModel && user.userView == UserType.TRUCKDRIVER
          ? HomeTruckDriver(
          goToExpeditionPage: () => setState(() => itemSelected = 1))
          : Home(goToTrackPage: () => setState(() => itemSelected = 2)),
      user is TruckDriverModel && user.userView == UserType.TRUCKDRIVER
          ? DriverExpeditionScreen()
          : ExpeditionScreen(),
      user is TruckDriverModel && user.userView == UserType.TRUCKDRIVER
          ? DriverTrackScreen()
          : SenderTrackScreen(
          onItemTapped: (i) => setState(() => itemSelected = i)),
      user is TruckDriverModel && user.userView == UserType.TRUCKDRIVER
          ? DriverPreferences()
          : SenderPreferences(),
    ];

    return Scaffold(
      body: SafeArea(child: screens[itemSelected]),
      bottomNavigationBar: _BottomBar(
        item: itemSelected,
        selected: itemSelected,
        onTap: (i) => setState(() => itemSelected = i),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onTap;
  final int item;

  const _BottomBar(
      {required this.selected, required this.onTap, required this.item});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(menuIcons.length, (i) {
          final bool isSelected = selected == i;

          return Expanded(
            child: Column(
              children: [
                InkWell(
                  onTap: () => onTap(i),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: SvgPicture.asset(
                      color: Colors.red,
                      'assets/${menuIcons[i]}',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        isSelected ? Colors.black : Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Text(
                  menuIconsTitle(context)[i],
                  style:
                  TextStyle(color: isSelected ? Colors.black : Colors.grey),
                ),
                Icon(
                  Icons.circle,
                  size: 5,
                  color: isSelected ? Colors.black : Colors.grey,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
