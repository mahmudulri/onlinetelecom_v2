import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/add_payment_controller.dart';

import '../controllers/conversation_controller.dart';
import '../controllers/currency_controller.dart';
import '../controllers/font_controller.dart';
import '../controllers/payment_method_controller.dart';
import '../controllers/payment_type_controller.dart';
import '../controllers/sign_in_controller.dart';

import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../models/currency_model.dart';
import '../models/payment_type_model.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/button_one.dart';
import '../widgets/custom_text.dart';

import 'receipts_screen.dart';

class CreatePaymentsScreen extends StatefulWidget {
  CreatePaymentsScreen({super.key});

  @override
  State<CreatePaymentsScreen> createState() => _CreatePaymentsScreenState();
}

class _CreatePaymentsScreenState extends State<CreatePaymentsScreen> {
  final Mypagecontroller mypagecontroller = Get.find();

  SignInController signInController = Get.put(SignInController());

  CurrencyController currencyController = Get.put(CurrencyController());
  PaymentMethodController paymentMethodController =
      Get.put(PaymentMethodController());
  PaymentTypeController paymentTypeController =
      Get.put(PaymentTypeController());

  final box = GetStorage();

  List commissionpaidby = [];

  RxString person = "".obs;
  final pageController = Get.find<Mypagecontroller>();
  LanguagesController languagesController = Get.put(LanguagesController());

