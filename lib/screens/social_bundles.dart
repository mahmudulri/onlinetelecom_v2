import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_telecom/controllers/drawer_controller.dart';
import 'package:online_telecom/pages/homepages.dart';
import 'package:online_telecom/widgets/bottomsheet.dart';
import 'package:online_telecom/widgets/drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:online_telecom/controllers/bundle_controller.dart';
import 'package:online_telecom/controllers/confirm_pin_controller.dart';
import 'package:online_telecom/controllers/country_list_controller.dart';
import 'package:online_telecom/controllers/service_controller.dart';
import 'package:online_telecom/global_controller/languages_controller.dart';
import 'package:online_telecom/global_controller/page_controller.dart';
import 'package:online_telecom/helpers/price.dart';
import 'package:online_telecom/utils/colors.dart';

import 'country_selection.dart';
import 'service_screen.dart';

class SocialBundles extends StatefulWidget {
  SocialBundles({super.key});

  @override
  State<SocialBundles> createState() => _SocialBundlesState();
}

class _SocialBundlesState extends State<SocialBundles> {
  final serviceController = Get.find<ServiceController>();

  final bundleController = Get.find<BundleController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  // final confirmPinController = Get.find<ConfirmPinController>();

  final ScrollController scrollController = ScrollController();

  String search = "";
  String inputNumber = "";

