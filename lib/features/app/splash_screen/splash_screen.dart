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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace this with your desired icon for IoT green house
            Icon(
              Icons.home,
              size: 100, // Adjust size as needed
              color: Colors.green, // Adjust color as needed
            ),
            SizedBox(height: 20),
            // // Optionally, you can display an image for additional graphics
            // Image.asset(
            //   'assets/images/green_house_care_app_logo.png',
            //   fit: BoxFit.cover, // Adjust fit property as needed
            // ),
            SizedBox(height: 20),
            Text(
              "Welcome to GreenHouse Care App",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
