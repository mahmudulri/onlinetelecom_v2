import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_telecom/controllers/transaction_controller.dart';
import 'package:online_telecom/global_controller/languages_controller.dart';
import 'package:online_telecom/models/custom_history_model.dart';
import 'package:online_telecom/pages/orders.dart';
import 'package:online_telecom/utils/colors.dart';
import 'package:online_telecom/widgets/bottomsheet.dart';
import 'package:online_telecom/widgets/drawer.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/drawer_controller.dart';
import '../global_controller/page_controller.dart';
import '../screens/commission_transfer_screen.dart';
import '../screens/hawala_currency_screen.dart';
import '../screens/hawala_list_screen.dart';
import '../screens/loan_screen.dart';
import '../screens/receipts_screen.dart';
import '../widgets/payment_button.dart';
import 'transactions.dart';

class TransactionsType extends StatefulWidget {
  TransactionsType({super.key});

  @override
  State<TransactionsType> createState() => _TransactionsTypeState();
}

class _TransactionsTypeState extends State<TransactionsType> {
  final box = GetStorage();

  LanguagesController languagesController = Get.put(LanguagesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();

  final Mypagecontroller mypagecontroller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: [
                      Obx(
                        () {
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
                            height: 50,
                            width: 50,
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
                        },
                      ),
                      Spacer(),
                      Obx(
                        () => Text(
                          languagesController.tr("TRANSACTIONS_TYPE"),
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
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: screenWidth,
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.2),
              //       spreadRadius: 2,
              //       blurRadius: 2,
              //       offset: Offset(0, 0),
              //     ),
              //   ],
              //   borderRadius: BorderRadius.circular(8),
              // ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    PaymentButton(
                      buttonName:
                          languagesController.tr("PAYMENT_RECEIPT_REQUEST"),
                      imagelink: "assets/icons/wallet.png",
                      mycolor: Color(0xff04B75D),
                      onpressed: () {
                        mypagecontroller.changePage(ReceiptsScreen(),
                            isMainPage: false);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName: languagesController.tr("REQUES_LOAN_BALANCE"),
                      imagelink: "assets/icons/transactionsicon.png",
                      mycolor: Color(0xff3498db),
                      onpressed: () {
                        mypagecontroller.changePage(RequestLoanScreen(),
                            isMainPage: false);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName: languagesController.tr("HAWALA"),
                      imagelink: "assets/icons/exchange.png",
                      mycolor: Color(0xffFE8F2D),
                      onpressed: () {
                        mypagecontroller.changePage(HawalaListScreen(),
                            isMainPage: false);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName: languagesController.tr("HAWALA_RATES"),
                      imagelink: "assets/icons/exchange-rate.png",
                      mycolor: Color(0xff4B7AFC),
                      onpressed: () {
                        mypagecontroller.changePage(HawalaCurrencyScreen(),
                            isMainPage: false);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName:
                          languagesController.tr("BALANCE_TRANSACTIONS"),
                      imagelink: "assets/icons/transactionsicon.png",
                      mycolor: Color(0xffDE4B5E),
                      onpressed: () {
                        mypagecontroller.changePage(Transactions(),
                            isMainPage: false);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PaymentButton(
                      buttonName: languagesController
                          .tr("TRANSFER_COMISSION_TO_BALANCE"),
                      imagelink: "assets/icons/transactionsicon.png",
                      mycolor: Color(0xff9b59b6),
                      onpressed: () {
                        mypagecontroller.changePage(CommissionTransferScreen(),
                            isMainPage: false);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
