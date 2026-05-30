import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_telecom/controllers/drawer_controller.dart';
import 'package:online_telecom/widgets/bottomsheet.dart';
import 'package:lottie/lottie.dart';
import 'package:online_telecom/controllers/country_list_controller.dart';
import 'package:online_telecom/controllers/custom_history_controller.dart';
import 'package:online_telecom/controllers/custom_recharge_controller.dart';
import 'package:online_telecom/global_controller/languages_controller.dart';
import 'package:online_telecom/global_controller/page_controller.dart';
import 'package:online_telecom/pages/homepages.dart';
import 'package:online_telecom/utils/colors.dart';
import 'package:online_telecom/widgets/button_one.dart';

import '../controllers/company_controller.dart';
import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller.dart';

class CreditTransfer extends StatefulWidget {
  CreditTransfer({super.key});

  @override
  State<CreditTransfer> createState() => _CreditTransferState();
}

class _CreditTransferState extends State<CreditTransfer> {
  final customhistoryController = Get.find<CustomHistoryController>();

  final countryListController = Get.find<CountryListController>();
  LanguagesController languagesController = Get.put(LanguagesController());
  CurrencyController currencyController = Get.put(CurrencyController());
  CustomRechargeController customRechargeController = Get.put(
    CustomRechargeController(),
  );
  final box = GetStorage();
  int selectedIndex = 0;

  final FocusNode _focusNode = FocusNode();

  RxList<bool> expandedIndices = <bool>[].obs;

  final ScrollController scrollController = ScrollController();

  final companyController = Get.find<CompanyController>();

  ConversationController conversationController = Get.put(
    ConversationController(),
  );

