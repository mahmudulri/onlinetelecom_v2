import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import '../controllers/change_pin_controller.dart';
import '../controllers/font_controller.dart';

import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/network.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import '../widgets/custom_text.dart';

class SetSubresellerPin extends StatefulWidget {
  SetSubresellerPin({
    super.key,
    this.subID,
  });

  String? subID;

  @override
  State<SetSubresellerPin> createState() => _SetSubresellerPinState();
}

class _SetSubresellerPinState extends State<SetSubresellerPin> {
  final ChangePinController setpinController = Get.put(ChangePinController());

  LanguagesController languagesController = Get.put(LanguagesController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff011A52), // Status bar background color
      statusBarIconBrightness: Brightness.light, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return Scaffold(
      backgroundColor: Color(0xffF1F3FF),
      // drawer: DrawerWidget(),
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(0xffF1F3FF),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          mypagecontroller.changePage(
                            Network(),
                            isMainPage: false,
                          );
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 2,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              FontAwesomeIcons.chevronLeft,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Text(
                          languagesController.tr("SET_PIN"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          CustomFullScreenSheet.show(context);
                        },
                        child: Image.asset(
                          "assets/icons/drawericon.png",
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      body: Container(
        height: screenHeight,
        width: screenWidth,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Color(0xFFE0BCF3), // Left side color
        //       Color(0xFF7EE7EE), // Right side color
        //     ],
        //     begin: Alignment.centerLeft,
        //     end: Alignment.centerRight,
        //   ),
        // ),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => KText(
                              text: languagesController.tr("NEW_PIN"),
                              color: Colors.grey.shade600,
                              fontSize: screenHeight * 0.020,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      PasswordBox(
                        // hintText: languagesController.tr("ENTER_NEW_PIN"),
                        controller: setpinController.newPinController,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          KText(
                            text: languagesController.tr("CONFIRM_PIN"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      PasswordBox(
                        // hintText: languagesController.tr("ENTER_CONFIRM_PIN"),
                        controller: setpinController.confirmPinController,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Obx(
                        () => DefaultButton(
                          mycolor: Colors.green,
                          buttonName: setpinController.isLoading.value == false
                              ? languagesController.tr("CONFIRMATION")
                              : languagesController.tr("PLEASE_WAIT"),
                          onpressed: () {
                            final newPin =
                                setpinController.newPinController.text.trim();
                            final confirmPin = setpinController
                                .confirmPinController.text
                                .trim();

                            if (newPin.isEmpty || confirmPin.isEmpty) {
                              Fluttertoast.showToast(
                                msg: languagesController
                                    .tr("FILL_DATA_CORRECTLY"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else if (newPin != confirmPin) {
                              Fluttertoast.showToast(
                                msg: languagesController
                                    .tr("DONT_MATCH_BOTH_PIN"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              setpinController.setpin(widget.subID.toString());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordBox extends StatelessWidget {
  PasswordBox({
    super.key,
    this.hintText,
    this.controller,
  });

  String? hintText;
  TextEditingController? controller;
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.070,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                suffixIcon: Icon(
                  Icons.visibility_off,
                ),
                hintStyle: TextStyle(
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                )),
          ),
        ),
      ),
    );
  }
}
