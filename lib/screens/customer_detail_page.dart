import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/screens/add_customer_page.dart';
import 'package:salesapp/screens/customer_transaction_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/customer_list_response_model.dart';
import '../../constant/color.dart';
import '../../network/api_end_point.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/no_internet.dart';
import '../constant/font.dart';
import '../model/customer_detail_response_model.dart';
import '../model/order_detail_response_model.dart';
import 'add_order_page.dart';
import 'add_payement_detail_page.dart';
import 'customer_sales_history_page.dart';

class CustomerDetailPage extends StatefulWidget {
  final CustomerList getSet;
  final bool isFromList;
  const CustomerDetailPage(this.getSet, this.isFromList, {Key? key}) : super(key: key);

  @override
  _CustomerDetailPageState createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends BaseState<CustomerDetailPage> with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _ = false;

  CustomerDetailResponseModel customerDetailResponseModel = CustomerDetailResponseModel();

  var listCustomerTransaction = List<CustomerTransection>.empty(growable: true);
  var listCustomerSalesHistory = List<SalesHistory>.empty(growable: true);

  late String? totalOverdue;
  late String? totalSale;

  late TabController _tabController;
  var listFilter = [];

  String dateStartSelectionChanged = "";
  String dateEndSelectionChanged = "";

  var strMonthToDate;
  var strMonthFromDate;

  var strYearToDate;
  var strYearFromDate;

  var strCustomToDate;
  var strCustomFromDate;

