import 'package:flutter/material.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    initData().then((value) {
      navigateToHomeScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff33313b), Color(0xff4592af)],
        ),
      ),
      child: Center(
        child: FlutterLogo(size: 200),
      ),
    );
  }

  Future initData() async {
    await Future.delayed(Duration(seconds: 3));
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}