  Future<void> refresh() async {
    final int totalPages =
        customhistoryController
            .allorderlist
            .value
            .payload
            ?.pagination!
            .totalPages ??
        0;
    final int currentPage = customhistoryController.initialpage;

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
      customhistoryController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (customhistoryController.initialpage <= totalPages) {
        print("Load More...................");
        customhistoryController.fetchHistory();
      } else {
        customhistoryController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customhistoryController.finalList.clear();
    customhistoryController.initialpage = 1;
    customhistoryController.fetchHistory();
    currencyController.fetchCurrency();
    scrollController.addListener(refresh);
    customRechargeController.numberController.addListener(() {
      final text = customRechargeController.numberController.text;
      companyController.matchCompanyByPhoneNumber(text);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MyDrawerController drawerController = Get.put(MyDrawerController());
  @override
  Widget build(BuildContext context) {
    final Mypagecontroller mypagecontroller = Get.find();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        mypagecontroller.goBack();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        // drawer: DrawerWidget(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(color: Color(0xffF1F3FF)),
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
                              child: Icon(FontAwesomeIcons.chevronLeft),
                            ),
                          ),
                        ),
                        Spacer(),
                        Obx(
                          () => Text(
                            languagesController.tr("CREDIT_TRANSFER"),
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

        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(color: Color(0xffF1F3FF)),
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    countryListController.flagimageurl
                                        .toString(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                    ),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: customRechargeController
                                          .numberController,
                                      style: TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: languagesController.tr(
                                          "PHONENUMBER",
                                        ),
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(() {
                                final company =
                                    companyController.matchedCompany.value;
                                return Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: company == null
                                        ? Colors.transparent
                                        : null,
                                    image: company != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              company.companyLogo ?? '',
                                            ),
                                            fit: BoxFit.contain,
                                          )
                                        : null,
                                  ),
                                  child: company == null
                                      ? Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.transparent,
                                          ),
                                        )
                                      : null,
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 55,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) {
                                      conversationController.inputAmount.value =
                                          double.tryParse(value) ?? 0.0;
                                    },
                                    controller: customRechargeController
                                        .amountController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: languagesController.tr(
                                        "AMOUNT",
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                // Text(
                                //   "IRR",
                                //   style: TextStyle(
                                //     color: Colors.grey.shade600,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 50,
                          child: Obx(() {
                            final convertedList = conversationController
                                .getConvertedValues();

                            if (convertedList.isEmpty) {
                              return Center(child: Text(""));
                            }

                            final item =
                                convertedList.first; // only show the first item

                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "${item['symbol']} (${item['name']}):",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      item['value'].toStringAsFixed(2),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        DefaultButton(
                          buttonName: languagesController.tr(
                            "SEND_TO_DESTINATION",
                          ),
                          mycolor: Color(0xff00AB55),
                          onpressed: () {
                            if (customRechargeController
                                    .numberController
                                    .text
                                    .isEmpty ||
                                customRechargeController
                                    .amountController
                                    .text
                                    .isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Enter required data",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    content: StatefulBuilder(
                                      builder: (context, setState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              17,
                                            ),
                                            color: Colors.white,
                                          ),
                                          height: 150,
                                          width: screenWidth,
                                          child: Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(height: 8),
                                                Text(
                                                  languagesController.tr(
                                                    "ARE_YOU_SURE_TO_TRANSFER",
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                  width: screenWidth,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) {
                                                                return AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          17,
                                                                        ),
                                                                  ),
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  content: StatefulBuilder(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                          setState,
                                                                        ) {
                                                                          return Container(
                                                                            height:
                                                                                320,
                                                                            width:
                                                                                screenWidth,
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(
                                                                                17,
                                                                              ),
                                                                              color: Colors.white,
                                                                            ),
                                                                            child: Obx(
                                                                              () =>
                                                                                  customRechargeController.isLoading.value ==
                                                                                          false &&
                                                                                      customRechargeController.loadsuccess.value ==
                                                                                          false
                                                                                  ? Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: 100,
                                                                                          child: Lottie.asset(
                                                                                            'assets/loties/pin.json',
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 45,
                                                                                          child: Obx(
                                                                                            () => Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Text(
                                                                                                  customRechargeController.isLoading.value ==
                                                                                                              false &&
                                                                                                          customRechargeController.loadsuccess.value ==
                                                                                                              false
                                                                                                      ? languagesController.tr(
                                                                                                          "CONFIRM_YOUR_PIN",
                                                                                                        )
                                                                                                      : languagesController.tr(
                                                                                                          "PLEASE_WAIT",
                                                                                                        ),
                                                                                                  style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontSize: 15,
                                                                                                  ),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: 7,
                                                                                                ),
                                                                                                customRechargeController.isLoading.value ==
                                                                                                            true &&
                                                                                                        customRechargeController.loadsuccess.value ==
                                                                                                            true
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
                                                                                            controller: customRechargeController.pinController,
                                                                                            maxLength: 4,
                                                                                            textAlign: TextAlign.center,
                                                                                            keyboardType: TextInputType.phone,
                                                                                            decoration: InputDecoration(
                                                                                              counterText: '',
                                                                                              focusedBorder: UnderlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  color: Colors.grey,
                                                                                                  width: 2.0,
                                                                                                ),
                                                                                              ),
                                                                                              enabledBorder: UnderlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  color: Colors.grey,
                                                                                                  width: 2.0,
                                                                                                ),
                                                                                              ),
                                                                                              errorBorder: UnderlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  color: Colors.grey,
                                                                                                  width: 2.0,
                                                                                                ),
                                                                                              ),
                                                                                              focusedErrorBorder: UnderlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  color: Colors.grey,
                                                                                                  width: 2.0,
                                                                                                ),
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
                                                                                                Navigator.pop(
                                                                                                  context,
                                                                                                );
                                                                                                customRechargeController.pinController.clear();
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 50,
                                                                                                width: 120,
                                                                                                decoration: BoxDecoration(
                                                                                                  border: Border.all(
                                                                                                    width: 1,
                                                                                                    color: Colors.grey,
                                                                                                  ),
                                                                                                  borderRadius: BorderRadius.circular(
                                                                                                    5,
                                                                                                  ),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Text(
                                                                                                    languagesController.tr(
                                                                                                      "CANCEL",
                                                                                                    ),
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontSize: 15,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            GestureDetector(
                                                                                              onTap: () async {
                                                                                                if (!customRechargeController.isLoading.value) {
                                                                                                  if (customRechargeController.pinController.text.isEmpty ||
                                                                                                      customRechargeController.pinController.text.length !=
                                                                                                          4) {
                                                                                                    Fluttertoast.showToast(
                                                                                                      msg: languagesController.tr(
                                                                                                        "ENTER_YOUR_PIN",
                                                                                                      ),
                                                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                                                      gravity: ToastGravity.BOTTOM,
                                                                                                      timeInSecForIosWeb: 1,
                                                                                                      backgroundColor: Colors.black,
                                                                                                      textColor: Colors.white,
                                                                                                      fontSize: 16.0,
                                                                                                    );
                                                                                                  } else {
                                                                                                    await customRechargeController.verify(
                                                                                                      context,
                                                                                                    );
                                                                                                    if (customRechargeController.loadsuccess.value ==
                                                                                                        true) {
                                                                                                      print(
                                                                                                        "recharge Done...........",
                                                                                                      );
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 60,
                                                                                                width: 120,
                                                                                                decoration: BoxDecoration(
                                                                                                  color: Colors.green,
                                                                                                  border: Border.all(
                                                                                                    width: 1,
                                                                                                    color: Colors.grey,
                                                                                                  ),
                                                                                                  borderRadius: BorderRadius.circular(
                                                                                                    5,
                                                                                                  ),
                                                                                                ),
                                                                                                child: Center(
                                                                                                  child: Text(
                                                                                                    languagesController.tr(
                                                                                                      "VERIFY",
                                                                                                    ),
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.white,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontSize: 15,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Center(
                                                                                      child: Container(
                                                                                        height: 250,
                                                                                        width: 250,
                                                                                        child: Lottie.asset(
                                                                                          'assets/loties/recharge.json',
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                          );
                                                                        },
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        6,
                                                                      ),
                                                                ),
                                                            child: Center(
                                                              child: Text(
                                                                languagesController.tr(
                                                                  "CONFIRMATION",
                                                                ),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                        flex: 2,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    6,
                                                                  ),
                                                              border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                languagesController
                                                                    .tr(
                                                                      "CANCEL",
                                                                    ),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 800,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                languagesController.tr("TRANSFER_HISTORY"),
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
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          height: 50,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Text("All"),
                                Spacer(),
                                Icon(
                                  FontAwesomeIcons.chevronDown,
                                  color: Colors.grey.shade600,
                                  size: screenHeight * 0.018,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 50,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Text("Date"),
                                Spacer(),
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey.shade600,
                                  size: screenHeight * 0.018,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 50,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.grey.shade600),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: languagesController.tr(
                                        "SEARCH_BY_PHOENUMBER",
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: DefaultButton(
                                buttonName: languagesController.tr(
                                  "APPLY_FILTER",
                                ),
                                mycolor: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: screenHeight * 0.065,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.red,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    languagesController.tr("REMOVE_FILTER"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenHeight * 0.016,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: Obx(() {
                            // Ensure expandedIndices matches the length of finalList
                            if (expandedIndices.length !=
                                customhistoryController.finalList.length) {
                              expandedIndices.assignAll(
                                List.generate(
                                  customhistoryController.finalList.length,
                                  (index) => false,
                                ),
                              );
                            }

                            return customhistoryController.isLoading.value ==
                                        false &&
                                    customhistoryController.finalList.isNotEmpty
                                ? RefreshIndicator(
                                    onRefresh: refresh,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: customhistoryController
                                          .finalList
                                          .length,
                                      itemBuilder: (context, index) {
                                        final data = customhistoryController
                                            .finalList[index];

                                        return Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              ExpansionTile(
                                                key: Key(
                                                  index.toString(),
                                                ), // Ensure state retention
                                                initiallyExpanded:
                                                    expandedIndices[index],
                                                onExpansionChanged:
                                                    (isExpanded) {
                                                      expandedIndices[index] =
                                                          isExpanded;
                                                    },
                                                tilePadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5,
                                                    ),
                                                title: Row(
                                                  children: [
                                                    Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            data
                                                                .bundle!
                                                                .service!
                                                                .company!
                                                                .companyLogo
                                                                .toString(),
                                                          ),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data
                                                              .bundle!
                                                              .bundleTitle
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          data.rechargebleAccount
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                trailing: expandedIndices[index]
                                                    ? null
                                                    : GestureDetector(
                                                        onTap: () {
                                                          expandedIndices[index] =
                                                              true;
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            SizedBox(width: 5),
                                                            Icon(
                                                              FontAwesomeIcons
                                                                  .chevronDown,
                                                              size:
                                                                  screenHeight *
                                                                  0.022,
                                                              color: Color(
                                                                0xff1890FF,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              languagesController.tr(
                                                                "TRANSFER_STATUS",
                                                              ),
                                                            ),
                                                            Text(
                                                              data.status
                                                                          .toString() ==
                                                                      "0"
                                                                  ? languagesController.tr(
                                                                      "PENDING",
                                                                    )
                                                                  : data.status
                                                                            .toString() ==
                                                                        "1"
                                                                  ? languagesController.tr(
                                                                      "SUCCESS",
                                                                    )
                                                                  : languagesController.tr(
                                                                      "REJECTED",
                                                                    ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              languagesController
                                                                  .tr("AMOUNT"),
                                                            ),
                                                            Text(
                                                              "${data.bundle.amount} ${box.read("currency_code")}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              languagesController
                                                                  .tr("DATE"),
                                                            ),
                                                            Text(
                                                              DateFormat(
                                                                'yyyy-MM-dd',
                                                              ).format(
                                                                DateTime.parse(
                                                                  data.createdAt
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              languagesController
                                                                  .tr("TIME"),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              DateFormat(
                                                                'hh:mm a',
                                                              ).format(
                                                                DateTime.parse(
                                                                  data.createdAt
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : customhistoryController.finalList.isEmpty
                                ? SizedBox()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: customhistoryController
                                        .finalList
                                        .length,
                                    itemBuilder: (context, index) {
                                      final data = customhistoryController
                                          .finalList[index];

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            ExpansionTile(
                                              key: Key(
                                                index.toString(),
                                              ), // Ensure state retention
                                              initiallyExpanded:
                                                  expandedIndices[index],
                                              onExpansionChanged: (isExpanded) {
                                                expandedIndices[index] =
                                                    isExpanded;
                                              },
                                              tilePadding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              title: Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          data
                                                              .bundle!
                                                              .service!
                                                              .company!
                                                              .companyLogo
                                                              .toString(),
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data.bundle!.bundleTitle
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        data.rechargebleAccount
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: expandedIndices[index]
                                                  ? null
                                                  : GestureDetector(
                                                      onTap: () {
                                                        expandedIndices[index] =
                                                            true;
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SizedBox(width: 5),
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .chevronDown,
                                                            size:
                                                                screenHeight *
                                                                0.022,
                                                            color: Color(
                                                              0xff1890FF,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController.tr(
                                                              "TRANSFER_STATUS",
                                                            ),
                                                          ),
                                                          Text(
                                                            data.status
                                                                        .toString() ==
                                                                    "0"
                                                                ? languagesController
                                                                      .tr(
                                                                        "PENDING",
                                                                      )
                                                                : data.status
                                                                          .toString() ==
                                                                      "1"
                                                                ? languagesController
                                                                      .tr(
                                                                        "SUCCESS",
                                                                      )
                                                                : languagesController
                                                                      .tr(
                                                                        "REJECTED",
                                                                      ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("AMOUNT"),
                                                          ),
                                                          Text(
                                                            "${data.bundle.amount} ${box.read("currency_code")}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("DATE"),
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                              'yyyy-MM-dd',
                                                            ).format(
                                                              DateTime.parse(
                                                                data.createdAt
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            languagesController
                                                                .tr("TIME"),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                              'hh:mm a',
                                                            ).format(
                                                              DateTime.parse(
                                                                data.createdAt
                                                                    .toString(),
                                                              ),
                                                            ),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(height: 60, width: screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
