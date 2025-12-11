import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/categories_controller.dart';

import '../controllers/font_controller.dart';
import '../controllers/only_service_controller.dart';
import '../controllers/selling_price_controller.dart';

import '../controllers/transferlist_controller.dart';

import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';

import '../pages/transaction_type.dart';

import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import '../widgets/custom_text.dart';
import 'create_transfer_screen.dart';

class CommissionTransferScreen extends StatefulWidget {
  CommissionTransferScreen({super.key});

  @override
  State<CommissionTransferScreen> createState() =>
      _CommissionTransferScreenState();
}

class _CommissionTransferScreenState extends State<CommissionTransferScreen> {
  LanguagesController languagesController = Get.put(LanguagesController());

  TransferlistController transferlistController =
      Get.put(TransferlistController());

  final SellingPriceController sellingPriceController =
      Get.put(SellingPriceController());

  final box = GetStorage();

  final Mypagecontroller mypagecontroller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transferlistController.fetchdata();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff011A52), // Status bar background color
      statusBarIconBrightness: Brightness.light, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ));
    sellingPriceController.fetchpriceData();
    serviceController.fetchservices();
  }

  final categorisListController = Get.find<CategorisListController>();

  final OnlyServiceController serviceController =
      Get.put(OnlyServiceController());
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF1F3FF),
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
                            TransactionsType(),
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
                            child: Icon(
                              FontAwesomeIcons.chevronLeft,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Text(
                          languagesController.tr("COMMISSION_TRANSFER_LIST"),
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
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 50,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: languagesController.tr("SEARCH"),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.020,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
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
                      flex: 4,
                      child: DefaultButton(
                        buttonName: languagesController.tr("CREATE_NEW"),
                        mycolor: Colors.green,
                        onpressed: () {
                          mypagecontroller.changePage(
                            CreateTransferScreen(),
                            isMainPage: false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: screenWidth,
                  // color: Colors.cyan,
                  child:
                      Obx(() => transferlistController.isLoading.value == false
                          ? ListView.builder(
                              padding: EdgeInsets.all(0.0),
                              itemCount: transferlistController
                                  .alltransferlist.value.data!.requests!.length,
                              itemBuilder: (context, index) {
                                final data = transferlistController
                                    .alltransferlist
                                    .value
                                    .data!
                                    .requests![index];
                                return Card(
                                  child: Container(
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 7),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              KText(
                                                  text: languagesController
                                                      .tr("AMOUNT")),
                                              KText(
                                                text: data.amount.toString(),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              KText(
                                                  text: languagesController
                                                      .tr("STATUS")),
                                              KText(
                                                text: data.status.toString(),
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible:
                                                data.adminNotes.toString() !=
                                                    "null",
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                KText(
                                                  text: languagesController
                                                      .tr("NOTES"),
                                                ),
                                                KText(
                                                  text: data.adminNotes
                                                      .toString(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
