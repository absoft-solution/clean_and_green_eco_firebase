import 'package:clean_and_green/constant/textstyleC.dart';
import 'package:flutter/material.dart';

import 'color.dart';

class CustomBtn extends StatelessWidget {
  String text;
  Function() onPress;

  CustomBtn({Key? key, required this.text, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.01,
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04,
        ),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
              color: greencolor, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: btntext.copyWith(fontSize: 16),
              ),
              Image.asset(
                "assets/images/cleanit.png",
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
