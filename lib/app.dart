import 'package:cricketly/bottom_bar_screen.dart';
import 'package:cricketly/constant/prefrance.dart';
import 'package:cricketly/constant/theme.dart';
import 'package:cricketly/view/auth/login_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Urbanist',
        inputDecorationTheme: TextFieldDecoration.getOutLineInputDecoration,
      ),
      home: preferences.getString(Keys.userID) != null
          ? BottomBarScreen(
              selectedIndex: 0,
            )
          : const LoginScreen(),
    );
  }
}
