import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:online_telecom/controllers/dashboard_controller.dart';
import 'package:online_telecom/global_controller/languages_controller.dart';
import 'package:online_telecom/global_controller/page_controller.dart'; // <- Mypagecontroller (stack-based)
import 'package:online_telecom/pages/homepages.dart';
import 'package:online_telecom/pages/network.dart';
import 'package:online_telecom/pages/orders.dart';
import 'package:online_telecom/pages/transactions.dart';
import 'package:online_telecom/utils/colors.dart';
import 'package:online_telecom/widgets/drawer.dart';

import '../controllers/drawer_controller.dart';
import '../pages/transaction_type.dart';

class NewBaseScreen extends StatefulWidget {
  const NewBaseScreen({super.key});

  @override
  State<NewBaseScreen> createState() => _NewBaseScreenState();
}

class _NewBaseScreenState extends State<NewBaseScreen> {
  final dashboardController = Get.find<DashboardController>();
  final Mypagecontroller mypagecontroller = Get.put(Mypagecontroller());
  final LanguagesController languagesController =
      Get.put(LanguagesController());
  final MyDrawerController drawerController = Get.put(MyDrawerController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    dashboardController.fetchDashboardData();
    // প্রথম লোডেই হোম সেট করা আছে controller-এ (pageStack = [Homepages()])
  }

  Future<bool> _showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(languagesController.tr("EXIT_APP")),
            content: Text(languagesController.tr("DO_YOU_WANT_TO_EXIT_APP")),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(languagesController.tr("NO")),
              ),
              ElevatedButton(
                onPressed: () => exit(0),
                child: Text(languagesController.tr("YES")),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _onWillPop() async {
    // আগে subpage থাকলে pop, না থাকলে exit dialog
    final allowExit = mypagecontroller.goBack();
    if (!allowExit) return false;
    return _showExitPopup();
  }

  void _onTapNav(int index) {
    HapticFeedback.lightImpact();
    if (index == 0) {
      mypagecontroller.goToMainPageByIndex(0); // Homepages()
    } else if (index == 1) {
      mypagecontroller.goToMainPageByIndex(1); // TransactionsType()
    } else if (index == 2) {
      mypagecontroller.goToMainPageByIndex(2); // Orders()
    } else if (index == 3) {
      mypagecontroller.goToMainPageByIndex(3); // Network()
    }
  }

  String _labelFor(int index) {
    switch (index) {
      case 0:
        return languagesController.tr("HOME");
      case 1:
        return languagesController.tr("TRANSACTIONS");
      case 2:
        return languagesController.tr("ORDERS");
      case 3:
        return languagesController.tr("NETWORK");
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xffF1F3FF),

        // BODY: stack-based controller
        body: Obx(() => mypagecontroller.pageStack.last),

        // BOTTOM NAV: ডিজাইন অপরিবর্তিত, কিন্তু state আসে controller থেকে
        bottomNavigationBar: SafeArea(
          child: Obx(() {
            // drawer খোলা থাকলে bottom nav লুকাবে
            if (drawerController.isOpen.value) return const SizedBox.shrink();

            // Obx rebuild ট্রিগার করতে pageStack-কে স্পর্শ করছি (lastSelectedIndex Rx না হলেও চলবে)
            final _ = mypagecontroller.pageStack.length;

            return Container(
              margin: EdgeInsets.only(
                left: displayWidth * .05,
                right: displayWidth * .05,
                bottom: 10,
              ),
              height: displayWidth * .155,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
                itemBuilder: (context, index) {
                  final bool isActive =
                      index == mypagecontroller.lastSelectedIndex;

                  return InkWell(
                    onTap: () => _onTapNav(index),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(
                      children: [
                        // bubble background
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: isActive
                              ? displayWidth * .32
                              : displayWidth * .18,
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            height: isActive ? displayWidth * .12 : 0,
                            width: isActive ? displayWidth * .32 : 0,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),

                        // icons + labels (icon left, active label to the right)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: isActive
                              ? displayWidth * .31
                              : displayWidth * .18,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ICON always left
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    imagedata[index],
                                    height: 18,
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.primaryColor,
                                  ),
                                  // Non-active: label below icon
                                  if (!isActive) ...[
                                    const SizedBox(height: 3),
                                    Text(
                                      _labelFor(index),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ],
                              ),

                              // Active: label to the right inside bubble
                              if (isActive) ...[
                                const SizedBox(width: 6),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      _labelFor(index),
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: displayWidth * .03),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  final List<String> imagedata = const [
    "assets/icons/homeicon.png",
    "assets/icons/transactionsicon.png",
    "assets/icons/ordericon.png",
    "assets/icons/sub_reseller.png",
  ];
}
