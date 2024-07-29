import 'package:clean_and_green/core/auth/google_sign_controller.dart';
import 'package:clean_and_green/ui/home_screen/HomeScreen.dart';
import 'package:clean_and_green/ui/post_created/PostProvider.dart';
import 'package:clean_and_green/ui/profile_screen/profile_screen.dart';
import 'package:clean_and_green/ui/splash_screen/splashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/auth/signInWithGoogle.dart';
import 'core/provider/signin_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // UserCredential userCredential =
  //     await FirebaseAuth.instance.signInAnonymously();
  FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PostProvider(context)),
      ChangeNotifierProvider(
        create: (context) => GoogleSignController(),
        child: ProfileScreen(),
      ),
      ChangeNotifierProvider(
        create: (context) => SignInProvider(),
        child: HomeScreen(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
