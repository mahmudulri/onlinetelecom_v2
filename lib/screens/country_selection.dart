import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_telecom/controllers/bundle_controller.dart';
import 'package:online_telecom/controllers/country_list_controller.dart';
import 'package:online_telecom/controllers/dashboard_controller.dart';
import 'package:online_telecom/controllers/drawer_controller.dart';
import 'package:online_telecom/controllers/service_controller.dart';
import 'package:online_telecom/global_controller/languages_controller.dart';
import 'package:online_telecom/pages/homepages.dart';
import 'package:online_telecom/widgets/bottomsheet.dart';
import 'package:online_telecom/widgets/drawer.dart';

import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import 'recharge_screen.dart';
import 'service_screen.dart';

class InternetPack extends StatefulWidget {
  InternetPack({super.key});

  @override
  State<InternetPack> createState() => _InternetPackState();
}

class _InternetPackState extends State<InternetPack> {
  LanguagesController languagesController = Get.put(LanguagesController());

  CountryListController countrylistController =
      Get.put(CountryListController());

  BundleController bundleController = Get.put(BundleController());

  ServiceController serviceController = Get.put(ServiceController());

  MyDrawerController drawerController = Get.put(MyDrawerController());

  // final countrylistController = Get.find<CountryListController>();
  final box = GetStorage();

  // final serviceController = Get.find<ServiceController>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // drawer: DrawerWidget(),
      key: scaffoldKey,
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
                            ServiceScreen(),
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
                          languagesController.tr("COUNTRY_SELECTION"),
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
        decoration: BoxDecoration(
          color: Color(0xffF1F3FF),
        ),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: screenWidth,
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
                  padding: EdgeInsets.all(8.0),
                  child: Obx(
                    () => countrylistController.isLoading.value == false
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => Text(
                                      languagesController.tr("RESERVE_FOR"),
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                        fontFamily:
                                            languagesController.selectedlan ==
                                                    "Fa"
                                                ? "Iranfont"
                                                : "Roboto",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                  childAspectRatio: 1.5,
                                ),
                                itemCount: countrylistController
                                    .finalCountryList.length,
                                itemBuilder: (context, index) {
                                  final data = countrylistController
                                      .finalCountryList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      box.write("country_id", data["id"]);
                                      box.write(
                                          "countryName", data["country_name"]);
                                      serviceController.reserveDigit.clear();
                                      bundleController.finalList.clear();
                                      box.write("maxlength",
                                          data["phone_number_length"]);
                                      box.write("validity_type", "");
                                      box.write("company_id", "");
                                      box.write("search_tag", "");
                                      mypagecontroller.changePage(
                                        RechargeScreen(),
                                        isMainPage: false,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffEEF4FF),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.grey.shade300,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.grey,
                                              backgroundImage: NetworkImage(data[
                                                  "country_flag_image_url"]),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              data["country_name"],
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: screenHeight * 0.020,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
