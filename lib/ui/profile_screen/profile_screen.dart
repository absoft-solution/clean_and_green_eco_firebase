import 'dart:developer';

import 'package:clean_and_green/core/auth/google_sign_controller.dart';
import 'package:clean_and_green/core/auth/signInWithGoogle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/color.dart';
import '../../constant/textconstant.dart';
import '../../constant/textstyleC.dart';
import '../post_created/PostProvider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

String userName = '';
String photoUrl = '';
String email = '';
String posts = '';
String points = '';
String cleaned = '';
String activityDocId = '';

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _loadUserProfile() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      setState(() {
        userName = sharedPreferences.getString('userName') ?? '';
        photoUrl = sharedPreferences.getString('photoUrl') ?? '';
        email = sharedPreferences.getString('email') ?? '';
      });
      final querySnapshot2 = await FirebaseFirestore.instance
          .collection("userProgress")
          .where('email', isEqualTo: email)
          .get();
      if (querySnapshot2.docs.isNotEmpty) {
        final docId = querySnapshot2.docs.first;
        final data = docId.id;
        activityDocId = data.toString();
      } else {
        log("Empty");
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection("userProgress")
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = querySnapshot.docs.first;
        final data = docSnapshot.data();
        setState(() {
          points = data['points'].toString();
          cleaned = data['cleaned'].toString();
          posts = data['posts'].toString();
        });
      } else {
        log("No user progress found for email: $email");
        Fluttertoast.showToast(msg: "No user progress found for email: $email");
      }
    } catch (e) {
      log("Error loading user profile: $e");
      Fluttertoast.showToast(msg: "Error loading user profile: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    log("User Name: $userName");
    log("Email: $email");
    log("Photo URL: $photoUrl");
    log("Posts: $posts");
    log("cleaned: $cleaned");
    log("points: $points");
    log('Activity Doc ID $activityDocId');
    return ChangeNotifierProvider(
      create: (BuildContext context) => PostProvider(context),
      child: Consumer<GoogleSignController>(
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: backcolor,
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * .445,
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * .020,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: whitecolor,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .250,
                              ),
                              Text(
                                "Edit Post",
                                style: mediumgreen.copyWith(color: whitecolor),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(photoUrl),

                                // backgroundImage: Image.network(
                                //         model.googleAccount?.photoUrl ?? ' ')
                                //     .image,
                              ),
                              Text(userName,
                                  // model.googleAccount?.displayName.toString() ??
                                  //     'No Name',
                                  style: whitetext),
                              Text(email,
                                  // model.googleAccount?.email.toString() ??
                                  //     'No Email',
                                  style: whitetext),
                              // ActionChip(
                              //   avatar:Icon( Icons.logout) ,
                              //     label:Text("LogOut") ,
                              //   onPressed: (){
                              //     Provider.of<GoogleSignController>(context,listen: false).logout();
                              //   },
                              // ),

                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.15,
                                    right: MediaQuery.of(context).size.width *
                                        0.15),
                                child: Text(des, style: tensize),
                              ),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height * 0.002,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05,
                                  right:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  height:
                                      MediaQuery.of(context).size.height * 0.10,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                child: Text(
                                                  "Post",
                                                  style: mediumgreen,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                child: Text(
                                                  posts,
                                                  style: sizeto4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                child: Text(
                                                  "Cleaned",
                                                  style: mediumgreen,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                child: Text(
                                                  cleaned,
                                                  style: sizeto4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                child: Text(
                                                  "Points",
                                                  style: mediumgreen,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                child: Text(
                                                  points,
                                                  style: sizeto4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.06,
                        ),
                        child: Text("Activities ", style: boldgray),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      height: MediaQuery.of(context).size.height * 0.600,
                      width: MediaQuery.of(context).size.width * 1,
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('userProgress')
                              .doc(activityDocId)
                              .collection('activities')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              String error = snapshot.error.toString();
                              return Center(child: Text(error));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No data found!'));
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        minRadius: 15,
                                        maxRadius: 25,
                                        backgroundColor: Colors.green,
                                        child: Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: CircleAvatar(
                                            minRadius: 15,
                                            maxRadius: 25,
                                            backgroundImage: NetworkImage(
                                                snapshot
                                                    .data!.docs[index]['picUrl']
                                                    .toString()),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        snapshot
                                            .data!.docs[index]['activityType']
                                            .toString(),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      subtitle: Text(
                                          snapshot.data!.docs[index]['dateTime']
                                              .toString(),
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                    // child: Container(
                                    //   height: 70,
                                    //   width: 200,
                                    //   child: Row(
                                    //     children: [
                                    //       CircleAvatar(
                                    //         minRadius: 15,
                                    //         maxRadius: 25,
                                    //         backgroundColor: Colors.green,
                                    //         child: Padding(
                                    //           padding: EdgeInsets.all(2.0),
                                    //           child: CircleAvatar(
                                    //             minRadius: 15,
                                    //             maxRadius: 25,
                                    //             backgroundImage: AssetImage(
                                    //                 snapshot.data!
                                    //                     .docs[index]['picUrl']
                                    //                     .toString()),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       SizedBox(
                                    //         width: 20,
                                    //       ),
                                    //       Padding(
                                    //         padding: EdgeInsets.only(
                                    //             top: MediaQuery.of(context)
                                    //                     .size
                                    //                     .height *
                                    //                 0.020),
                                    //         child: Column(
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.start,
                                    //           children: [
                                    //             Text(snapshot.data!
                                    //                 .docs[index]['activityType']
                                    //                 .toString()),
                                    //             Text(snapshot.data!
                                    //                 .docs[index]['dateTime']
                                    //                 .toString()),
                                    //           ],
                                    //         ),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                  );
                                },
                              );
                            }
                          }),
                    ))
                  ],
                ),
              ));
        },
      ),
    );
  }
}
