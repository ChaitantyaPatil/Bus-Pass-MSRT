import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import 'login_page.dart';
import 'singup_page.dart';
import 'splash_screen.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MSRTC',
      theme: ThemeData(primarySwatch: Colors.red),
      // home: const LoginPage(),
      // home: const SignUpPage(),
      // home: const WelcomePage(),
      home: SplashScreen(),
    );
  }
}
