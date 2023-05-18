import 'package:flutter/material.dart';
import 'package:native_function/pages/parentPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.center,
      margin: EdgeInsets.all(50),
      duration: Duration(milliseconds: 1500),
      child: Image.asset('assets/images/map_icon.png'),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => ParentPage(),
    ));
  }
}
