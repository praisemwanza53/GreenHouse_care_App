import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;

  const SplashScreen({Key? key, this.child}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => widget.child!),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(0.0),
                child: Image(image: AssetImage(
                    "assets/images/green_house_care_app_logo.png")),
              ),
            ],
          ),
        ),
      ),
    );
  }

}