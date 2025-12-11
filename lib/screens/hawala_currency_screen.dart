import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/font_controller.dart';
import '../controllers/hawala_currency_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../pages/transaction_type.dart';
import '../widgets/bottomsheet.dart';

class HawalaCurrencyScreen extends StatefulWidget {
  const HawalaCurrencyScreen({super.key});

  @override
  State<HawalaCurrencyScreen> createState() => _HawalaCurrencyScreenState();
}

class _HawalaCurrencyScreenState extends State<HawalaCurrencyScreen> {
  final box = GetStorage();

  final hawalacurrencycontroller = Get.find<HawalaCurrencyController>();
  LanguagesController languagesController = Get.put(LanguagesController());

  final Mypagecontroller mypagecontroller = Get.find();
  @override
  void initState() {
    super.initState();
    hawalacurrencycontroller.fetchcurrency();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                          languagesController.tr("HAWALA_RATES"),
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
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(
                  () => hawalacurrencycontroller.isLoading.value == false
                      ? ListView.builder(
                          itemCount: hawalacurrencycontroller
                              .allcurrencylist.value.data!.rates!.length,
                          itemBuilder: (context, index) {
                            final data = hawalacurrencycontroller
                                .allcurrencylist.value.data!.rates![index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 5),
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Obx(
                                    () => Text(
                                      data.amount.toString() +
                                          " " +
                                          data.fromCurrency!.name.toString() +
                                          " To " +
                                          data.toCurrency!.name.toString() +
                                          " " +
                                          languagesController.tr("BUYING") +
                                          " " +
                                          data.buyRate.toString() +
                                          " " +
                                          data.toCurrency!.symbol.toString() +
                                          " " +
                                          languagesController.tr("SELLING") +
                                          " " +
                                          data.sellRate.toString() +
                                          " " +
                                          data.toCurrency!.symbol.toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenHeight * 0.020,
                                        fontFamily:
                                            box.read("language").toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                    .currentFont
                                                : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(),
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
