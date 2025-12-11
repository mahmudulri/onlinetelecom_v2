import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_controller/languages_controller.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({
    super.key,
    this.buttonName,
    this.mycolor,
    this.onpressed,
  });

  String? buttonName;
  Color? mycolor;
  VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: screenHeight * 0.065,
        width: screenWidth,
        decoration: BoxDecoration(
          color: mycolor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            buttonName.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: screenHeight * 0.020,
            ),
          ),
        ),
      ),
    );
  }
}

class CreditButton extends StatelessWidget {
  CreditButton({
    super.key,
    this.buttonName,
    this.mycolor,
    this.onpressed,
    this.buttonhint,
  });

  String? buttonName;
  Color? mycolor;
  VoidCallback? onpressed;
  String? buttonhint;

  LanguagesController languagesController = Get.put(LanguagesController());
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: screenHeight * 0.065,
        width: screenWidth,
        decoration: BoxDecoration(
          color: mycolor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/icons/credit-transfer.png",
                      height: 40,
                      width: 40,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 5,
              child: Text(
                buttonName.toString(),
                style: TextStyle(
                  color: Color(0xff454F5B),
                  fontWeight: buttonhint.toString() == "credittransfer"
                      ? FontWeight.bold
                      : FontWeight.w500,
                  fontSize: screenWidth * 0.045,
                  fontFamily: languagesController.selectedlan == "Fa"
                      ? "Iranfont"
                      : "Roboto",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewProdustButton extends StatelessWidget {
  ViewProdustButton({
    super.key,
    this.buttonName,
    this.mycolor,
    this.onpressed,
    this.buttonhint,
  });

  String? buttonName;
  Color? mycolor;
  VoidCallback? onpressed;
  String? buttonhint;

  LanguagesController languagesController = Get.put(LanguagesController());
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: screenHeight * 0.065,
        width: screenWidth,
        decoration: BoxDecoration(
          color: mycolor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/icons/services.png",
                      height: 40,
                      width: 40,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 5,
              child: Text(
                buttonName.toString(),
                style: TextStyle(
                  color: Color(0xff454F5B),
                  fontWeight: buttonhint.toString() == "credittransfer"
                      ? FontWeight.bold
                      : FontWeight.w500,
                  fontSize: screenWidth * 0.045,
                  fontFamily: languagesController.selectedlan == "Fa"
                      ? "Iranfont"
                      : "Roboto",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