  int selectedIndex = -1;
  int duration_selectedIndex = -1;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    bundleController.finalList.clear();
    bundleController.initialpage = 1;
    scrollController.addListener(refresh);
    // Use addPostFrameCallback to ensure this runs after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fetchservices();
      bundleController.fetchallbundles();
    });
  }

  Future<void> refresh() async {
    final int totalPages =
        bundleController.allbundleslist.value.payload?.pagination!.totalPages ??
            0;
    final int currentPage = bundleController.initialpage;

    // Prevent loading more pages if we've reached the last page
    if (currentPage >= totalPages) {
      print(
          "End..........................................End.....................");
      return;
    }

    // Check if the scroll position is at the bottom
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      bundleController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (bundleController.initialpage <= totalPages) {
        print("Load More...................");
        bundleController.fetchallbundles();
      } else {
        bundleController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  List countryCode = [
    "+93",
    "+880",
    "+91",
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyDrawerController drawerController = Get.put(MyDrawerController());

  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        mypagecontroller.goBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                            languagesController.tr("COMMUNICATION_PACKAGES"),
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
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                  width: screenWidth,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                languagesController.tr("PACKAGE_SELECTION"),
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                  fontFamily:
                                      languagesController.selectedlan == "Fa"
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
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.search_sharp,
                                  color: Colors.grey,
                                  size: screenHeight * 0.040,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Obx(
                                    () => TextField(
                                      decoration: InputDecoration(
                                        hintText: languagesController
                                            .tr("SEARCH_PACKAGE_NAME"),
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: screenWidth * 0.040,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          color: Colors.transparent,
                          width: screenWidth,
                          child: Obx(
                            () {
                              // Check if the allserviceslist is not null and contains data
                              final services = serviceController
                                      .allserviceslist.value.data?.services ??
                                  [];

                              // Show all services if input is empty, otherwise filter
                              final filteredServices = inputNumber.isEmpty
                                  ? services
                                  : services.where((service) {
                                      return service.company?.companycodes
                                              ?.any((code) {
                                            final reservedDigit =
                                                code.reservedDigit ?? '';
                                            return inputNumber
                                                .startsWith(reservedDigit);
                                          }) ??
                                          false;
                                    }).toList();

                              return serviceController.isLoading.value == false
                                  ? Center(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width: 5,
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                        itemCount: filteredServices.length,
                                        itemBuilder: (context, index) {
                                          final data = filteredServices[index];

                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                bundleController.initialpage =
                                                    1;
                                                bundleController.finalList
                                                    .clear();
                                                selectedIndex = index;
                                                box.write("company_id",
                                                    data.companyId);
                                                bundleController
                                                    .fetchallbundles();
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                color: selectedIndex == index
                                                    ? Color(0xff34495e)
                                                    : Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                  vertical: 5,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: data.company
                                                          ?.companyLogo ??
                                                      '',
                                                  placeholder: (context, url) {
                                                    print(
                                                        'Loading image: $url');
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ));
                                                  },
                                                  errorWidget:
                                                      (context, url, error) {
                                                    print(
                                                        'Error loading image: $url, error: $error');
                                                    return Icon(Icons.error);
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                        strokeWidth: 1.0,
                                      ),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Container(
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Column(
                        children: [
                          Expanded(
                            child: Obx(
                              () => bundleController.isLoading.value == false &&
                                      bundleController.finalList.isNotEmpty
                                  ? RefreshIndicator(
                                      onRefresh: refresh,
                                      child: GridView.builder(
                                        shrinkWrap: false,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        controller: scrollController,
                                        itemCount:
                                            bundleController.finalList.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5.0,
                                          mainAxisSpacing: 5.0,
                                          childAspectRatio: 0.7,
                                        ),
                                        itemBuilder: (context, index) {
                                          final data =
                                              bundleController.finalList[index];
                                          return GestureDetector(
                                            onTap: () {
                                              box.write("bundleID",
                                                  data.id.toString());
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        17,
                                                      ),
                                                    ),
                                                    content: SocialdialogBox(
                                                      companyname: data.service!
                                                          .company!.companyName
                                                          .toString(),
                                                      title: data.bundleTitle,
                                                      validity:
                                                          data.validityType,
                                                      buyingprice:
                                                          data.buyingPrice,
                                                      sellingprice:
                                                          data.sellingPrice,
                                                      imagelink: data.service!
                                                          .company!.companyLogo
                                                          .toString(),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  width: 1,
                                                  color: AppColors.primaryColor
                                                      .withOpacity(0.20),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    data.service!.company!
                                                        .companyName
                                                        .toString(),
                                                  ),
                                                  Image.network(
                                                    data.service!.company!
                                                        .companyLogo
                                                        .toString(),
                                                    height: 50,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        data.bundleTitle
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontSize:
                                                              screenHeight *
                                                                  0.015,
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   data.validityType
                                                      //       .toString(),
                                                      //   style: TextStyle(
                                                      //     color: AppColors
                                                      //         .primaryColor,
                                                      //     fontSize:
                                                      //         screenHeight * 0.012,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        languagesController
                                                            .tr("SALE"),
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade600,
                                                          fontSize:
                                                              screenHeight *
                                                                  0.012,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          PriceTextView(
                                                            price: data
                                                                .sellingPrice
                                                                .toString(),
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                            " ${box.read("currency_code")}",
                                                            style: TextStyle(
                                                              fontSize: 8,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : bundleController.finalList.isEmpty
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.grey,
                                          ),
                                        )
                                      : RefreshIndicator(
                                          onRefresh: refresh,
                                          child: GridView.builder(
                                            shrinkWrap: false,
                                            physics:
                                                AlwaysScrollableScrollPhysics(),
                                            controller: scrollController,
                                            itemCount: bundleController
                                                .finalList.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 5.0,
                                              mainAxisSpacing: 5.0,
                                              childAspectRatio: 0.7,
                                            ),
                                            itemBuilder: (context, index) {
                                              final data = bundleController
                                                  .finalList[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  box.write("bundleID",
                                                      data.id.toString());
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        contentPadding:
                                                            EdgeInsets.all(0),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            17,
                                                          ),
                                                        ),
                                                        content:
                                                            SocialdialogBox(
                                                          companyname: data
                                                              .service!
                                                              .company!
                                                              .companyName
                                                              .toString(),
                                                          title:
                                                              data.bundleTitle,
                                                          validity:
                                                              data.validityType,
                                                          buyingprice:
                                                              data.buyingPrice,
                                                          sellingprice:
                                                              data.sellingPrice,
                                                          imagelink: data
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(0.20),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        data.service!.company!
                                                            .companyName
                                                            .toString(),
                                                      ),
                                                      Image.network(
                                                        data.service!.company!
                                                            .companyLogo
                                                            .toString(),
                                                        height: 50,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            data.bundleTitle
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontSize:
                                                                  screenHeight *
                                                                      0.015,
                                                            ),
                                                          ),
                                                          // Text(
                                                          //   data.validityType
                                                          //       .toString(),
                                                          //   style: TextStyle(
                                                          //     color: AppColors
                                                          //         .primaryColor,
                                                          //     fontSize:
                                                          //         screenHeight * 0.012,
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("SALE"),
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontSize:
                                                                  screenHeight *
                                                                      0.012,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              PriceTextView(
                                                                price: data
                                                                    .sellingPrice
                                                                    .toString(),
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Text(
                                                                " ${box.read("currency_code")}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 8,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                            ),
                          ),
                          Obx(
                            () => bundleController.isLoading.value == true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SocialdialogBox extends StatefulWidget {
  SocialdialogBox({
    super.key,
    this.title,
    this.validity,
    this.buyingprice,
    this.sellingprice,
    this.imagelink,
    this.companyname,
  });

  String? companyname;
  String? title;
  String? validity;
  String? buyingprice;
  String? sellingprice;
  String? imagelink;

  @override
  State<SocialdialogBox> createState() => _SocialdialogBoxState();
}

class _SocialdialogBoxState extends State<SocialdialogBox> {
  String selectedCode = "+93";

  final countrylistController = Get.find<CountryListController>();

  final confirmPinController = Get.find<ConfirmPinController>();

  final box = GetStorage();

  final FocusNode _focusNode = FocusNode();

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 360,
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 45,
              vertical: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color(0xff1890FF),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.companyname.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Image.network(
                        widget.imagelink.toString(),
                        height: 70,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languagesController.tr("BUNDLE_TITLE"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 10,
                            ),
                          ),
                          // Text(
                          //   widget.validity.toString(),
                          //   style: TextStyle(
                          //     color: Color(0xff1890FF),
                          //     fontSize: 14,
                          //   ),
                          // ),
                          Text(
                            widget.title.toString(),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languagesController.tr("BUY"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.buyingprice.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languagesController.tr("SALE"),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.sellingprice.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 50,
              width: screenWidth,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  17,
                                ),
                              ),
                              content: Container(
                                height: 200,
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 55,
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          child: Row(
                                            children: [
                                              // Container(
                                              //   height: 50,
                                              //   width: 65,
                                              //   padding: EdgeInsets.symmetric(
                                              //       horizontal: 5),
                                              //   child:
                                              //       DropdownButtonHideUnderline(
                                              //     child: DropdownButton<String>(
                                              //       value: selectedCode,
                                              //       icon: Icon(
                                              //         FontAwesomeIcons
                                              //             .chevronDown,
                                              //         size: 15,
                                              //       ),
                                              //       items: countrylistController
                                              //           .countrycodelist
                                              //           .map((String code) {
                                              //         return DropdownMenuItem<
                                              //             String>(
                                              //           value: code,
                                              //           child: Text(code,
                                              //               style: TextStyle(
                                              //                   fontSize: 15)),
                                              //         );
                                              //       }).toList(),
                                              //       onChanged:
                                              //           (String? newValue) {
                                              //         if (newValue != null) {
                                              //           setState(() {
                                              //             selectedCode =
                                              //                 newValue;
                                              //           });
                                              //         }
                                              //       },
                                              //     ),
                                              //   ),
                                              // ),
                                              SizedBox(width: 6),
                                              // Phone Number Input Field
                                              Expanded(
                                                child: TextField(
                                                  controller:
                                                      confirmPinController
                                                          .numberController,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        languagesController.tr(
                                                            "PHONENUMBER_OR_ID"),
                                                    hintStyle: TextStyle(
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Container(
                                          height: 50,
                                          width: screenWidth,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (confirmPinController
                                                        .numberController
                                                        .text
                                                        .isNotEmpty) {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                17,
                                                              ),
                                                            ),
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            content:
                                                                StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                                return Container(
                                                                  height: 320,
                                                                  width:
                                                                      screenWidth,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            17),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Obx(
                                                                    () => confirmPinController.isLoading.value ==
                                                                                false &&
                                                                            confirmPinController.loadsuccess.value ==
                                                                                false
                                                                        ? Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 100,
                                                                                child: Lottie.asset('assets/loties/pin.json'),
                                                                              ),
                                                                              Container(
                                                                                height: 45,
                                                                                child: Obx(
                                                                                  () => Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        confirmPinController.isLoading.value == false && confirmPinController.loadsuccess.value == false ? languagesController.tr("CONFIRM_YOUR_PIN") : languagesController.tr("PLEASE_WAIT"),
                                                                                        style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: 15,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 7,
                                                                                      ),
                                                                                      confirmPinController.isLoading.value == true && confirmPinController.loadsuccess.value == true
                                                                                          ? Center(
                                                                                              child: CircularProgressIndicator(
                                                                                                color: Colors.black,
                                                                                              ),
                                                                                            )
                                                                                          : SizedBox(),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              // OTPInput(),
                                                                              Container(
                                                                                height: 40,
                                                                                width: 100,
                                                                                // color: Colors.red,
                                                                                child: TextField(
                                                                                  focusNode: _focusNode,
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                  controller: confirmPinController.pinController,
                                                                                  maxLength: 4,
                                                                                  textAlign: TextAlign.center,
                                                                                  keyboardType: TextInputType.phone,
                                                                                  decoration: InputDecoration(
                                                                                    counterText: '',
                                                                                    focusedBorder: UnderlineInputBorder(
                                                                                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                                                                    ),
                                                                                    enabledBorder: UnderlineInputBorder(
                                                                                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                                                                    ),
                                                                                    errorBorder: UnderlineInputBorder(
                                                                                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                                                                    ),
                                                                                    focusedErrorBorder: UnderlineInputBorder(
                                                                                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              SizedBox(
                                                                                height: 30,
                                                                              ),

                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                      confirmPinController.pinController.clear();
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 50,
                                                                                      width: 120,
                                                                                      decoration: BoxDecoration(
                                                                                        border: Border.all(
                                                                                          width: 1,
                                                                                          color: Colors.grey,
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          languagesController.tr("CANCEL"),
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 10),
                                                                                  GestureDetector(
                                                                                    onTap: () async {
                                                                                      if (!confirmPinController.isLoading.value) {
                                                                                        if (confirmPinController.pinController.text.isEmpty || confirmPinController.pinController.text.length != 4) {
                                                                                          Fluttertoast.showToast(
                                                                                            msg: languagesController.tr("ENTER_YOUR_PIN"),
                                                                                            toastLength: Toast.LENGTH_SHORT,
                                                                                            gravity: ToastGravity.BOTTOM,
                                                                                            timeInSecForIosWeb: 1,
                                                                                            backgroundColor: Colors.black,
                                                                                            textColor: Colors.white,
                                                                                            fontSize: 16.0,
                                                                                          );
                                                                                        } else {
                                                                                          await confirmPinController.verify(context);
                                                                                          if (confirmPinController.loadsuccess.value == true) {
                                                                                            print("recharge Done...........");
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 50,
                                                                                      width: 120,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.green,
                                                                                        border: Border.all(
                                                                                          width: 1,
                                                                                          color: Colors.grey,
                                                                                        ),
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          languagesController.tr("VERIFY"),
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )
                                                                        : Center(
                                                                            child:
                                                                                Container(
                                                                              height: 250,
                                                                              width: 250,
                                                                              child: Lottie.asset('assets/loties/recharge.json'),
                                                                            ),
                                                                          ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg: languagesController
                                                            .tr("ENTER_PHONE_NUMBER"),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        languagesController
                                                            .tr("CONFIRMATION"),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        languagesController
                                                            .tr("CANCEL"),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            languagesController.tr("CONFIRMATION"),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            languagesController.tr("CANCEL"),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
