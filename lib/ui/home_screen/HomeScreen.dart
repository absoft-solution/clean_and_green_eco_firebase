import 'dart:async';
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:clean_and_green/constant/color.dart';
import 'package:clean_and_green/core/auth/google_sign_controller.dart';
import 'package:clean_and_green/core/auth/signInWithGoogle.dart';
import 'package:clean_and_green/ui/post_created/PostProvider.dart';
import 'package:clean_and_green/ui/profile_screen/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/button.dart';
import '../../constant/textconstant.dart';
import '../../constant/textstyleC.dart';

class HomeScreen extends StatefulWidget {
  Image? image;

  HomeScreen({Key? key, this.image}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String? emailAddress;

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final databaseRef = FirebaseDatabase.instance.ref("cleanPlacesPic");
  CollectionReference imagesList =
      FirebaseFirestore.instance.collection('images');
  ImagePicker image = ImagePicker();
  File? file;
  DocumentReference docRef =
      FirebaseFirestore.instance.collection("cleanPlacesPic").doc();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => PostProvider(context),
        child: Consumer<GoogleSignController>(
          builder: (context, model, child) {
            return Scaffold(
                body: SingleChildScrollView(
                    child: Container(
              color: backcolor,
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 230,
                            ),
                            Positioned(
                              top: 0,
                              child: Container(
                                alignment: Alignment.center,
                                height: 190,
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    )),
                                child: Text(
                                  "Home",
                                  style: whitetext,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
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
                                                  clean,
                                                  style: boldgreen,
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.035,
                                                  decoration: BoxDecoration(
                                                    color: greencolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    "Redeem Points",
                                                    style: btntext,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            // CircleAvatar(
                                            //   radius: 30,
                                            //   backgroundImage:
                                            //
                                            //
                                            //   Image.network(model
                                            //                       .googleAccount
                                            //                       ?.photoUrl ??
                                            //                   '')
                                            //               .image !=
                                            //           ''
                                            //       ? Image.network(model
                                            //                   .googleAccount
                                            //                   ?.photoUrl ??
                                            //               '')
                                            //           .image
                                            //       : AssetImage(
                                            //           "assets/images/test.png"),
                                            // ),
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage: AssetImage(
                                                  "assets/images/test.png"),
                                            ),
                                            Text(
                                              '1200 pts',
                                              style: btntext.copyWith(
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 30),
                              child: Text(
                                "Recently Cleaned Places ",
                                style: boldgray,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          height: MediaQuery.of(context).size.height * 0.43,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.350,
                            child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("cleanPlacesPic")
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  String error = snapshot.error.toString();
                                  return Center(child: Text(error));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Center(child: Text('No data found!'));
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    primary: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      QueryDocumentSnapshot x =
                                          snapshot.data!.docs[index];

                                      return Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.90,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.35,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child:
                                                                Image.network(
                                                              x['beforeImgUrl'],
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 10,
                                                            left: 5,
                                                            child: Text(
                                                              "Before",
                                                              style: tensize,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Flexible(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            child:
                                                                Image.network(
                                                              x['afterImgUrl'],
                                                              fit: BoxFit.cover,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 10,
                                                            left: 5,
                                                            child: Text(
                                                              "After",
                                                              style: tensize,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 30,
                                            bottom: 10,
                                            child: Text(
                                              'Clean By: ' +
                                                  snapshot.data!.docs[index]
                                                      ['cleanBy'],
                                              style: tensize.copyWith(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                            // ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: 5,
                            //     itemBuilder: (BuildContext context, int index) {
                            //       return Column(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.center,
                            //             children: [
                            //               Stack(
                            //                 children: [
                            //                   Padding(
                            //                     padding: EdgeInsets.only(
                            //                         left: MediaQuery.of(context)
                            //                                 .size
                            //                                 .width *
                            //                             0.02,
                            //                         right:
                            //                             MediaQuery.of(context)
                            //                                     .size
                            //                                     .width *
                            //                                 0.02,
                            //                         top: MediaQuery.of(context)
                            //                                 .size
                            //                                 .height *
                            //                             0.01),
                            //                     child: Container(
                            //                       decoration: BoxDecoration(
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 18),
                            //                       ),
                            //                       width: MediaQuery.of(context)
                            //                               .size
                            //                               .width *
                            //                           0.45,
                            //                       height: MediaQuery.of(context)
                            //                               .size
                            //                               .height *
                            //                           0.35,
                            //                       child: ClipRRect(
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 8),
                            //                         child: Image.asset(
                            //                           "assets/images/test1.png",
                            //                           fit: BoxFit.cover,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   Positioned(
                            //                     bottom: 0,
                            //                     child: Padding(
                            //                       padding: EdgeInsets.only(
                            //                           left: 5, right: 5),
                            //                       child: Container(
                            //                         width:
                            //                             MediaQuery.of(context)
                            //                                     .size
                            //                                     .width *
                            //                                 0.55,
                            //                         child: Row(
                            //                           mainAxisAlignment:
                            //                               MainAxisAlignment
                            //                                   .spaceBetween,
                            //                           crossAxisAlignment:
                            //                               CrossAxisAlignment
                            //                                   .center,
                            //                           children: [
                            //                             Expanded(
                            //                               child: Text(
                            //                                 "03 Hours Ago",
                            //                                 style: tensize,
                            //                               ),
                            //                             ),
                            //                             SizedBox(
                            //                               width: MediaQuery.of(
                            //                                           context)
                            //                                       .size
                            //                                       .width *
                            //                                   0.02,
                            //                             ),
                            //                             Image.asset(
                            //                               "assets/images/dot.png",
                            //                               width: MediaQuery.of(
                            //                                           context)
                            //                                       .size
                            //                                       .width *
                            //                                   0.02,
                            //                               height: MediaQuery.of(
                            //                                           context)
                            //                                       .size
                            //                                       .height *
                            //                                   0.02,
                            //                             ),
                            //                             SizedBox(
                            //                               width: MediaQuery.of(
                            //                                           context)
                            //                                       .size
                            //                                       .width *
                            //                                   0.02,
                            //                             ),
                            //                             Expanded(
                            //                               child: Text(
                            //                                 "Not Clean",
                            //                                 style: tensizebold
                            //                                     .copyWith(
                            //                                         color:
                            //                                             yellowcolor),
                            //                               ),
                            //                             )
                            //                           ],
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   )
                            //                 ],
                            //               ),
                            //               Stack(
                            //                 children: [
                            //                   Padding(
                            //                     padding: EdgeInsets.only(
                            //                         right:
                            //                             MediaQuery.of(context)
                            //                                     .size
                            //                                     .width *
                            //                                 0.02,
                            //                         top: MediaQuery.of(context)
                            //                                 .size
                            //                                 .height *
                            //                             0.01),
                            //                     child: Container(
                            //                       decoration: BoxDecoration(
                            //                           borderRadius:
                            //                               BorderRadius.circular(
                            //                                   8)),
                            //                       width: MediaQuery.of(context)
                            //                               .size
                            //                               .width *
                            //                           0.45,
                            //                       height: MediaQuery.of(context)
                            //                               .size
                            //                               .height *
                            //                           0.35,
                            //                       child: ClipRRect(
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 8),
                            //                         child: Image.asset(
                            //                           "assets/images/test.png",
                            //                           fit: BoxFit.cover,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   Positioned(
                            //                     bottom: 0,
                            //                     child: Padding(
                            //                       padding: EdgeInsets.only(
                            //                           left: 5, right: 5),
                            //                       child: Container(
                            //                         width:
                            //                             MediaQuery.of(context)
                            //                                     .size
                            //                                     .width *
                            //                                 0.55,
                            //                         child: Row(
                            //                           mainAxisAlignment:
                            //                               MainAxisAlignment
                            //                                   .spaceBetween,
                            //                           crossAxisAlignment:
                            //                               CrossAxisAlignment
                            //                                   .center,
                            //                           children: [
                            //                             Expanded(
                            //                               child: Padding(
                            //                                   padding: EdgeInsets
                            //                                       .only(
                            //                                           left: 16,
                            //                                           bottom:
                            //                                               8),
                            //                                   child: Text(
                            //                                     "03 Hours Ago",
                            //                                     style: tensize,
                            //                                   )),
                            //                             ),
                            //                             SizedBox(
                            //                               width: MediaQuery.of(
                            //                                           context)
                            //                                       .size
                            //                                       .width *
                            //                                   0.02,
                            //                             ),
                            //                             Padding(
                            //                               padding:
                            //                                   EdgeInsets.only(
                            //                                       bottom: 8),
                            //                               child: Image.asset(
                            //                                 "assets/images/dot.png",
                            //                                 width: MediaQuery.of(
                            //                                             context)
                            //                                         .size
                            //                                         .width *
                            //                                     0.02,
                            //                                 height: MediaQuery.of(
                            //                                             context)
                            //                                         .size
                            //                                         .height *
                            //                                     0.02,
                            //                               ),
                            //                             ),
                            //                             SizedBox(
                            //                               width: MediaQuery.of(
                            //                                           context)
                            //                                       .size
                            //                                       .width *
                            //                                   0.02,
                            //                             ),
                            //                             Expanded(
                            //                               child: Text(
                            //                                 "Clean",
                            //                                 style: tensizebold
                            //                                     .copyWith(
                            //                                         color:
                            //                                             greencolor),
                            //                               ),
                            //                             )
                            //                           ],
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   )
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //           SizedBox(
                            //             height:
                            //                 MediaQuery.of(context).size.height *
                            //                     0.015,
                            //           ),
                            //           Padding(
                            //             padding: EdgeInsets.only(
                            //                 top: MediaQuery.of(context)
                            //                         .size
                            //                         .height *
                            //                     0.01,
                            //                 left: MediaQuery.of(context)
                            //                         .size
                            //                         .width *
                            //                     0.02),
                            //             child: Row(
                            //               children: [
                            //                 Icon(
                            //                   Icons.location_on_outlined,
                            //                   color: greencolor,
                            //                 ),
                            //                 Text(
                            //                   itpark,
                            //                   style: boldgreen,
                            //                 )
                            //               ],
                            //             ),
                            //           )
                            //         ],
                            //       );
                            //     }),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 30),
                              child: Text(
                                "Waste Nearby You ",
                                style: boldgray,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          height: MediaQuery.of(context).size.height * 0.43,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.02,
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.35,
                                          child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection("images")
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                String error =
                                                    snapshot.error.toString();
                                                return Center(
                                                    child: Text(error));
                                              } else if (!snapshot.hasData ||
                                                  snapshot.data!.docs.isEmpty) {
                                                return Center(
                                                    child:
                                                        Text('No data found!'));
                                              } else {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  primary: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: snapshot
                                                      .data!.docs.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    QueryDocumentSnapshot x =
                                                        snapshot
                                                            .data!.docs[index];

                                                    return Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.02,
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.01,
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18),
                                                            ),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.90,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.35,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              child:
                                                                  Image.network(
                                                                x['imageUrl'],
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          left: 20,
                                                          top: 10,
                                                          child: Text(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['description'],
                                                            style: tensize,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 10,
                                                          left: 30,
                                                          right: 30,
                                                          child: CustomBtn(
                                                              text: 'Clean it',
                                                              onPress:
                                                                  () async {
                                                                // log("testing login");
                                                                // final googleSignIn = GoogleSignIn(
                                                                //   scopes: [
                                                                //     'email',
                                                                //     'https://www.googleapis.com/auth/contacts.readonly',
                                                                //   ],
                                                                // );
                                                                // final _auth = FirebaseAuth.instance;
                                                                //
                                                                // GoogleSignInAccount? googleUser = await googleSignIn.signIn();
                                                                // log("testing 1 ${googleUser}");
                                                                // GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
                                                                // log("testing 2 ${googleAuth}");
                                                                //
                                                                // final credentials = GoogleAuthProvider.credential(
                                                                //   idToken: googleAuth?.idToken,
                                                                //   accessToken: googleAuth?.accessToken,
                                                                // );
                                                                // User? user = (await _auth.signInWithCredential(credentials)).user;
                                                                // log("testing 3 ${user}");
                                                                //
                                                                // userName = googleUser!.displayName.toString();
                                                                // email = googleUser.email.toString();
                                                                // photoUrl = googleUser.photoUrl.toString();

                                                                SharedPreferences
                                                                    sp =
                                                                    await SharedPreferences
                                                                        .getInstance();

                                                                String docID =
                                                                    snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .id
                                                                        .toString();
                                                                String
                                                                    beforeImgUrl =
                                                                    snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'imageUrl']
                                                                        .toString();
                                                                String userName = sp
                                                                    .getString(
                                                                        'userName')
                                                                    .toString();
                                                                log('Doc ID: $docID');
                                                                log('User Name: $userName');
                                                                log('BeforeImgUrl: $beforeImgUrl');
                                                                pickImage(
                                                                    userName,
                                                                    beforeImgUrl,
                                                                    docID);

                                                                // FirebaseFirestore
                                                                //     .instance
                                                                //     .doc(docID)
                                                                //     .delete()
                                                                //     .then(
                                                                //         (onValue) {
                                                                //   log("${docID}Data Successfully Fetched");
                                                                // }).catchError(
                                                                //         (onError) {
                                                                //   log('Your Error' +
                                                                //       onError
                                                                //           .toString());
                                                                // });
                                                              }),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height:
                              //       MediaQuery.of(context).size.height * 0.02,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
          },
        ));
  }

  Future<void> pickImage(
      String userName, String beforeImgUrl, String docID) async {
    try {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
      if (pickedFile != null) {
        log('Image Picked');
        Fluttertoast.showToast(msg: 'Image Picked');
        await uploadImageToFirebase(
            pickedFile.path, userName, beforeImgUrl, docID);
        Fluttertoast.showToast(msg: 'Calling upload ftn');
        log('Calling upload ftn');
      }
    } catch (e) {
      log('Error picking image: $e');
      Fluttertoast.showToast(msg: 'Error' + e.toString());
    }
  }

  Future<void> uploadImageToFirebase(String filePath, String userName,
      String beforeImgUrl, String docID) async {
    try {
      File file = File(filePath);
      var imageFile = FirebaseStorage.instance
          .ref()
          .child('CleanPlacesPic/${DateTime.now().toString()}');
      UploadTask uploadTask = imageFile.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      await docRef.set({
        "afterImgUrl": downloadUrl,
        'cleanBy': userName,
        "beforeImgUrl": beforeImgUrl,
        'uploadedDateTime': DateTime.now()
      });
      await imagesList
          .doc(docID)
          .delete()
          .then((value) => log("Image Deleted"))
          .catchError((error) => log("Failed to delete image: $error"));

      final querySnapshot = await FirebaseFirestore.instance
          .collection("userProgress")
          .where('email', isEqualTo: email)
          .get();
      final docId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection("userProgress")
          .doc(docId)
          .update({
        'cleaned': FieldValue.increment(1),
        'points': FieldValue.increment(10),
      });
      await FirebaseFirestore.instance
          .collection('userProgress')
          .doc(docId)
          .collection('activities')
          .add({
        "picUrl": downloadUrl,
        "activityType": "You have clean a place and earned 10 points",
        'dateTime': DateTime.now().toString(),
      });
    } catch (e) {
      log('Error uploading image: $e');
      Fluttertoast.showToast(msg: 'Error uploading image: $e');
    }
  }

  Future login() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          log("testing ");
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          log("testing ");
        }
      } catch (e) {
        // handle the error here
        log("testing error ${e.toString()}");
      }
    }
  }

// login() {
//   return Consumer<GoogleSignController>(builder: (context, model, child) {
//     if (model.googleAccount != null) {
//       return Center(
//         child: loggedInUI(model),
//       );
//     } else {
//       return loginControls(context);
//     }
//   });
// }
//
// loggedInUI(GoogleSignController model) {
//   return ProfileScreen();
// }
//
// loginControls(BuildContext context) {
//   return HomeScreen();
// }
}
