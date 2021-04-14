import 'dart:ui';

import 'package:crypto_flutter_app/Traders_screen.dart';
import 'package:crypto_flutter_app/crypto_camp_screen.dart';
import 'package:crypto_flutter_app/dashboard_screen.dart';
import 'package:crypto_flutter_app/password_recovery_screen.dart';
import 'package:crypto_flutter_app/select_country_screen.dart';
import 'package:crypto_flutter_app/sing_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:crypto_flutter_app/sign_in_screen.dart';

import 'SizingTool.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isAuthorized = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      ),
      initialRoute: isAuthorized ? "/traders" : "/select_country",
      routes: {
        "/" : (context) => DashboardScreen(),
        "/select_country" : (context) => SelectCountryScreen(),
        "/sign_in" : (context) => SignInScreen(),
        "/sing_up" : (context) => SingUpScreen(),
        "/password_recovery_screen" : (context) => PasswordRecoveryScreen(),
        "/crypto_camp" : (context) => CryptoCampScreen(),
        "/traders" : (context) => TradersScreen()
      },
    );
  }
}
