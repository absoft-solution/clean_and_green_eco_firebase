import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInWithGoogle {
  String userName = '';
  String email = '';
  String photoUrl = '';
  DocumentReference docRef =
      FirebaseFirestore.instance.collection("userProgress").doc();

  Future<void> signInWithGoogle() async {
    log("Testing login");

    final googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    final _auth = FirebaseAuth.instance;

    GoogleSignInAccount? googleUser = googleSignIn.currentUser;
    log('this is google user: ' + googleUser.toString());

    if (googleUser != null) {
      Fluttertoast.showToast(msg: "Already Logged in as ${googleUser.email}");
      log("User is already logged in with Google: ${googleUser.email}");
    } else {
      googleUser = await googleSignIn.signIn();
      log("Testing 1 ${googleUser}");
      final querySnapshot = await FirebaseFirestore.instance
          .collection("userProgress")
          .where('email', isEqualTo: googleUser!.email.toString())
          .get();
      if (querySnapshot.docs.isEmpty) {
        await docRef.set({
          'email': googleUser.email,
          'googleDisplayName': googleUser.displayName,
          'posts': 0,
          'cleaned': 0,
          'points': 0,
        });
        await docRef.collection("activities").doc().set({
          "picUrl": googleUser.photoUrl,
          "activityType": "You have created account with Clean and Green Eco",
          'dateTime': DateTime.now().toString(),
        });
        print("Document created successfully");
      } else {
        print("Document already exists for this email");
      }
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Google Sign-In cancelled or failed");
        log("Google Sign-In cancelled or failed");
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      log("Testing 2 ${googleAuth}");

      final credentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      User? user = (await _auth.signInWithCredential(credentials)).user;
      log("Testing 3 ${user}");

      if (user != null) {
        userName = googleUser.displayName ?? '';
        email = googleUser.email;
        photoUrl = googleUser.photoUrl ?? '';

        log("Storing user data: userName=$userName, email=$email, photoUrl=$photoUrl");

        try {
          SharedPreferences sp = await SharedPreferences.getInstance();
          await sp.setString('email', email);
          await sp.setString('photoUrl', photoUrl);
          await sp.setString('userName', userName);
          log("User data stored in SharedPreferences successfully");
        } catch (e) {
          log("Error storing user data in SharedPreferences: $e");
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to sign in with Google");
        log("Failed to sign in with Google");
      }
    }
  }
}
