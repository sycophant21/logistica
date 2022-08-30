import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_123/firebase_options.dart';
import 'package:test_123/helpers/auth_service.dart';
import 'package:test_123/screens/goods_and_company_info_input_for_create_job_screen.dart';
import 'package:test_123/screens/home.dart';
import 'package:test_123/screens/login.dart';
import 'package:test_123/screens/maps_screen.dart';
import 'package:test_123/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'MyFirstProject', options: DefaultFirebaseOptions.ios);
  FirebaseMessaging.onBackgroundMessage(onBackgroundNotification);
  runApp(const MyApp());
}

Future<void> onBackgroundNotification(RemoteMessage rm) async {
  if (kDebugMode) {
    print(rm);
  }
}

class MyApp extends StatelessWidget {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //PushNotificationService(fcm: _firebaseMessaging,).createState().initState();
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: const Color.fromRGBO(27, 27, 27, 1),
          appBarTheme: const AppBarTheme(
            color: Color.fromRGBO(27, 27, 27, 1),
            centerTitle: true,
          ),
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(backgroundColor: Colors.white),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromRGBO(27, 27, 27, 1),
          ),
          drawerTheme: const DrawerThemeData(backgroundColor: Colors.white)),
      home: AuthService(
        fcm: _firebaseMessaging,
      ),
      routes: {
        Home.route: (ctx) => const Home(),
        SignUpScreen.route: (ctx) => const SignUpScreen(),
        Login.route: (ctx) => const Login(),
        AuthService.route: (ctx) => AuthService(
              fcm: _firebaseMessaging,
            ),
        MapsScreen.route: (ctx) => const MapsScreen(),
      },
    );
  }
}
