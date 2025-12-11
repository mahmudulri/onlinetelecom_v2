import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:online_telecom/controllers/bundle_controller.dart';
import 'package:online_telecom/controllers/confirm_pin_controller.dart';
import 'package:online_telecom/controllers/country_list_controller.dart';
import 'package:online_telecom/controllers/custom_history_controller.dart';
import 'package:online_telecom/controllers/dashboard_controller.dart';
import 'package:online_telecom/controllers/drawer_controller.dart';
import 'package:online_telecom/global_controller/languages_controller.dart';
import 'package:online_telecom/helpers/capture_image_helper.dart';
import 'package:online_telecom/screens/credit_transfer.dart';
import 'package:online_telecom/screens/country_selection.dart';
import 'package:online_telecom/utils/colors.dart';
import 'package:online_telecom/widgets/bottomsheet.dart';
import 'package:online_telecom/widgets/button_one.dart';
import 'package:intl/intl.dart';
import 'package:online_telecom/widgets/drawer.dart';
import '../controllers/categories_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/history_controller.dart';
import '../controllers/slider_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/service_screen.dart';
import '../screens/social_bundles.dart';
import 'orders.dart';

class Homepages extends StatefulWidget {
  Homepages({super.key});

  @override
  State<Homepages> createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  List serviceimages = [
    "assets/icons/service1.png",
    "assets/icons/service2.png",
    "assets/icons/service3.png",
    "assets/icons/service4.png",
  ];

  final dashboardController = Get.find<DashboardController>();

  final categorisListController = Get.find<CategorisListController>();

  int currentindex = 0;

  int currentSliderindex = 0;

  Timer? _timer;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _checkforUpdate();
    companyController.fetchCompany();

