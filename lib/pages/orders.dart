import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:online_telecom/controllers/dashboard_controller.dart';
import 'package:online_telecom/controllers/order_list_controller.dart';
import 'package:online_telecom/global_controller/languages_controller.dart';
import 'package:online_telecom/helpers/localtime_helper.dart';
import 'package:online_telecom/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:online_telecom/widgets/bottomsheet.dart';
import 'package:online_telecom/widgets/drawer.dart';

import '../controllers/drawer_controller.dart';
import '../helpers/capture_image_helper.dart';
import '../helpers/share_image_helper.dart';

class Orders extends StatefulWidget {
  Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String defaultValue = "";

  String secondDropDown = "";

  final orderlistController = Get.find<OrderlistController>();

  TextEditingController searchController = TextEditingController();
  late LanguagesController languagesController;

  List orderStatus = [];

  String search = "";

  final box = GetStorage();

  final ScrollController scrollController = ScrollController();

  Future<void> refresh() async {
    final int totalPages =
        orderlistController.allorderlist.value.payload?.pagination.totalPages ??
        0;
    final int currentPage = orderlistController.initialpage;

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
      orderlistController.initialpage++;

      // Prevent fetching if the next page exceeds total pages
      if (orderlistController.initialpage <= totalPages) {
        print("Load More...................");
        orderlistController.fetchOrderlistdata();
      } else {
        orderlistController.initialpage =
            totalPages; // Reset to the last valid page
        print("Already on the last page");
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.find<DashboardController>();

  MyDrawerController drawerController = Get.put(MyDrawerController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    languagesController = Get.put(LanguagesController());

    orderStatus = [
      {"title": languagesController.tr("PENDING"), "value": "order_status=0"},
      {"title": languagesController.tr("CONFIRMED"), "value": "order_status=1"},
      {"title": languagesController.tr("REJECTED"), "value": "order_status=2"},
    ];
    box.write("orderstatus", "");
    orderlistController.finalList.clear();
    orderlistController.initialpage = 1;
    orderlistController.fetchOrderlistdata();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // drawer: DrawerWidget(),
      // onDrawerChanged: (isOpen) {
      //   drawerController.isOpen.value = isOpen;
      //   print("Drawer is open: ${drawerController.isOpen.value}");
      // },
      key: _scaffoldKey,
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
                      }),
                      Spacer(),
                      Obx(
                        () => Text(
                          languagesController.tr("ORDERS"),
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
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(color: Color(0xffF1F3FF)),
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 10),
              Container(
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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
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
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Icon(
                                FontAwesomeIcons.chevronDown,
                                color: Colors.grey,
                              ),
                              isDense: true,
                              value: defaultValue,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  value: "",
                                  child: Text(
                                    languagesController.tr("ALL"),
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.040,
                                    ),
                                  ),
                                ),
                                ...orderStatus.map<DropdownMenuItem<String>>((
                                  data,
                                ) {
                                  return DropdownMenuItem(
                                    value: data['value'],
                                    child: Text(data['title']),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {
                                box.write("orderstatus", value);
                                orderlistController.finalList.clear();
                                orderlistController.initialpage = 1;
                                orderlistController.fetchOrderlistdata();
                                print("selected Value $value");
                                setState(() {
                                  defaultValue = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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
                              Obx(
                                () => Text(
                                  languagesController.tr("DATE"),
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.040,
                                  ),
                                ),
                              ),
                              Icon(Icons.calendar_month, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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
                              SizedBox(width: 10),
                              Expanded(
                                child: Obx(
                                  () => TextField(
                                    decoration: InputDecoration(
                                      hintText: languagesController.tr(
                                        "SEARCH_BY_PHOENUMBER",
                                      ),
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 450,
                // color: Colors.white,
                child: Column(
                  children: [
                    Obx(
                      () => orderlistController.isLoading.value == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            )
                          : SizedBox(),
                    ),
                    Obx(
                      () => orderlistController.isLoading.value == false
                          ? Container(
                              child:
                                  orderlistController
                                      .allorderlist
                                      .value
                                      .data!
                                      .orders
                                      .isNotEmpty
                                  ? SizedBox()
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/icons/empty.png",
                                            height: 80,
                                          ),
                                          Text("No Data found"),
                                        ],
                                      ),
                                    ),
                            )
                          : SizedBox(),
                    ),
                    Expanded(
                      child: Obx(
                        () =>
                            orderlistController.isLoading.value == false &&
                                orderlistController.finalList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 10);
                                  },
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      orderlistController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        orderlistController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(17),
                                              ),
                                              insetPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                  ),
                                              contentPadding: EdgeInsets.all(0),
                                              content: DetailsDialog(
                                                status: data.status.toString(),
                                                bundletitle: data
                                                    .bundle
                                                    .bundleTitle
                                                    .toString(),
                                                phoneNumber: data
                                                    .rechargebleAccount
                                                    .toString(),
                                                sellingPrice: data
                                                    .bundle
                                                    .sellingPrice
                                                    .toString(),
                                                buyingPrice: data
                                                    .bundle
                                                    .buyingPrice
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
                                                reason: data.rejectReason
                                                    .toString(),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 135,
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: data.status.toString() == "0"
                                                ? Color(0xffFFC107)
                                                : data.status.toString() == "1"
                                                ? Colors.green
                                                : Color(0xffFF4842),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      data.status.toString() ==
                                                          "0"
                                                      ? Color(
                                                          0xffFFC107,
                                                        ).withOpacity(0.12)
                                                      : data.status
                                                                .toString() ==
                                                            "1"
                                                      ? Colors.green
                                                            .withOpacity(0.12)
                                                      : Color(
                                                          0xffFF4842,
                                                        ).withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${languagesController.tr("ORDER_ID")} (# ${data.id})",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xff637381,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              screenHeight *
                                                              0.020,
                                                        ),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                          'dd MMM yyyy',
                                                        ).format(
                                                          DateTime.parse(
                                                            data.createdAt
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xff637381,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              screenHeight *
                                                              0.020,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Obx(
                                                            () => Text(
                                                              languagesController.tr(
                                                                "RECHARGEABLE_ACCOUNT",
                                                              ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            data.rechargebleAccount
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Obx(
                                                        () => Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              languagesController.tr(
                                                                "TRANSACTION_STATUS",
                                                              ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                            0.12,
                                                                          )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? Colors
                                                                          .green
                                                                          .withOpacity(
                                                                            0.12,
                                                                          )
                                                                    : Colors.red
                                                                          .withOpacity(
                                                                            0.12,
                                                                          ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          6,
                                                                    ),
                                                                child: Text(
                                                                  data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? languagesController.tr(
                                                                          "PENDING",
                                                                        )
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? languagesController.tr(
                                                                          "CONFIRMED",
                                                                        )
                                                                      : languagesController.tr(
                                                                          "REJECTED",
                                                                        ),
                                                                  style: TextStyle(
                                                                    color:
                                                                        data.status
                                                                                .toString() ==
                                                                            "0"
                                                                        ? Colors
                                                                              .grey
                                                                        : data.status.toString() ==
                                                                              "1"
                                                                        ? Colors
                                                                              .green
                                                                        : Colors
                                                                              .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        screenHeight *
                                                                        0.015,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                languagesController
                                                                    .tr("BUY"),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.018,
                                                                ),
                                                              ),
                                                              Text(" : "),
                                                              Text(
                                                                NumberFormat.currency(
                                                                  locale:
                                                                      'en_US',
                                                                  symbol: '',
                                                                  decimalDigits:
                                                                      2,
                                                                ).format(
                                                                  double.parse(
                                                                    data
                                                                        .bundle!
                                                                        .buyingPrice
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.018,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                box.read(
                                                                  "currency_code",
                                                                ),
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                languagesController
                                                                    .tr("SELL"),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.018,
                                                                ),
                                                              ),
                                                              Text(" : "),
                                                              Text(
                                                                NumberFormat.currency(
                                                                  locale:
                                                                      'en_US',
                                                                  symbol: '',
                                                                  decimalDigits:
                                                                      2,
                                                                ).format(
                                                                  double.parse(
                                                                    data
                                                                        .bundle!
                                                                        .sellingPrice
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.018,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                box.read(
                                                                  "currency_code",
                                                                ),
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : orderlistController.finalList.isEmpty
                            ? SizedBox()
                            : RefreshIndicator(
                                onRefresh: refresh,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 10);
                                  },
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      orderlistController.finalList.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        orderlistController.finalList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(17),
                                              ),
                                              contentPadding: EdgeInsets.all(0),
                                              content: DetailsDialog(
                                                status: data.status.toString(),
                                                bundletitle: data
                                                    .bundle
                                                    .bundleTitle
                                                    .toString(),
                                                phoneNumber: data
                                                    .rechargebleAccount
                                                    .toString(),
                                                sellingPrice: data
                                                    .bundle
                                                    .sellingPrice
                                                    .toString(),
                                                buyingPrice: data
                                                    .bundle
                                                    .buyingPrice
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
                                        height: 125,
                                        width: screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: data.status.toString() == "0"
                                                ? Color(0xffFFC107)
                                                : data.status.toString() == "1"
                                                ? Colors.green
                                                : Color(0xffFF4842),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      data.status.toString() ==
                                                          "0"
                                                      ? Color(
                                                          0xffFFC107,
                                                        ).withOpacity(0.12)
                                                      : data.status
                                                                .toString() ==
                                                            "1"
                                                      ? Colors.green
                                                            .withOpacity(0.12)
                                                      : Color(
                                                          0xffFF4842,
                                                        ).withOpacity(0.4),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${languagesController.tr("ORDER_ID")} (# ${data.id})",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xff637381,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              screenHeight *
                                                              0.020,
                                                        ),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                          'dd MMM yyyy',
                                                        ).format(
                                                          DateTime.parse(
                                                            data.createdAt
                                                                .toString(),
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xff637381,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              screenHeight *
                                                              0.020,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Obx(
                                                            () => Text(
                                                              languagesController.tr(
                                                                "RECHARGEABLE_ACCOUNT",
                                                              ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            data.rechargebleAccount
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  screenHeight *
                                                                  0.018,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Obx(
                                                        () => Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              languagesController.tr(
                                                                "TRANSACTION_STATUS",
                                                              ),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize:
                                                                    screenHeight *
                                                                    0.018,
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    data.status
                                                                            .toString() ==
                                                                        "0"
                                                                    ? Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                            0.12,
                                                                          )
                                                                    : data.status
                                                                              .toString() ==
                                                                          "1"
                                                                    ? Colors
                                                                          .green
                                                                          .withOpacity(
                                                                            0.12,
                                                                          )
                                                                    : Colors.red
                                                                          .withOpacity(
                                                                            0.12,
                                                                          ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          6,
                                                                    ),
                                                                child: Text(
                                                                  data.status
                                                                              .toString() ==
                                                                          "0"
                                                                      ? languagesController.tr(
                                                                          "PENDING",
                                                                        )
                                                                      : data.status.toString() ==
                                                                            "1"
                                                                      ? languagesController.tr(
                                                                          "CONFIRMED",
                                                                        )
                                                                      : languagesController.tr(
                                                                          "REJECTED",
                                                                        ),
                                                                  style: TextStyle(
                                                                    color:
                                                                        data.status
                                                                                .toString() ==
                                                                            "0"
                                                                        ? Colors
                                                                              .grey
                                                                        : data.status.toString() ==
                                                                              "1"
                                                                        ? Colors
                                                                              .green
                                                                        : Colors
                                                                              .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        screenHeight *
                                                                        0.015,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                languagesController
                                                                    .tr("BUY"),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.018,
                                                                ),
                                                              ),
                                                              Text(" : "),
                                                              Text(
                                                                NumberFormat.currency(
                                                                  locale:
                                                                      'en_US',
                                                                  symbol: '',
                                                                  decimalDigits:
                                                                      2,
                                                                ).format(
                                                                  double.parse(
                                                                    data
                                                                        .bundle!
                                                                        .buyingPrice
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.018,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                box.read(
                                                                  "currency_code",
                                                                ),
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                languagesController
                                                                    .tr("SELL"),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.018,
                                                                ),
                                                              ),
                                                              Text(" : "),
                                                              Text(
                                                                NumberFormat.currency(
                                                                  locale:
                                                                      'en_US',
                                                                  symbol: '',
                                                                  decimalDigits:
                                                                      2,
                                                                ).format(
                                                                  double.parse(
                                                                    data
                                                                        .bundle!
                                                                        .sellingPrice
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize:
                                                                      screenHeight *
                                                                      0.018,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                box.read(
                                                                  "currency_code",
                                                                ),
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailsDialog extends StatefulWidget {
  DetailsDialog({
    super.key,
    this.status,
    this.bundletitle,
    this.phoneNumber,
    this.sellingPrice,
    this.buyingPrice,
    this.orderId,
    this.imagelink,
    this.date,
    this.contactname,
    this.reason,
  });

  String? status;
  String? bundletitle;
  String? phoneNumber;
  String? sellingPrice;
  String? buyingPrice;
  String? orderId;
  String? imagelink;
  String? date;
  String? contactname;
  String? reason;

  @override
  State<DetailsDialog> createState() => _DetailsDialogState();
}

class _DetailsDialogState extends State<DetailsDialog> {
  LanguagesController languagesController = Get.put(LanguagesController());

  final box = GetStorage();

  bool showSelling = false;

  bool showBuying = false;

  final GlobalKey catpureKey = GlobalKey();
  final GlobalKey shareKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: (showSelling || showBuying) ? 650 : 585,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: SizedBox(
          child: Column(
            children: [
              RepaintBoundary(
                key: catpureKey,
                child: RepaintBoundary(
                  key: shareKey,
                  child: Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: widget.status.toString() == "0"
                            ? Color(0xffFFC107)
                            : widget.status.toString() == "1"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage("assets/icons/logo.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              // color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.contactname.toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.primaryColor,
                                      fontFamily: "Iranfontbold",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              widget.status.toString() == "0"
                                  ? "assets/icons/pending.png"
                                  : widget.status.toString() == "1"
                                  ? "assets/icons/successful.png"
                                  : "assets/icons/rejected.png",
                            ),
                          ),
                          Text(
                            widget.status.toString() == "0"
                                ? languagesController.tr("PENDING")
                                : widget.status.toString() == "1"
                                ? languagesController.tr("CONFIRMED")
                                : languagesController.tr("REJECTED"),
                            style: TextStyle(
                              color: widget.status.toString() == "0"
                                  ? Color(0xffFFC107)
                                  : widget.status.toString() == "1"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Visibility(
                            visible: widget.reason.toString() != "null",
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Center(
                                  child: Text(widget.reason.toString()),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("BUNDLE_TITLE"),
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                widget.bundletitle.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("PHONENUMBER"),
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                widget.phoneNumber.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: showSelling,
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    languagesController.tr("SELLING_PRICE"),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Spacer(),
                                  Text(
                                    widget.sellingPrice.toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    box.read("currency_code"),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: showBuying,
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    languagesController.tr("BUYING_PRICE"),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Spacer(),
                                  Text(
                                    widget.buyingPrice.toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    box.read("currency_code"),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                languagesController.tr("ORDER_ID"),
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                widget.orderId.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 65,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: widget.status.toString() == "1"
                                  ? AppColors.secondaryColor
                                  : Colors.red.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Image.network(widget.imagelink.toString()),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController.tr("DATE"),
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              convertToDate(
                                                widget.date.toString(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languagesController.tr("TIME"),
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              convertToLocalTime(
                                                widget.date.toString(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 45,
                width: screenWidth,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          capturePng(catpureKey);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: AppColors.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("SAVE_TO_GALLERY"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          captureImageFromWidgetAsFile(shareKey);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              languagesController.tr("SHARE"),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 45,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.shade600),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      languagesController.tr("CLOSE"),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text("Buying Price"),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showBuying = !showBuying;
                      });
                    },
                    child: Icon(
                      showBuying ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  Spacer(),
                  Text("Selling Price"),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showSelling = !showSelling;
                      });
                    },
                    child: Icon(
                      showSelling ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
