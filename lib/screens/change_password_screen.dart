import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import '../controllers/change_password_controller.dart';
import '../controllers/font_controller.dart';

import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/homepages.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import '../widgets/custom_text.dart';

import 'change_balance.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController changePasswordController =
      Get.put(ChangePasswordController());

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
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
                            Homepages(),
                            isMainPage: true,
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
                          languagesController.tr("CHANGE_PASSWORD"),
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text: languagesController.tr("CURRENT_PASSWORD"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ChangePinBox(
                      // hintText:
                      //     languagesController.tr("ENTER_CURRENT_PASSWORD"),
                      controller:
                          changePasswordController.currentpassController,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text: languagesController.tr("NEW_PASSWORD"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ChangePinBox(
                      // hintText:
                      //     languagesController.tr("ENTER_NEW_PASSWORD"),
                      controller: changePasswordController.newpassController,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Obx(
                          () => KText(
                            text:
                                languagesController.tr("CONFIRM_NEW_PASSWORD"),
                            color: Colors.grey.shade600,
                            fontSize: screenHeight * 0.020,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ChangePinBox(
                      // hintText:
                      //     languagesController.tr("CONFIRM_NEW_PASSWORD"),
                      controller:
                          changePasswordController.confirmpassController,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Obx(
                      () => DefaultButton(
                        mycolor: Colors.green,
                        buttonName:
                            changePasswordController.isLoading.value == false
                                ? languagesController.tr("CHANGE_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                        onpressed: () {
                          if (changePasswordController
                                  .currentpassController.text.isEmpty ||
                              changePasswordController
                                  .newpassController.text.isEmpty ||
                              changePasswordController
                                  .confirmpassController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: languagesController
                                    .tr("FILL_DATA_CORRECTLY"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            changePasswordController.change();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePinBox extends StatelessWidget {
  ChangePinBox({
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
      height: screenHeight * 0.065,
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
              hintStyle: TextStyle(
                fontSize: 15,
              ),
              hintText: hintText,
              border: InputBorder.none,
              // suffixIcon: Icon(
              //   Icons.visibility_off,
              // ),
            ),
            style: TextStyle(
              fontFamily: box.read("language").toString() == "Fa"
                  ? Get.find<FontController>().currentFont
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