    historyController.finalList.clear();
    historyController.initialpage = 1;
    historyController.fetchHistory();
    countrylistController.fetchCountryData();
    scrollController.addListener(refresh);
  }

  Future<void> _checkforUpdate() async {
    print("checking");
    await InAppUpdate.checkForUpdate()
        .then((info) {
          setState(() {
            if (info.updateAvailability == UpdateAvailability.updateAvailable) {
              print("update available");
              _update();
            }
          });
        })
        .catchError((error) {
          print(error.toString());
        });
  }

  void _update() async {
    print("Updating");
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((error) {
      print(error.toString());
    });
  }

  final confirmPinController = Get.find<ConfirmPinController>();

  final bundleController = Get.find<BundleController>();
  final companyController = Get.find<CompanyController>();

  LanguagesController languagesController = Get.put(LanguagesController());
  MyDrawerController drawerController = Get.put(MyDrawerController());

  final historyController = Get.find<HistoryController>();

  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  void onButtonTap(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CountryListController countrylistController = Get.put(
    CountryListController(),
  );

  final ScrollController scrollController = ScrollController();

  Future<void> refresh() async {
    final int totalPages =
        historyController.allorderlist.value.payload?.pagination!.totalPages ??
        0;
    final int currentPage = historyController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
        "End..........................................End.....................",
      );
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      historyController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (historyController.initialpage <= totalPages) {
        print("Load More...................");
        historyController.fetchHistory();
      } else {
        historyController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    confirmPinController.numberController.clear();
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF1F3FF),
      appBar: AppBar(
        backgroundColor: Color(0xffF1F3FF),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    Obx(() {
                      final profileImageUrl = dashboardController
                          .alldashboardData
                          .value
                          .data
                          ?.userInfo
                          ?.profileImageUrl;

                      if (dashboardController.isLoading.value ||
                          profileImageUrl == null ||
                          profileImageUrl.isEmpty) {
                        return SizedBox();
                      }

                      return Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(profileImageUrl),
                            fit: BoxFit
                                .cover, // Optional: Ensures the image covers the container
                          ),
                        ),
                      );
                    }),
                    Spacer(),
                    Obx(
                      () => dashboardController.isLoading.value == false
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  dashboardController
                                      .alldashboardData
                                      .value
                                      .data!
                                      .userInfo!
                                      .resellerName
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      dashboardController
                                              .alldashboardData
                                              .value
                                              .data
                                              ?.resellerGroup !=
                                          null &&
                                      dashboardController
                                              .alldashboardData
                                              .value
                                              .data!
                                              .resellerGroup !=
                                          "null",
                                  child: Text(
                                    dashboardController
                                            .alldashboardData
                                            .value
                                            .data
                                            ?.resellerGroup ??
                                        '',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      fontFamily:
                                          box.read("language").toString() ==
                                              "Fa"
                                          ? "Roboto"
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        CustomFullScreenSheet.show(context);
                      },
                      child: Image.asset(
                        "assets/icons/drawericon.png",
                        height: 45,
                        width: 45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffF1F3FF)),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 5),
              Container(
                height: 130,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: PageView(
                          controller: _pageController,
                          physics:
                              NeverScrollableScrollPhysics(), // Disable swipe
                          children: [
                            BalanceWidget(),
                            SaleWidget(),
                            DebitWidget(),
                            ProfitWidget(),
                            ComissionWidget(),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Obx(
                        () => Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildButton(languageController.tr("BALANCE"), 0),
                              buildButton(languageController.tr("SALE"), 1),
                              buildButton(languageController.tr("DEBIT"), 2),
                              buildButton(languageController.tr("PROFIT"), 3),
                              buildButton(
                                languageController.tr("COMISSION"),
                                4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Obx(() {
                  if (dashboardController.isLoading.value) {
                    return SizedBox(
                      height: 130,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final sliderList =
                      dashboardController
                          .alldashboardData
                          .value
                          .data
                          ?.advertisementSliders ??
                      [];

                  if (sliderList.isEmpty) {
                    return SizedBox(
                      height: 130,
                      child: Center(child: Text("هیچ تبلیغی موجود نیست")),
                    );
                  }

                  return CarouselSlider.builder(
                    itemCount: sliderList.length,
                    itemBuilder: (context, index, realIdx) {
                      final item = sliderList[index];
                      final imageUrl = item.adSliderImageUrl;

                      final ImageProvider imageProvider =
                          (imageUrl != null && imageUrl.isNotEmpty)
                          ? NetworkImage(imageUrl)
                          : AssetImage("assets/images/demoslider.png")
                                as ImageProvider;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // child: Align(
                        //   alignment: Alignment.bottomLeft,
                        //   child: Container(
                        //     width: double.infinity,
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 10, vertical: 5),
                        //     decoration: BoxDecoration(
                        //       color: Colors.black.withOpacity(0.5),
                        //       borderRadius: BorderRadius.only(
                        //         bottomLeft: Radius.circular(10),
                        //         bottomRight: Radius.circular(10),
                        //       ),
                        //     ),
                        //     child: Text(
                        //       item.advertisementTitle ?? '',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //       maxLines: 1,
                        //       overflow: TextOverflow.ellipsis,
                        //     ),
                        //   ),
                        // ),
                      );
                    },
                    options: CarouselOptions(
                      height: 130,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 4),
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                    ),
                  );
                }),
              ),

              SizedBox(height: 10),
              Obx(
                () => CreditButton(
                  buttonhint: "credittransfer",
                  buttonName: languagesController.tr("CREDIT_TRANSFER"),
                  mycolor: Color(0xffFFFFFF),
                  onpressed: () {
                    mypagecontroller.changePage(
                      CreditTransfer(),
                      isMainPage: false,
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => ViewProdustButton(
                  buttonhint: "credittransfer",
                  buttonName: languagesController.tr("VIEW_PRODUCTS"),
                  mycolor: Color(0xffFFFFFF),
                  onpressed: () {
                    mypagecontroller.changePage(
                      ServiceScreen(),
                      isMainPage: false,
                    );
                  },
                ),
              ),

              // SizedBox(
              //   height: 5,
              // ),
              // Container(
              //   child: Obx(() => Row(
              //         children: [
              //           Text(
              //             languagesController.tr("HISTORY"),
              //             style: TextStyle(
              //               fontSize: screenWidth * 0.045,
              //               fontWeight: FontWeight.w600,
              //               color: Color(0xff8082ED),
              //               fontFamily: languagesController.selectedlan == "Fa"
              //                   ? "Iranfont"
              //                   : "Roboto",
              //             ),
              //           ),
              //         ],
              //       )),
              // ),
              SizedBox(height: 10),
              Obx(
                () => historyController.isLoading.value == false
                    ? Container(
                        child:
                            historyController
                                .allorderlist
                                .value
                                .data!
                                .orders
                                .isNotEmpty
                            ? SizedBox()
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/empty.png",
                                      height: 80,
                                    ),
                                    Text(
                                      languagesController.tr("NO_DATA_FOUND"),
                                    ),
                                  ],
                                ),
                              ),
                      )
                    : SizedBox(),
              ),
              Obx(
                () => historyController.isLoading.value == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
              Container(
                height: 400,
                width: screenWidth,
                child: Obx(
                  () =>
                      historyController.isLoading.value == false &&
                          historyController.finalList.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.separated(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 5);
                            },
                            itemCount: historyController.finalList.length,
                            itemBuilder: (context, index) {
                              final data = historyController.finalList[index];
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            17,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(0),
                                        content: DetailsDialog(
                                          status: data.status.toString(),
                                          bundletitle: data.bundle.bundleTitle
                                              .toString(),
                                          phoneNumber: data.rechargebleAccount
                                              .toString(),
                                          sellingPrice: data.bundle.sellingPrice
                                              .toString(),
                                          buyingPrice: data.bundle.buyingPrice
                                              .toString(),
                                          orderId: data.id.toString(),
                                          imagelink: data
                                              .bundle
                                              .service
                                              .company
                                              .companyLogo
                                              .toString(),
                                          date: data.createdAt.toString(),
                                          contactname: dashboardController
                                              .alldashboardData
                                              .value
                                              .data!
                                              .userInfo!
                                              .contactName
                                              .toString(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 60,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                data
                                                    .bundle!
                                                    .service!
                                                    .company!
                                                    .companyLogo
                                                    .toString(),
                                              ),
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    data.bundle!.bundleTitle
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  data.rechargebleAccount
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'en_US',
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                ).format(
                                                  double.parse(
                                                    data.bundle!.sellingPrice
                                                        .toString(),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 2),
                                              Text(
                                                " " + box.read("currency_code"),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  data.status.toString() == "0"
                                                      ? languagesController.tr(
                                                          "PENDING",
                                                        )
                                                      : data.status
                                                                .toString() ==
                                                            "1"
                                                      ? languagesController.tr(
                                                          "CONFIRMED",
                                                        )
                                                      : languagesController.tr(
                                                          "REJECTED",
                                                        ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                // Text(
                                                //   "2 days ago",
                                                //   style: TextStyle(
                                                //     color: Colors.green,
                                                //     fontSize: 10,
                                                //     fontWeight:
                                                //         FontWeight.w600,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : historyController.finalList.isEmpty
                      ? SizedBox()
                      : RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.separated(
                            shrinkWrap: false,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 5);
                            },
                            itemCount: historyController.finalList.length,
                            itemBuilder: (context, index) {
                              final data = historyController.finalList[index];
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            17,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(0),
                                        content: DetailsDialog(
                                          status: data.status.toString(),
                                          bundletitle: data.bundle.bundleTitle
                                              .toString(),
                                          phoneNumber: data.rechargebleAccount
                                              .toString(),
                                          sellingPrice: data.bundle.sellingPrice
                                              .toString(),
                                          buyingPrice: data.bundle.buyingPrice
                                              .toString(),
                                          orderId: data.id.toString(),
                                          imagelink: data
                                              .bundle
                                              .service
                                              .company
                                              .companyLogo
                                              .toString(),
                                          date: data.createdAt.toString(),
                                          contactname: dashboardController
                                              .alldashboardData
                                              .value
                                              .data!
                                              .userInfo!
                                              .contactName
                                              .toString(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 60,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                data
                                                    .bundle!
                                                    .service!
                                                    .company!
                                                    .companyLogo
                                                    .toString(),
                                              ),
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    data.bundle!.bundleTitle
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  data.rechargebleAccount
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'en_US',
                                                  symbol: '',
                                                  decimalDigits: 2,
                                                ).format(
                                                  double.parse(
                                                    data.bundle!.sellingPrice
                                                        .toString(),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 2),
                                              Text(
                                                " " + box.read("currency_code"),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Icon(
                                                //   Icons.check,
                                                //   color: Colors.green,
                                                //   size: 14,
                                                // ),
                                                Text(
                                                  data.status.toString() == "0"
                                                      ? languagesController.tr(
                                                          "PENDING",
                                                        )
                                                      : data.status
                                                                .toString() ==
                                                            "1"
                                                      ? languagesController.tr(
                                                          "CONFIRMED",
                                                        )
                                                      : languagesController.tr(
                                                          "REJECTED",
                                                        ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, int index) {
    bool isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => onButtonTap(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive ? AppColors.primaryColor : Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: languagesController.selectedlan == "Fa"
                  ? "Iranfont"
                  : "Roboto",
            ),
          ),
        ),
      ),
    );
  }
}

class BalanceWidget extends StatelessWidget {
  final dashboardController = Get.find<DashboardController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Obx(
                () => Text(
                  languageController.tr("BALANCE"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: languagesController.selectedlan == "Fa"
                        ? "Iranfont"
                        : "Roboto",
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 20,
                  child: Image.asset("assets/icons/line.png"),
                ),
              ),
              SizedBox(width: 20),
              Obx(
                () => dashboardController.isLoading.value == false
                    ? Row(
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'en_US',
                              symbol: '',
                              decimalDigits: 2,
                            ).format(
                              double.parse(
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .balance
                                    .toString(),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily:
                                  languagesController.selectedlan == "Fa"
                                  ? "Iranfont"
                                  : "Roboto",
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            box.read("currency_code"),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaleWidget extends StatelessWidget {
  final dashboardController = Get.find<DashboardController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Obx(
                () => Text(
                  languageController.tr("SALE"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: languagesController.selectedlan == "Fa"
                        ? "Iranfont"
                        : "Roboto",
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 20,
                  child: Image.asset("assets/icons/line.png"),
                ),
              ),
              SizedBox(width: 20),
              Obx(
                () => dashboardController.isLoading.value == false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '',
                                  decimalDigits: 2,
                                ).format(
                                  double.parse(
                                    dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .totalSoldAmount
                                        .toString(),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily:
                                      languagesController.selectedlan == "Fa"
                                      ? "Iranfont"
                                      : "Roboto",
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                box.read("currency_code"),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '',
                                  decimalDigits: 2,
                                ).format(
                                  double.parse(
                                    dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .todaySale
                                        .toString(),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily:
                                      languagesController.selectedlan == "Fa"
                                      ? "Iranfont"
                                      : "Roboto",
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                box.read("currency_code"),
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DebitWidget extends StatelessWidget {
  final dashboardController = Get.find<DashboardController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Obx(
                () => Text(
                  languageController.tr("DEBIT"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: languagesController.selectedlan == "Fa"
                        ? "Iranfont"
                        : "Roboto",
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 20,
                  child: Image.asset("assets/icons/line.png"),
                ),
              ),
              SizedBox(width: 20),
              Obx(
                () => dashboardController.isLoading.value == false
                    ? Row(
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'en_US',
                              symbol: '',
                              decimalDigits: 2,
                            ).format(
                              double.parse(
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .loanBalance
                                    .toString(),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily:
                                  languagesController.selectedlan == "Fa"
                                  ? "Iranfont"
                                  : "Roboto",
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            box.read("currency_code"),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfitWidget extends StatelessWidget {
  final dashboardController = Get.find<DashboardController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Obx(
                () => Text(
                  languageController.tr("PROFIT"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: languagesController.selectedlan == "Fa"
                        ? "Iranfont"
                        : "Roboto",
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 20,
                  child: Image.asset("assets/icons/line.png"),
                ),
              ),
              SizedBox(width: 8),
              Obx(
                () => dashboardController.isLoading.value == false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '',
                                  decimalDigits: 2,
                                ).format(
                                  double.parse(
                                    dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .totalRevenue
                                        .toString(),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily:
                                      languagesController.selectedlan == "Fa"
                                      ? "Iranfont"
                                      : "Roboto",
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                box.read("currency_code"),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '',
                                  decimalDigits: 2,
                                ).format(
                                  double.parse(
                                    dashboardController
                                        .alldashboardData
                                        .value
                                        .data!
                                        .todayProfit
                                        .toString(),
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily:
                                      languagesController.selectedlan == "Fa"
                                      ? "Iranfont"
                                      : "Roboto",
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                box.read("currency_code"),
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComissionWidget extends StatelessWidget {
  final dashboardController = Get.find<DashboardController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Obx(
                () => Text(
                  languageController.tr("COMISSION"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: languagesController.selectedlan == "Fa"
                        ? "Iranfont"
                        : "Roboto",
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 20,
                  child: Image.asset("assets/icons/line.png"),
                ),
              ),
              SizedBox(width: 20),
              Obx(
                () => dashboardController.isLoading.value == false
                    ? Row(
                        children: [
                          Text(
                            NumberFormat.currency(
                              locale: 'en_US',
                              symbol: '',
                              decimalDigits: 2,
                            ).format(
                              double.parse(
                                dashboardController
                                    .alldashboardData
                                    .value
                                    .data!
                                    .userInfo!
                                    .totalearning
                                    .toString(),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily:
                                  languagesController.selectedlan == "Fa"
                                  ? "Iranfont"
                                  : "Roboto",
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            box.read("currency_code"),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
