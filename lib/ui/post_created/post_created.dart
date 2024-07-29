import 'dart:io';
import 'package:clean_and_green/ui/home_screen/HomeScreen.dart';
import 'package:clean_and_green/ui/navigation_screen/navigationscreen.dart';
import 'package:clean_and_green/ui/post_created/PostProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/color.dart';
import '../../constant/textconstant.dart';
import '../../constant/textstyleC.dart';

class PostCreated extends StatefulWidget {
  String img;
  Text description;


   PostCreated({Key? key,required this.img, required this.description}) : super(key: key);

  @override
  State<PostCreated> createState() => _PostCreatedState();
}

class _PostCreatedState extends State<PostCreated> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostProvider(context),
      child: Consumer<PostProvider>(builder: (context, main, child) {
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
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * .020,
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
                        "Post Created",
                        style: mediumgreen.copyWith(color: whitecolor),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                          color: lightgreencolor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text("Post has been uploaded Successfully ",
                          style: boldgreen),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  height: MediaQuery.of(context).size.height * 0.48,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.01,
                            left: MediaQuery.of(context).size.width * 0.04,
                            right: MediaQuery.of(context).size.width * 0.04,
                          ),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: widget.description !=null ? widget.description : Container(
                              width: MediaQuery.of(context).size.width*0.200,
                              height: MediaQuery.of(context).size.height*0.50,
                              color: Colors.grey,
                              child: Text("No Description",style: TextStyle(color: Colors.black),),),
                          )
                      ),
                      Stack(
                        children:[
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.02,
                                right: MediaQuery.of(context).size.width * 0.02,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              width: MediaQuery.of(context).size.width * 0.90,
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: ClipRRect(child: Image.file(File(widget.img),
                                height:MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width * 0.90,
                                fit: BoxFit.fill,)),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right:MediaQuery.of(context).size.width * 0.04,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.02,
                                  left: MediaQuery.of(context).size.width * 0.02),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: white,
                                    size: MediaQuery.of(context).size.height*0.020,
                                  ),
                                  Text(
                                    itpark,
                                    style: tensizebold.copyWith(fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),


                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      left: MediaQuery.of(context).size.width * 0.2,
                      right: MediaQuery.of(context).size.width * 0.2,
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RootApp()));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            color: greencolor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text("Finish",
                            style: whitetext),
                      ),
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
