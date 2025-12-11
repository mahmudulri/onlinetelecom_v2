import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_telecom/controllers/dashboard_controller.dart';
import 'package:online_telecom/controllers/sign_in_controller.dart';
import 'package:online_telecom/global_controller/page_controller.dart';
import 'package:online_telecom/global_controller/languages_controller.dart';
import 'package:online_telecom/routes/routes.dart';

import 'package:online_telecom/screens/sign_up_screen.dart';
import 'package:online_telecom/utils/colors.dart';
import 'package:online_telecom/widgets/authtextfield.dart';
import 'package:online_telecom/widgets/social_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/bottomsheet.dart';
import '../widgets/socialbuttonbox.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());
  // final Mypagecontroller mypagecontroller = Get.find();

  // final Mypagecontroller mypagecontroller = Get.find();

  final signInController = Get.find<SignInController>();

  final dashboardController = Get.find<DashboardController>();

  final box = GetStorage();

  final String phoneNumber = "+989386344752";

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF1F3FF),
        ),
        height: screenHeight,
        width: screenWidth,
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              height: 250,
              width: screenWidth,
              decoration: BoxDecoration(
                // color: Colors.red,
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/signinbanner.png",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languagesController.tr("WELCOME_BACK"),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * 0.025,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            languagesController.tr("ENTER_YOUR_LOGIN_INFO"),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: screenHeight * 0.020,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Authtextfield(
                    hinttext: languagesController.tr("USERNAME"),
                    controller: signInController.usernameController,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Authtextfield(
                    hinttext: languagesController.tr("PASSWORD"),
                    controller: signInController.passwordController,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        languagesController.tr("FORGOT_YOUR_PASSWORD"),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: screenHeight * 0.016,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        languagesController.tr("PASSWORD_RECOVERY"),
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: screenHeight * 0.017,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (signInController.usernameController.text.isEmpty ||
                          signInController.passwordController.text.isEmpty) {
                        Get.snackbar("Oops!", "Fill the text fields");
                      } else {
                        print("Attempting login...");
                        await signInController.signIn();

                        if (signInController.loginsuccess.value == false) {
                          dashboardController.fetchDashboardData();
                          // Navigating to the BottomNavigationbar page
                          // countryListController.fetchCountryData();
                          Get.toNamed(basescreen);

                          // if (box.read("direction") == "rtl") {
                          //   setState(() {
                          //     EasyLocalization.of(context)!
                          //         .setLocale(Locale('ar', 'AE'));
                          //   });
                          // } else {
                          //   setState(() {
                          //     EasyLocalization.of(context)!
                          //         .setLocale(Locale('en', 'US'));
                          //   });
                          // }
                        } else {
                          print("Navigation conditions not met.");
                        }
                      }
                    },
                    child: Container(
                      height: screenHeight * 0.060,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                          child: Obx(
                        () => Text(
                          signInController.isLoading.value == false
                              ? languagesController.tr("LOGIN")
                              : languagesController.tr("PLEASE_WAIT"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  // SocialButton(),
                  Container(
                    height: 60,
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            whatsapp();
                          },
                          child: Icon(
                            FontAwesomeIcons.whatsapp,
                            size: 35,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            showSocialPopup(context);
                          },
                          child: Image.asset(
                            "assets/icons/social-media.png",
                            height: 40,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            _makePhoneCall(phoneNumber);
                          },
                          child: Icon(
                            FontAwesomeIcons.phone,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        languagesController.tr("HAVE_NOT_REGISTERED_YET"),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: screenHeight * 0.018,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => SignUpScreen(),
                          //   ),
                          // );
                        },
                        child: Text(
                          languagesController.tr("REGISTER"),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: screenHeight * 0.018,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _makePhoneCall(String number) async {
  final Uri url = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

class languageBox extends StatelessWidget {
  const languageBox({
    super.key,
    this.lanName,
    this.onpressed,
  });
  final String? lanName;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onpressed,
        child: Container(
          margin: EdgeInsets.only(bottom: 6),
          height: 40,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
              child: Text(
            lanName.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          )),
        ),
      ),
    );
  }
}
