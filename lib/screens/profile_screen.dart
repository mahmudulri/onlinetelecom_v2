import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_telecom/controllers/dashboard_controller.dart';
import 'package:online_telecom/controllers/drawer_controller.dart';
import 'package:online_telecom/global_controller/languages_controller.dart';
import 'package:online_telecom/pages/homepages.dart';
import 'package:online_telecom/screens/change_pin.dart';
import 'package:online_telecom/utils/colors.dart';
import 'package:online_telecom/widgets/bottomsheet.dart';
import 'package:online_telecom/widgets/button_one.dart';
import 'package:online_telecom/widgets/drawer.dart';

import '../global_controller/page_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // File? _selectedImage;
  // Future<void> _pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  //   if (image != null) {
  //     setState(() {
  //       _selectedImage = File(image.path);
  //     });
  //   }
  // }

  final dashboardController = Get.find<DashboardController>();

  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      // drawer: DrawerWidget(),
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
                          languagesController.tr("PROFILE"),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.040,
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
        decoration: BoxDecoration(
          color: Color(0xffF1F3FF),
        ),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 12,
              ),
              Center(
                child: dashboardController.alldashboardData.value.data!
                            .userInfo!.profileImageUrl !=
                        null
                    ? Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              dashboardController.alldashboardData.value.data!
                                  .userInfo!.profileImageUrl
                                  .toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                    : Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: GestureDetector(
                  onTap: () {
                    mypagecontroller.changePage(
                      ChangePinScreen(),
                      isMainPage: false,
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.055,
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Obx(
                        () => Text(
                          languagesController.tr("CHANGE_PIN"),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: screenHeight * 0.018,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("FULL_NAME"),
                  data: dashboardController
                      .alldashboardData.value.data!.userInfo!.resellerName
                      .toString(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("EMAIL"),
                  data: dashboardController
                      .alldashboardData.value.data!.userInfo!.email
                      .toString(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("PHONENUMBER"),
                  data: dashboardController
                      .alldashboardData.value.data!.userInfo!.phone
                      .toString(),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Profilebox(
              //   boxname: "Location",
              //   data: "IRAN, RAZAVIKHHORASAN, MASHHAD",
              // ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("BALANCE"),
                  data: dashboardController
                          .alldashboardData.value.data!.userInfo!.balance
                          .toString() +
                      " "
                          "${box.read("currency_code")}",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("LOAN_BALANCE"),
                  data: dashboardController
                          .alldashboardData.value.data!.userInfo!.loanBalance
                          .toString() +
                      " "
                          "${box.read("currency_code")}",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("TOTAL_SOLD_AMOUNT"),
                  data: dashboardController
                          .alldashboardData.value.data!.totalSoldAmount
                          .toString() +
                      " "
                          "${box.read("currency_code")}",
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => Profilebox(
                  boxname: languagesController.tr("TOTAL_REVENUE"),
                  data: dashboardController
                          .alldashboardData.value.data!.totalRevenue
                          .toString() +
                      " "
                          "${box.read("currency_code")}",
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Profilebox extends StatelessWidget {
  Profilebox({super.key, this.boxname, this.data});

  String? boxname;
  String? data;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.070,
      width: screenWidth,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(boxname.toString()),
            Text(
              data.toString(),
              style: TextStyle(
                fontSize: screenHeight * 0.0150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
