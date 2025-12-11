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

import '../controllers/categories_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import 'country_selection.dart';
import 'recharge_screen.dart';
import 'social_bundles.dart';

class ServiceScreen extends StatefulWidget {
  ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());

  CountryListController countrylistController =
      Get.put(CountryListController());

  BundleController bundleController = Get.put(BundleController());

  ServiceController serviceController = Get.put(ServiceController());

  MyDrawerController drawerController = Get.put(MyDrawerController());

  final categorisListController = Get.find<CategorisListController>();

  // final countrylistController = Get.find<CountryListController>();
  final box = GetStorage();

  // final serviceController = Get.find<ServiceController>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final Mypagecontroller mypagecontroller = Get.find();

  List serviceimages = [
    "assets/icons/service1.png",
    "assets/icons/service2.png",
    "assets/icons/service3.png",
    "assets/icons/service4.png",
  ];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF1F3FF),
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
                          languagesController.tr("SERVICES"),
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
                  // color: Colors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2),
                  //     spreadRadius: 2,
                  //     blurRadius: 2,
                  //     offset: Offset(0, 0),
                  //   ),
                  // ],
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
                                      languagesController.tr("SELECT_SERIVCE"),
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
                              Obx(
                                () => categorisListController.isLoading.value ==
                                        false
                                    ? GridView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              2, // Number of columns in the grid
                                          crossAxisSpacing:
                                              8.0, // Spacing between columns
                                          mainAxisSpacing:
                                              8.0, // Spacing between rows
                                          childAspectRatio: 3.0,
                                        ),
                                        itemCount: categorisListController
                                            .allcategorieslist
                                            .value
                                            .data!
                                            .servicecategories!
                                            .length,
                                        itemBuilder: (context, index) {
                                          final data = categorisListController
                                              .allcategorieslist
                                              .value
                                              .data!
                                              .servicecategories![index];

                                          final imagePath = serviceimages[
                                              index % serviceimages.length];
                                          return GestureDetector(
                                            onTap: () {
                                              box.write(
                                                  "service_category_id",
                                                  categorisListController
                                                      .allcategorieslist
                                                      .value
                                                      .data!
                                                      .servicecategories![index]
                                                      .id);

                                              if (data.type.toString() ==
                                                  "nonsocial") {
                                                mypagecontroller.changePage(
                                                  InternetPack(),
                                                  isMainPage: false,
                                                );
                                                countrylistController
                                                    .fetchCountryData();
                                              } else {
                                                box.write("validity_type", "");

                                                box.write("search_tag", "");
                                                box.write(
                                                    "service_category_id",
                                                    categorisListController
                                                        .allcategorieslist
                                                        .value
                                                        .data!
                                                        .servicecategories![
                                                            index]
                                                        .id);

                                                box.write("country_id", "");
                                                box.write("company_id", "");
                                                bundleController.finalList
                                                    .clear();
                                                bundleController.initialpage =
                                                    1;

                                                mypagecontroller.changePage(
                                                  SocialBundles(),
                                                  isMainPage: false,
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Image.network(
                                                    data.categoryImageUrl
                                                        .toString(),
                                                    height:
                                                        screenHeight * 0.045,
                                                  ),
                                                  Text(
                                                    data.categoryName
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Color(0xff454F5B),
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize:
                                                          screenWidth * 0.030,
                                                      fontFamily:
                                                          languagesController
                                                                      .selectedlan ==
                                                                  "Fa"
                                                              ? "Iranfont"
                                                              : "Roboto",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      ),
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
