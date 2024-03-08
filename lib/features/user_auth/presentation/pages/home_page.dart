import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sendingandreceiving/features/user_auth/presentation/pages/actuators_screen.dart';
import 'package:sendingandreceiving/features/user_auth/presentation/pages/profile.dart';
import 'package:sendingandreceiving/features/user_auth/presentation/pages/sensors_screen.dart';
import '../../../../globle/common/toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',

      theme: ThemeData(
        primarySwatch: Colors.green, // Changed primary swatch color to green
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),


        actions: <Widget>[

          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              //FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
              //showToast(message: "User is successfully signed out");
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Replace with Weather Forecast Visual
          Container(
            height: 200, // Adjust the height as needed
            color: Colors.green, // Changed container color to green
            child: const Center(
              child: Text(
                'Weather Forecast Visual',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Replace with Chat Bot Icon
          IconButton(
            icon: const Icon(Icons.chat),
            color: Colors.green, // Changed icon color to green
            onPressed: () {
              // Handle chat bot icon press
            },
            // Add tooltip if needed
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green, // Changed bottom app bar color to green
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // IconButton(
            //   icon: const Icon(Icons.home),
            //   color: Colors.white, // Changed icon color to white
            //   onPressed: () {
            //     // Navigate to Home Screen
            //     // Navigator.popUntil(context, ModalRoute.withName('/'));
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const HomePage(),
            //       ),
            //     );
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.sensors),
              color: Colors.white, // Changed icon color to white
              onPressed: () {
                // Navigate to Sensors Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SensorsScreen(
                      temperature: 25.0,
                      moisture: 60.0,
                      lightIntensity: 800.0,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.white, // Changed icon color to white
              onPressed: () {
                // Navigate to Actuator Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActuatorScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