  @override
  void initState() {

    getMonthToDate();
    getYearDate();

    listFilter.add("Month to date " + "(" + strMonthFromDate + " - " + strMonthToDate +")");
    listFilter.add("Year to date "+ "(" + strYearFromDate + " - " + strYearToDate +")");
    listFilter.add("Custom Range");


    _tabController = TabController(length: 2, vsync: this);

    if(isInternetConnected) {
      _makeCallCustomerDetail();
    }else {
      noInterNet(context);
    }

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBG,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap:() {
                Navigator.pop(context);
              },
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0),),
                    color: kBlue
                ),
                alignment: Alignment.center,
                child: Image.asset('assets/images/ic_back_arrow.png', color: white, height: 22, width: 22),
              )
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(top: 11, bottom: 11, right: 22),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _showFilterDialog();
                },
                child: const Icon(Icons.calendar_today_outlined, color: white, size: 26,),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: kBlue,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showOptionActionDialog();
            // _redirectToAddOrder(context, Order(), false, true);
          },
          backgroundColor: kBlue,
          child: const Icon(Icons.add, color: white,),
        ),
        body: isInternetConnected
            ? _isLoading
            ? const LoadingWidget()
            : setData()
            : const NoInternetWidget()
    );
  }

  void getMonthToDate() {
    var monthTillDate = "";
    monthTillDate = DateTime.now().toString();

    var dateParse = DateTime.parse(monthTillDate);
    String currentDate = DateFormat('dd-MM-yyyy').format(dateParse);
    String fromDateTillMonth = "01-${DateFormat('MM-yyyy').format(dateParse)}";

    strMonthToDate = currentDate;
    strMonthFromDate = fromDateTillMonth;

  }

  void getYearDate() {
    var yearTillDate = DateTime.now().toString();
    var dateParse = DateTime.parse(yearTillDate);

    String currentYear = DateFormat('yyyy').format(dateParse);
    String fromDateTillYear = "01-04-${DateFormat('yyyy').format(dateParse)}";

    var result = int.parse(currentYear) + 1;
    String toDateTillYear = "31-03-$result";

    strYearToDate = toDateTillYear;
    strYearFromDate = fromDateTillYear;
  }

  Widget setData() {
    return Column(
        children: [
          Container(
            color: kBlue,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 22, right: 5),
                        child: Text(checkValidString(toDisplayCase(customerDetailResponseModel.customerDetails!.customerName.toString().trim())),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _redirectToAddCustomer(context, (widget as CustomerDetailPage).getSet, true);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 22),
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: const Icon(Icons.edit, color: white, size: 24,),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 22, right: 22),
                  child: Text(checkValidString(toDisplayCase(customerDetailResponseModel.customerDetails!.customerName.toString())),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontWeight: FontWeight.w400, color: white,fontSize: 14)),
                ),
                Row(
                  children: [
                    customerDetailResponseModel.customerDetails!.creditLimit.toString().isNotEmpty ?
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 22, top: 20),
                          child: Text(checkValidString(getPrice(customerDetailResponseModel.customerDetails!.creditLimit.toString())),
                              style: const TextStyle(fontWeight: FontWeight.w600, color: white,fontSize: 14)),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 22, top: 5),
                          child: const Text("Credit Limit",
                              style: TextStyle(fontWeight: FontWeight.w400, color: white,fontSize: 14)),
                        ),
                      ],
                    ) :
                    Container(),
                    customerDetailResponseModel.customerDetails!.billCreditPeriod.toString().isNotEmpty ?
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 22, top: 20,),
                          child: Text("${checkValidString(customerDetailResponseModel.customerDetails!.billCreditPeriod.toString())}",
                              style: const TextStyle(fontWeight: FontWeight.w600, color: white,fontSize: 14)),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 22, top: 5,),
                          child: const Text("Limit Period",
                              style: TextStyle(fontWeight: FontWeight.w400, color: white,fontSize: 14)),
                        ),
                      ],
                    ) :
                    Container(),
                    customerDetailResponseModel.customerDetails!.ledgerMobile.toString().isNotEmpty ?
                    GestureDetector(
                        onTap:() async {
                            var url = Uri.parse("tel:${customerDetailResponseModel.customerDetails!.ledgerMobile.toString()}");
                            if(url.toString().isNotEmpty) {
                              launch(url.toString());
                            }else {
                              throw 'Could not launch $url';
                            }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, left: 60),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20.0),),
                              color: kBlue
                          ),
                          alignment: Alignment.center,
                          child: Image.asset('assets/images/ic_bg_phone.png', color: white, height: 50, width: 50),
                        )
                    )
                    : Container(),
                    customerDetailResponseModel.customerDetails!.emailCc.toString().isNotEmpty ?
                    GestureDetector(
                        onTap:() {
                          var url = Uri.parse("mailto:${customerDetailResponseModel.customerDetails!.emailCc.toString()}");
                          if(url.toString().isNotEmpty) {
                            launch(url.toString());
                          }else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 20, left: 10),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20.0),),
                              color: kBlue
                          ),
                          alignment: Alignment.center,
                          child: Image.asset('assets/images/ic_bg_email.png', color: white, height: 50, width: 50),
                        )
                    )
                    : Container(),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Container(height: 80, color: kBlue),
                          Container(
                            height: 120,
                            color: kLightestPurple,
                            child: Container(
                            margin: const EdgeInsets.only(top: 70, left: 10, right: 10),
                            child: TabBar(
                              controller: _tabController,
                              indicatorColor: kBlue,
                              labelColor: kBlue,
                              unselectedLabelColor: kBlue,
                              tabs:  const [
                                Tab(text: 'Transactions',),
                                Tab(text: 'Sales History',)
                              ],
                            ),
                          ),),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 175,
                      child: Column(
                        children: [
                          Container(height: 20),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: kLightPurple),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                                color: white,
                                shape: BoxShape.rectangle
                            ),
                            height: 125,
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(top: 5),
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: '₹ ',
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kGreen),
                                                  children: <TextSpan>[
                                                    TextSpan(text: checkValidString(convertToComaSeparated(totalSale.toString())),
                                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kGreen, fontFamily: kFontNameRubikBold),
                                                        recognizer: TapGestureRecognizer()..onTap = () => {
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                child: const Text("Total Sales",
                                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: kGray),
                                                    textAlign: TextAlign.center)
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 1.0,
                                        color: kLightestGray,
                                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(top: 5),
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: '₹ ',
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: kRed),
                                                  children: <TextSpan>[
                                                    TextSpan(text: checkValidString(convertToComaSeparated(totalOverdue.toString())),
                                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kRed, fontFamily: kFontNameRubikBold),
                                                        recognizer: TapGestureRecognizer()..onTap = () => {
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                child: const Text("Overdues",
                                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: kGray),
                                                    textAlign: TextAlign.center)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(height: 0.5, color: kLightestGray),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: 39,
                                        alignment: Alignment.center,
                                        child: const Text("VIEW REPORTS",
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,color: kBlue),
                                            textAlign: TextAlign.center)
                                    ),
                                    Image.asset("assets/images/ic_right_arrow.png", height: 14, width: 14,)
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              dragStartBehavior: DragStartBehavior.down,
              controller: _tabController,
              children: [
                CustomerTransactionListPage(customerDetailResponseModel.customerDetails),
                CustomerSalesHistoryListPage(customerDetailResponseModel.customerDetails, callApi),
              ],
            ),
          ),
          Gap(50),
          // Container(color: Colors.transparent, height: 50,)
        ]
    );
  }

  Future<void> _redirectToAddCustomer(BuildContext context, CustomerList getSet, bool isFromList) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCustomerPage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _makeCallCustomerDetail();
      setState(() {
        isCustomerListReload = true;
      });
    }
  }

  Future<void> _redirectToAddOrder(BuildContext context, Order getSet, bool isFromList, bool isFromDetail) async {
   CustomerList customerGetSet = CustomerList();
   customerGetSet.customerId = customerDetailResponseModel.customerDetails!.customerId;
   customerGetSet.customerName = customerDetailResponseModel.customerDetails!.customerName;
   customerGetSet.addressLine1 = customerDetailResponseModel.customerDetails!.addressLine1;
   customerGetSet.addressLine2 = customerDetailResponseModel.customerDetails!.addressLine2;
   customerGetSet.addressLine3 = customerDetailResponseModel.customerDetails!.addressLine3;
   customerGetSet.addressLine4 = customerDetailResponseModel.customerDetails!.addressLine4;
   customerGetSet.addressLine5 = customerDetailResponseModel.customerDetails!.addressLine5;
   customerGetSet.cityName = customerDetailResponseModel.customerDetails!.cityName;
   customerGetSet.pincode = customerDetailResponseModel.customerDetails!.pincode;
   customerGetSet.stateName = customerDetailResponseModel.customerDetails!.stateName;

   final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddOrderPage(getSet, isFromList, customerGetSet, isFromDetail)),
    );

    print("result ===== $result");

    if (result == "success") {
      _makeCallCustomerDetail();
      setState(() {
        isOrderListLoad = true;
      });
    }
  }

  Future<void> _redirectToTransaction(BuildContext context, String orderId, String customerId, String customerName, String totalAmount) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentDetailPage(Order(), orderId, customerId, customerName, totalAmount, false)),
    );

    print("result ===== $result");

    if (result == "success") {
      setState(() {
        isCustomerListReload = true;
        tabNavigationReload();

        callApi(true);

      });
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.26,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12,top: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 60,
                            margin: const EdgeInsets.only(top: 12),
                            child: const Divider(
                              height: 1.5,
                              thickness: 1.5,
                              color: kBlue,
                            )),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                          child: const Text("Select Date", style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        Container(height: 6),
                        Expanded(child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                  itemCount: listFilter.length,
                                  shrinkWrap: true,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              // _transactionModeController.text = checkValidString(listFilter[index]);
                                            });
                                            Navigator.of(context).pop();

                                            if (index == 0) {
                                              var monthTillDate = "";
                                              monthTillDate = DateTime.now().toString();

                                              var dateParse = DateTime.parse(monthTillDate);
                                              String currentDate = DateFormat('dd-MM-yyyy').format(dateParse);

                                              print("==========");
                                              print(currentDate);
                                              print("==========");

                                              String fromDateTillMonth = "01-" + DateFormat('MM-yyyy').format(dateParse);
                                              print("==========");
                                              print(fromDateTillMonth);

                                              dateStartSelectionChanged = fromDateTillMonth;
                                              dateEndSelectionChanged = currentDate;

                                              if(isInternetConnected) {
                                                _makeCallCustomerDetail();
                                              }else {
                                                noInterNet(context);
                                              }

                                            }else if (index == 1) {

                                              var yearTillDate = DateTime.now().toString();
                                              var dateParse = DateTime.parse(yearTillDate);

                                              String currentYear = DateFormat('yyyy').format(dateParse);
                                              String fromDateTillYear = "01-04-" + DateFormat('yyyy').format(dateParse);

                                              var result = int.parse(currentYear) + 1;
                                              String toDateTillYear = "31-03-" + result.toString();

                                              print("==========");
                                              print(fromDateTillYear);
                                              print("==========");
                                              print(toDateTillYear);

                                              dateStartSelectionChanged = fromDateTillYear;
                                              dateEndSelectionChanged = toDateTillYear;

                                              if(isInternetConnected) {
                                                _makeCallCustomerDetail();
                                              }else {
                                                noInterNet(context);
                                              }

                                            }else if (index == 2) {

                                              DateTimeRange? result = await showDateRangePicker(
                                                  context: context,
                                                  firstDate: DateTime(2022, 1, 1), // the earliest allowable
                                                  lastDate: DateTime.now(), // the latest allowable
                                                  currentDate: DateTime.now(),
                                                  saveText: 'Done',
                                                  builder: (context, Widget? child) => Theme(
                                                    data: Theme.of(context).copyWith(
                                                        appBarTheme: Theme.of(context).appBarTheme.copyWith(
                                                            backgroundColor: kBlue,
                                                            iconTheme: Theme.of(context).appBarTheme.iconTheme?.copyWith(color: Colors.white)),
                                                        scaffoldBackgroundColor: white,
                                                        colorScheme: const ColorScheme.light(
                                                            onPrimary: Colors.white,
                                                            primary: kBlue
                                                        )),
                                                    child: child!,
                                                  )
                                              );

                                              if(result !=null)
                                              {
                                                DateTime? startDate = result.start;
                                                DateTime? endDate = result.end;
                                                print(startDate);
                                                print(endDate);
                                                String startDateFormat = DateFormat('dd-MM-yyyy').format(startDate);
                                                String endDateFormat = DateFormat('dd-MM-yyyy').format(endDate);
                                                print("==============");
                                                print(startDateFormat);
                                                print(endDateFormat);
                                                dateStartSelectionChanged = startDateFormat;
                                                dateEndSelectionChanged = endDateFormat;

                                                strCustomFromDate = dateStartSelectionChanged;
                                                strCustomToDate = dateEndSelectionChanged;

                                                if(strCustomFromDate.isNotEmpty && strCustomToDate.isNotEmpty) {
                                                  listFilter.removeAt(2);
                                                  listFilter.add("Custom Range "+ "(" + checkValidString(strCustomFromDate) + " - " + checkValidString(strCustomToDate) +")");
                                                }

                                                if(isInternetConnected) {
                                                  _makeCallCustomerDetail();
                                                }else {
                                                  noInterNet(context);
                                                }
                                              }

                                            }else {

                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              checkValidString(listFilter[index]),
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: black),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            margin: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                                            height: index == listFilter.length-1 ? 0 : 0.5, color: kTextLightGray),
                                      ],
                                    );
                                  })
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                );
              });
        });

  }

  void showOptionActionDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      elevation: 5,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Container(height: 2, width: 40, color: kBlue, margin: const EdgeInsets.only(bottom: 12)),
                    const Text("Select Option",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);

                        _redirectToAddOrder(context, Order(), false, true);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        alignment: Alignment.topLeft,
                        child: const Text("Add Order",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    const Divider(
                      color: kLightestGray,
                      height: 1,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);

                        _redirectToTransaction(context, "", customerDetailResponseModel.customerDetails!.customerId.toString(),
                            customerDetailResponseModel.customerDetails!.customerName.toString(), "");
                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        child: const Text("Add Transaction",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Container(height: 12)
                  ],
                ))
          ],
        );
      },
    );
  }

  void callApi(bool isFrom) {
    if (isFrom) {
      _makeCallCustomerDetail();
    }
  }

  //API call function...
  _makeCallCustomerDetail() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + customerDetails);

    Map<String, String> jsonBody = {
      'customer_id': checkValidString((widget as CustomerDetailPage).getSet.customerId).toString().trim(),
      'from_app' : FROM_APP,
      'fromDate' : dateStartSelectionChanged,
      'toDate': dateEndSelectionChanged
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CustomerDetailResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      customerDetailResponseModel = dataResponse;
      totalSale = checkValidString(dataResponse.customerDetails?.customerTotalSale).toString();
      totalOverdue = checkValidString(dataResponse.customerDetails?.customerTotalOverdue).toString();

      listCustomerTransaction = [];
      listCustomerSalesHistory = [];

      if(customerDetailResponseModel.customerDetails != null) {
        if(customerDetailResponseModel.customerDetails!.customerTransection!.isNotEmpty) {
          listCustomerTransaction = customerDetailResponseModel.customerDetails!.customerTransection! ?? [];
        }

        if(customerDetailResponseModel.customerDetails!.salesHistory!.isNotEmpty) {
          listCustomerSalesHistory = customerDetailResponseModel.customerDetails!.salesHistory! ?? [];
        }

      }

      setState(() {
        _isLoading = false;
      });

    }else {
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is CustomerDetailPage;
  }

}