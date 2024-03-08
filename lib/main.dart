import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sendingandreceiving/features/app/splash_screen/splash_screen.dart';

import 'features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async{
  await dotenv.load();
  await dotenv.load(fileName: ".env");
  String api_key = dotenv.get('APIKEY');
  String APPID = dotenv.get('app_Id');
  String SENDERID = dotenv.get('messagingSender_Id');
  String PROJECTID = dotenv.get('project_Id');

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){;
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: api_key,
            appId: APPID,
            messagingSenderId: SENDERID,
            projectId: PROJECTID,
        ),
    );

  }
  else {
    await Firebase.initializeApp();
  }
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter firebase',
      home: SplashScreen(
        child: LoginPage(),
      )
    );

  }
}

