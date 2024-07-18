import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guard_property_management/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  void _startSplashScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstRun = prefs.getBool("IS_FIRST_RUN");

    if (isFirstRun == null || isFirstRun == true) {
      await prefs.setBool("IS_FIRST_RUN", false);
      await Future.delayed(Duration(seconds: 2));
    }

    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool("IS_LOGIN");
    String? token = prefs.getString('TOKEN');

    if (isLoggedIn == true && token != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
            (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => login_page(),
        ),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.zero,
          child: Image.asset(
            'assets/images/splashscreen.jpeg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
