import 'dart:developer';
import 'dart:io';
import 'package:clean_and_green/ui/post_created/post_created.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/color.dart';
import '../../constant/textstyleC.dart';
import '../../core/gps_location.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../core/model/userModel.dart';

class CreatePost extends StatefulWidget {
  var image = '';

  CreatePost({Key? key, required this.image}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController desController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('post');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? file;
  File? image;
  final picker = ImagePicker();

  Future getImageCamera() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        //Change _image to file
      } else {
        print("No Image Picked");
      }
    });
  }

  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  final firestorAuth = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  String imageUrl = '';

  String url = '';

  // uploadFile() async {
  //   image = File(widget.image);
  //
  //   var imageFile = FirebaseStorage.instance
  //       .ref()
  //       .child('images/${DateTime.now().toString()}');
  //   ;
  //
  //   UploadTask task = imageFile.putFile(image!);
  //   TaskSnapshot snapshot = await task;
  //
  //   // for downloading
  //   url = await snapshot.ref.getDownloadURL();
  //
  //   FirebaseFirestore.instance
  //       .collection("images")
  //       .doc()
  //       .set({"imageUrl": url, 'description': desController.text.toString()});
  //   print("qwertyu ${url}");
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? email = pref.getString('email');
  //
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection("userProgress")
  //       .where('email', isEqualTo: email)
  //       .get();
  //   final docId = querySnapshot.docs.first.id;
  //   await FirebaseFirestore.instance
  //       .collection("userProgress")
  //       .doc(docId)
  //       .update({
  //     'posts': FieldValue.increment(1),
  //     'points': FieldValue.increment(10),
  //   });
  //   await FirebaseFirestore.instance
  //       .collection('userProgress')
  //       .doc(docId)
  //       .collection('activities')
  //       .add({
  //     "picUrl": url,
  //     "activityType": "You have posed of dirty place and earned 10 points",
  //     'dateTime': DateTime.now().toString(),
  //   });
  // }

  Future<void> uploadFile() async {
    log('Upload function called');
    Fluttertoast.showToast(msg: 'Upload function called');
    try {
      image = File(widget.image);

      var imageFile = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');

      UploadTask task = imageFile.putFile(image!);
      TaskSnapshot snapshot = await task;

      url = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection("images").doc().set({
        "imageUrl": url,
        'description': desController.text.toString(),
      });

      print("Image URL: $url");

      SharedPreferences pref = await SharedPreferences.getInstance();
      String? email = pref.getString('email');

      if (email == null) {
        throw Exception("Email not found in SharedPreferences.");
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection("userProgress")
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No user found with the given email.");
      }

      final docId = querySnapshot.docs.first.id;

      await FirebaseFirestore.instance
          .collection("userProgress")
          .doc(docId)
          .update({
        'posts': FieldValue.increment(1),
        'points': FieldValue.increment(10),
      });

      await FirebaseFirestore.instance
          .collection('userProgress')
          .doc(docId)
          .collection('activities')
          .add({
        "picUrl": url,
        "activityType": "You have posted a dirty place and earned 10 points",
        'dateTime': DateTime.now().toString(),
      });
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backcolor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * .154,
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * .020,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: whitecolor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .250,
                  ),
                  Text(
                    "Create Your Post",
                    style: mediumgreen.copyWith(color: whitecolor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.96,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03,
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Image.file(
                            File(widget.image),
                            height: 200,
                            width: 200,
                            fit: BoxFit.fill,
                          ),

                          // child: ClipRRect(
                          //   borderRadius: BorderRadius.circular(8),
                          //   child:
                          // ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: GestureDetector(
                      onTap: () async {
                        // final coordinates=new Coordinates(34.05557741935044, 71.54595438219457);
                        // final address=await Geocoder.local.findAddressesFromCoordinates(coordinates);

                        // var first=address.first;
                        //
                        // print(first.featureName.toString() + first.addressLine.toString());

                        var position = determinePosition();
                        position.then(
                          (value) {
                            log("location =lt : " +
                                value.latitude.toString() +
                                'lg ,${value.longitude}');
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: greencolor,
                          ),
                          Text(
                            determinePosition().toString(),
                            style: boldgreen,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextField(
                      controller: desController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        constraints: BoxConstraints.tightFor(
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.width * .24),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          uploadFile();

                          // // String id = auth.currentUser!.uid;
                          // final abc = firestorAuth.collection("imagesPath");
                          // var data = Users(
                          //     id: '1', des: 'helllo', myPICUrl: widget.image);
                          //
                          // abc.doc('56').set(data.toMap());
                          //
                          // String uniqueFileName =
                          //     DateTime.now().millisecondsSinceEpoch.toString();
                          //
                          // Reference refUploadImage =
                          //     FirebaseStorage.instance.ref();
                          // Reference refDirImage =
                          //     refUploadImage.child('images');
                          //
                          // Reference refImageToUpload =
                          //     refDirImage.child(uniqueFileName);
                          // print("testing ${refDirImage}");
                          //
                          // try {
                          //   refImageToUpload.putFile(File(widget.image));
                          //   imageUrl = await refUploadImage.getDownloadURL();
                          // } catch (error) {}

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostCreated(
                                        img: widget.image,
                                        description: Text(desController.text),
                                      )));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                              color: greencolor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "Post Now",
                            style: btntext.copyWith(fontSize: 16),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
