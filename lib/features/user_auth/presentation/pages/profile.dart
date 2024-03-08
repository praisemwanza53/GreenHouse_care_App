import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sendingandreceiving/features/user_auth/presentation/pages/home_page.dart';

import '../../../../globle/common/toast.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
          actions: <Widget>[

            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
                showToast(message: "User is successfully signed out");
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Name:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Email:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Bio:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write a short bio about yourself',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _saveProfileDetails();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );
  }

  void _saveProfileDetails() {
    String name = _nameController.text;
    String email = _emailController.text;
    String bio = _bioController.text;

    // You can do whatever you want with the user details here, such as saving them to a database or displaying them in another screen.
    if (kDebugMode) {
      print('Name: $name');
    }
    if (kDebugMode) {
      print('Email: $email');
    }
    if (kDebugMode) {
      print('Bio: $bio');
    }

    // Optionally, you can navigate to another screen after saving the details.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
