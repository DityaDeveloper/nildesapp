import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//import 'ui/screen/firstscreen.dart';
import 'ui/screen/firstscreen.dart';
import 'ui/screen/login_screen.dart';
import 'firebase_options.dart';
import 'ui/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nildes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(),
      home: const SpalshScreen(),
    );
  }
}
