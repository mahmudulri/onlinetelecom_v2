import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_telecom/pages/homepages.dart';
import '../controllers/add_commsion_group_controller.dart';
import '../controllers/commission_group_controller.dart';
import '../controllers/font_controller.dart';
import '../global_controller/languages_controller.dart';
import '../global_controller/page_controller.dart';
import '../utils/colors.dart';
import '../widgets/authtextfield.dart';
import '../widgets/bottomsheet.dart';

class CommissionGroupScreen extends StatefulWidget {
  CommissionGroupScreen({super.key});

  @override
  State<CommissionGroupScreen> createState() => _CommissionGroupScreenState();
}

class _CommissionGroupScreenState extends State<CommissionGroupScreen> {
  final box = GetStorage();

  LanguagesController languagesController = Get.put(LanguagesController());

  final commissionlistController = Get.find<CommissionGroupController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commissionlistController.fetchGrouplist();
  }

  final Mypagecontroller mypagecontroller = Get.find();
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
                          languagesController.tr("COMMISSION_GROUP"),
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
              Container(
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
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                content: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: CreateGroupBox()),
                              );
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("CREATE_NEW"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(
                  () => commissionlistController.isLoading.value == false
                      ? ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 5,
                            );
                          },
                          itemCount: commissionlistController
                              .allgrouplist.value.data!.groups!.length,
                          itemBuilder: (context, index) {
                            final data = commissionlistController
                                .allgrouplist.value.data!.groups![index];
                            return Container(
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("GROUP_NAME"),
                                          style: TextStyle(
                                            fontFamily: box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                    .currentFont
                                                : null,
                                          ),
                                        ),
                                        Text(
                                          data.groupName.toString(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController.tr("AMOUNT"),
                                          style: TextStyle(
                                            fontFamily: box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                    .currentFont
                                                : null,
                                          ),
                                        ),
                                        Text(
                                          data.amount.toString(),
                                          style: TextStyle(
                                            fontFamily: box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                    .currentFont
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          languagesController
                                              .tr("COMMISSION_TYPE"),
                                          style: TextStyle(
                                            fontFamily: box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                    .currentFont
                                                : null,
                                          ),
                                        ),
                                        Text(
                                          data.commissionType.toString() ==
                                                  "percentage"
                                              ? languagesController
                                                  .tr("PERCENTAGE")
                                              : "",
                                          style: TextStyle(
                                            fontFamily: box
                                                        .read("language")
                                                        .toString() ==
                                                    "Fa"
                                                ? Get.find<FontController>()
                                                    .currentFont
                                                : null,
                                          ),
                                        ),
                                      ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateGroupBox extends StatefulWidget {
  CreateGroupBox({super.key});

  @override
  State<CreateGroupBox> createState() => _CreateGroupBoxState();
}

class _CreateGroupBoxState extends State<CreateGroupBox> {
  final box = GetStorage();

  final AddCommsionGroupController addCommsionGroupController =
      Get.put(AddCommsionGroupController());

  List commissiontype = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    commissiontype = [
      {
        "name": languagesController.tr("PERCENTAGE"),
        "value": "percentage",
      },
    ];
  }

  LanguagesController languagesController = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 400,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Transform.rotate(
                  angle: 0.785398,
                  child: Container(
                    height: 7,
                    width: 7,
                    color: Colors.grey.shade300,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  languagesController.tr("COMMISSION_GROUP"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * 0.022,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
                Transform.rotate(
                  angle: 0.785398, // 45 degrees in radians (π/4 or 0.785398)
                  child: Container(
                    height: 7,
                    width: 7,
                    color: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(
                  languagesController.tr("GROUP_NAME"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Authtextfield(
              hinttext: languagesController.tr("ENTER_GROUP_NAME"),
              controller: addCommsionGroupController.nameController,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  languagesController.tr("COMMISSION_TYPE"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Obx(() {
              final List<Map<String, dynamic>> types =
                  (commissiontype as List).cast<Map<String, dynamic>>();

              return Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  alignment: box.read("language").toString() != "Fa"
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  value: addCommsionGroupController.commissiontype.value.isEmpty
                      ? null
                      : addCommsionGroupController.commissiontype.value,
                  items: types.map<DropdownMenuItem<String>>((t) {
                    final String v = (t["value"] ?? "").toString();
                    final String n = (t["name"] ?? "").toString();
                    return DropdownMenuItem<String>(
                      value: v,
                      child: Text(n),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    addCommsionGroupController.commissiontype.value = value;

                    String pickedName = '';
                    for (final t in types) {
                      if ((t["value"] ?? "").toString() == value) {
                        pickedName = (t["name"] ?? "").toString();
                        break;
                      }
                    }
                    addCommsionGroupController.commitype.value = pickedName;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  icon: Icon(
                    FontAwesomeIcons.chevronDown,
                    size: screenHeight * 0.018,
                    color: Colors.grey,
                  ),
                  hint: Text(
                    addCommsionGroupController.commitype.value.isEmpty
                        ? ''
                        : addCommsionGroupController.commitype.value,
                    style: TextStyle(
                      fontSize: screenHeight * 0.020,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  languagesController.tr("AMOUNT"),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: screenHeight * 0.020,
                    fontFamily: box.read("language").toString() == "Fa"
                        ? Get.find<FontController>().currentFont
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Authtextfield(
              hinttext: languagesController.tr("ENTER_AMOUNT_OR_VALUE"),
              controller: addCommsionGroupController.amountController,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        addCommsionGroupController.amountController.clear();
                        addCommsionGroupController.nameController.clear();
                        addCommsionGroupController.commissiontype.value = "";
                        addCommsionGroupController.commitype.value = "";
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            languagesController.tr("CANCEL"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
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
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        if (addCommsionGroupController
                                .nameController.text.isNotEmpty &&
                            addCommsionGroupController
                                .amountController.text.isNotEmpty &&
                            addCommsionGroupController.commissiontype.value !=
                                "") {
                          addCommsionGroupController.createnow();
                          print(" filled");
                        } else {
                          print("No data filled");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                            child: Obx(
                          () => Text(
                            addCommsionGroupController.isLoading.value == false
                                ? languagesController.tr("CREATE_NOW")
                                : languagesController.tr("PLEASE_WAIT"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
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
  }
}
