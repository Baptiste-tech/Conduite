import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//  PROVIDER
import 'package:conduite/providers/robot_controller.dart';

//  SCREENS
import 'package:conduite/splash/splash_screen.dart';
import 'package:conduite/screens/home_screen.dart';
import 'package:conduite/screens/pilote_screen.dart';
import 'package:conduite/screens/connection screen.dart';
import 'package:conduite/screens/settings_screen.dart';
import 'package:conduite/screens/about_screen.dart';
import 'package:conduite/screens/controller_screen.dart';
import 'package:conduite/screens/menu_screen.dart';



void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => RobotController(),
      child: const RobotApp(),
    ),
  );
}

class RobotApp extends StatelessWidget {
  const RobotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PIPE-FAMILY',

      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        fontFamily: 'Rajdhani',
      ),

      // écran de démarrage
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/pilot': (context) => const PilotScreen(),
        '/connection': (context) => const ConnectionScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
        '/controller': (context) => const ControllerScreen(), // 🔥 AJOUT NECESSAIRE
        '/menu': (context) => const MenuScreen(),

      },
    );
  }
}