  AddPaymentController addPaymentController = Get.put(AddPaymentController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentMethodController.fetchmethods();
    currencyController.fetchCurrency();
    paymentTypeController.fetchtypes();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff011A52), // Status bar background color
      statusBarIconBrightness: Brightness.light, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ));

    commissionpaidby = [
      languagesController.tr("SENDER"),
      languagesController.tr("RECEIVER"),
    ];
  }

  var selectedMethod = "".obs;
  var selectedType = "".obs;
  var selectedcurrency = "".obs;

  @override
  Widget build(BuildContext context) {
    final pageController = Get.find<Mypagecontroller>();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                            ReceiptsScreen(),
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
                          languagesController.tr("ADD_NEW_RECEIPT"),
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
        decoration: BoxDecoration(
          color: Color(0xffF1F3FF),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              KText(
                text: languagesController.tr("PAYMENT_METHOD"),
                color: Colors.grey.shade600,
                fontSize: screenHeight * 0.020,
              ),
              SizedBox(
                height: 5,
              ),
              Obx(() {
                final methods = paymentMethodController
                        .allmethods.value.data?.paymentMethods ??
                    [];

                return Container(
                  height: 50,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButtonFormField<String>(
                    alignment: box.read("language").toString() != "Fa"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    value: addPaymentController.payment_method_id.value.isEmpty
                        ? null
                        : addPaymentController.payment_method_id.value,
                    items: methods.map((m) {
                      return DropdownMenuItem<String>(
                        value: m.id.toString(),
                        child: Text(m.methodName?.toString() ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      addPaymentController.payment_method_id.value = value;

                      final selected = methods.firstWhere(
                        (m) => m.id.toString() == value,
                        orElse: () => methods.first,
                      );
                      selectedMethod.value =
                          selected.methodName?.toString() ?? '';
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.grey,
                      size: 20, // Increased icon size
                    ),
                    hint: KText(
                      text: selectedMethod.value.isEmpty
                          ? ''
                          : selectedMethod.value,
                      fontSize: screenHeight * 0.020,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: languagesController.tr("AMOUNT"),
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                  KText(
                    text: languagesController.tr("CURRENCY"),
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: screenHeight * 0.065,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          color: Color(0xffF9FAFB),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: TextField(
                            controller: addPaymentController.amountController,
                            style: TextStyle(
                              height: 1.1,
                              fontFamily:
                                  box.read("language").toString() == "Fa"
                                      ? Get.find<FontController>().currentFont
                                      : null,
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: screenHeight * 0.018,
                                fontFamily:
                                    box.read("language").toString() == "Fa"
                                        ? Get.find<FontController>().currentFont
                                        : null,
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Obx(() {
                        // 1) Strongly type the list to Currency
                        final List<Currency> currencies = (currencyController
                                    .allcurrency.value.data?.currencies ??
                                <dynamic>[])
                            .cast<Currency>();

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          alignment: box.read("language").toString() == "Fa"
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Text(
                            box.read("currency_code"),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              KText(
                text: languagesController.tr("PAYMENT_DATE"),
                color: Colors.grey.shade600,
                fontSize: screenHeight * 0.020,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => KText(
                            text: addPaymentController.selectedDate.value,
                            fontSize: screenHeight * 0.020,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            addPaymentController.selectedDate.value =
                                formattedDate;
                          }
                        },
                        child: Icon(
                          Icons.calendar_month,
                          size: 22,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              KText(
                text: languagesController.tr("TRACKING_CODE"),
                color: Colors.grey.shade600,
                fontSize: screenHeight * 0.020,
              ),
              SizedBox(
                height: 5,
              ),
              Authtextfield(
                hinttext: "",
                controller: addPaymentController.trackingCodeController,
              ),
              SizedBox(
                height: 10,
              ),
              KText(
                text: languagesController.tr("NOTES"),
                color: Colors.grey.shade600,
                fontSize: screenHeight * 0.020,
              ),
              SizedBox(
                height: 5,
              ),
              Authtextfield(
                hinttext: "",
                controller: addPaymentController.noteController,
              ),
              SizedBox(
                height: 10,
              ),
              KText(
                text: languagesController.tr("PAYMENT_TYPE"),
                color: Colors.grey.shade600,
                fontSize: screenHeight * 0.020,
              ),
              SizedBox(
                height: 5,
              ),
              Obx(() {
                final List<PaymentType> types =
                    (paymentTypeController.alltypes.value.data?.paymentTypes ??
                            <dynamic>[])
                        .cast<PaymentType>();

                return Container(
                  height: 50,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    alignment: box.read("language").toString() != "Fa"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    value: addPaymentController.payment_type_id.value.isEmpty
                        ? null
                        : addPaymentController.payment_type_id.value,
                    items: types.map((t) {
                      final String idStr = (t.id ?? '').toString();
                      final String name = t.name?.toString() ?? '';
                      return DropdownMenuItem<String>(
                        value: idStr,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      addPaymentController.payment_type_id.value = value;

                      String pickedName = '';
                      for (final t in types) {
                        final String idStr = (t.id ?? '').toString();
                        if (idStr == value) {
                          pickedName = t.name?.toString() ?? '';
                          break;
                        }
                      }
                      selectedType.value = pickedName;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.grey,
                      size: 20, // larger icon to match others
                    ),
                    hint: KText(
                      text:
                          selectedType.value.isEmpty ? '' : selectedType.value,
                      fontSize: screenHeight * 0.020,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 10,
              ),
              KText(
                text: languagesController.tr("UPLOAD_IMAGES"),
                color: Colors.grey.shade600,
                fontSize: screenHeight * 0.020,
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildImageUploaderBox(
                      context,
                      languagesController.tr("IMAGE_ONE"),
                      addPaymentController.paymentImagePath,
                      () => addPaymentController.pickImage("payment"),
                    ),
                    SizedBox(width: 10),
                    buildImageUploaderBox(
                      context,
                      languagesController.tr("IMAGE_TOW"),
                      addPaymentController.extraImage1Path,
                      () => addPaymentController.pickImage("extra1"),
                    ),
                    SizedBox(width: 10),
                    buildImageUploaderBox(
                      context,
                      languagesController.tr("IMAGE_THREE"),
                      addPaymentController.extraImage2Path,
                      () => addPaymentController.pickImage("extra2"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () => DefaultButton(
                  mycolor: Colors.green,
                  buttonName: addPaymentController.isLoading.value == false
                      ? languagesController.tr("ADD_NOW")
                      : languagesController.tr("PLEASE_WAIT"),
                  onpressed: () {
                    if (addPaymentController.payment_method_id.value == '' ||
                        addPaymentController.amountController.text.isEmpty ||
                        addPaymentController.currencyID.value == '' ||
                        addPaymentController.selectedDate.value ==
                            '' || // <-- FIXED
                        addPaymentController
                            .trackingCodeController.text.isEmpty ||
                        addPaymentController.noteController.text.isEmpty) {
                      Fluttertoast.showToast(
                        msg: languagesController.tr("FILL_DATA_CORRECTLY"),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      addPaymentController.addNow();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildImageUploaderBox(
  BuildContext context,
  String label,
  RxString imagePath,
  VoidCallback onPick,
) {
  return Obx(
    () => Stack(
      children: [
        GestureDetector(
          onTap: onPick,
          child: Container(
            width: 160,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: imagePath.value.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(imagePath.value),
                      width: 160,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KText(
                        text: label,
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ),
        ),
        if (imagePath.value.isNotEmpty)
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                imagePath.value = '';
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
