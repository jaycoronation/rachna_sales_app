import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/order_list_response_model.dart';
import 'package:salesapp/model/order_detail_response_model.dart';
import 'package:salesapp/screens/order_detail_page.dart';
import 'package:salesapp/utils/app_utils.dart';
import 'package:salesapp/widget/no_data.dart';

import '../../Model/customer_list_response_model.dart';
import '../../constant/color.dart';
import '../../constant/font.dart';
import '../../model/customer_detail_response_model.dart';
import '../../network/api_end_point.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/no_internet.dart';
import '../add_order_page.dart';
import '../add_payement_detail_page.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends BaseState<OrderListPage> {
  bool _isLoading = false;
  bool _isSearchLoading = false;

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 20;
  bool _isLastPage = false;

  var listOrder = List<OrderList>.empty(growable: true);
  late ScrollController _scrollViewController;
  bool isScrollingDown = false;
  late String? totalAmount;
  late String? todaySale;

  String dateStartSelectionChanged = "";
  String dateEndSelectionChanged = "";

  TextEditingController searchController = TextEditingController();
  String searchText = "";
  var listFilter = ["Month to date", "Year to date", "Custom Range"];

  @override
  void initState() {

    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }

      pagination();

    });

    if(isInternetConnected) {
      _getOrderListData(true);
    }else {
      noInterNet(context);
    }
    isOrderListLoad = false;

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        title: const Text("Orders",
          style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
        actions: [
  /*        GestureDetector(
            onTap: () {
            },
            child: Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              child: const Icon(Icons.search, color: white, size: 32,),
            ),
          ),*/
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 12),
            child: GestureDetector(
              onTap: () {
                _redirectToAddOrder(context, Order(), false);
              },
              child: Container(
                height: 33,
                width: 34,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: kLightestPurple),
                    borderRadius: const BorderRadius.all(Radius.circular(14.0),),
                    color: white,
                    shape: BoxShape.rectangle
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.add, color: kBlue, size: 21,),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 11, bottom: 11, left:  15, right: 22),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _showFilterDialog();
              },
              child: const Icon(Icons.calendar_today_outlined, color: white, size: 28,),
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
      ),
      body: isInternetConnected
          ? _isLoading
          ? const LoadingWidget()
          : setData()
          : const NoInternetWidget()
    );
  }

  Widget setData() {
    return Column(
        children: [
          Container(
            color: kBlue,
            child: Stack(
              children: [
                SizedBox(
                  height: 215,
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        color: kBlue,
                      ),
                      Container(
                        height: 95,
                        color: kLightestPurple,
                      ),
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(width: 1, color: kLightPurple),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        shape: BoxShape.rectangle
                    ),
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 150),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      controller: searchController,
                      cursorColor: black,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: black,),
                      decoration: InputDecoration(
                          hintText: "Search Order",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: kLightPurple, width: 0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: kLightPurple, width: 0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, size: 26, color: kBlue,),
                          suffixIcon: InkWell(
                            child:  _isSearchLoading ?
                            const SizedBox(
                                height:10,
                                width:10,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(color: kBlue, strokeWidth: 2),
                                ))
                            : const Icon(Icons.close, size: 26, color: black,),
                            onTap: () {

                              if (searchController.text.isNotEmpty) {
                                setState(() {
                                  searchController.text = "";
                                  searchText = "";
                                  dateStartSelectionChanged = "";
                                  dateEndSelectionChanged = "";
                                  isOrderListLoad = false;
                                  FocusScope.of(context).unfocus();

                                });
                                _getOrderListData(true, true);
                              }

                            },
                          )
                      ),
                      onChanged: (text) {
                        searchController.text = text;
                        searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                        if (text.isEmpty) {
                          setState(() {
                            searchText = "";
                          });

                          _getOrderListData(true);
                        }
                        else if (text.length > 3) {
                          setState(() {
                            searchText = searchController.text.toString().trim();
                          });
                          _getOrderListData(true);
                        }
                      },
                    )
                ),
                SizedBox(
                  height: 135,
                  child: Column(
                    children: [
                      Container(
                        height: 10,
                      ),
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
                                                TextSpan(text: checkValidString(convertToComaSeparated(totalAmount.toString())),
                                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kGreen, fontFamily: kFontNameRubikBold),
                                                    recognizer: TapGestureRecognizer()..onTap = () => {
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            child: const Text("Total Orders",
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
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kGreen),
                                              children: <TextSpan>[
                                                TextSpan(text: checkValidString(convertToComaSeparated(todaySale.toString())),
                                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kGreen, fontFamily: kFontNameRubikBold),
                                                    recognizer: TapGestureRecognizer()..onTap = () => {
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            child: const Text("Today's Orders",
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
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kBlue),
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
          ),
          // _isSearchLoading
          //     ? const LoadingWidget() :
          Expanded(
            child: Stack(
              children: [
                listOrder.isNotEmpty ?
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _scrollViewController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    itemCount: listOrder.length,
                    itemBuilder: (ctx, index) => Container(
                      color: white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _redirectToOrderDetail(context, checkValidString(listOrder[index].customerId).toString(), checkValidString(listOrder[index].orderId).toString());
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Gap(10),
                                        Text(checkValidString(listOrder[index].orderId),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                        ),
                                        const Gap(5),
                                        Container(width: 2, height: 15, color: black),
                                        const Gap(5),
                                        Expanded(
                                          child: Text(checkValidString(listOrder[index].customerName),
                                            maxLines: 2,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    alignment: Alignment.bottomLeft,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: '₹ ',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kBlue),
                                        children: <TextSpan>[
                                          TextSpan(text: checkValidString(convertToComaSeparated(listOrder[index].grandTotal.toString())),
                                              style: const TextStyle(fontSize: 18, color: kBlue, fontWeight: FontWeight.w700),
                                              recognizer: TapGestureRecognizer()..onTap = () => {
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, bottom: 5),
                                    child: Text(
                                      checkValidString(listOrder[index].createdAt),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 13, color: kGray, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Visibility(
                                    visible: checkValidString(listOrder[index].pendingAmount).toString() == "0" ? false : true,
                                    child: Container(
                                      height: 32,
                                        margin: const EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
                                        decoration: BoxDecoration(
                                            color: kLightestPurple,
                                            border: Border.all(width: 1, color: kLightPurple),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(12.0),
                                            ),
                                            shape: BoxShape.rectangle
                                        ),
                                        child: TextButton(
                                          child:const Text("Receive Payment",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontSize: 13, color: black, fontWeight: FontWeight.w500),
                                          ),
                                          onPressed: () {
                                            _redirectToTransaction(context, checkValidString(listOrder[index].orderId).toString(), checkValidString(listOrder[index].customerId).toString(),
                                                checkValidString(listOrder[index].customerName).toString(), checkValidString(listOrder[index].pendingAmount).toString());
                                          },
                                        )
                                      //
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                  height: index == listOrder.length-1 ? 0 : 0.8, color: kLightPurple),
                            ],
                          ),
                        ),
                      ),
                    ))
                : const MyNoDataWidget(msg: "", subMsg: "No orders found"),
                Visibility(
                    visible: _isLoadingMore,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(bottom: 80),
                            width: 30,
                            height: 30,
                            child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                        Container(
                          margin: const EdgeInsets.only(bottom: 80),
                          child: const Text(
                              ' Loading more...',
                              style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ]
    );
  }

  void pagination() {
    if(!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          _getOrderListData(false);
        });
      }
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
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12,top: 15),
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

                                              String fromDateTillMonth = "01-${DateFormat('MM-yyyy').format(dateParse)}";
                                              print("==========");
                                              print(fromDateTillMonth);

                                              dateStartSelectionChanged = fromDateTillMonth;
                                              dateEndSelectionChanged = currentDate;

                                              if(isInternetConnected) {
                                                _getOrderListData(true);
                                              }else {
                                                noInterNet(context);
                                              }

                                            }else if (index == 1) {

                                              var yearTillDate = DateTime.now().toString();
                                              var dateParse = DateTime.parse(yearTillDate);

                                              String currentYear = DateFormat('yyyy').format(dateParse);
                                              String fromDateTillYear = "01-04-${DateFormat('yyyy').format(dateParse)}";

                                              var result = int.parse(currentYear) + 1;
                                              String toDateTillYear = "31-03-$result";

                                              print("==========");
                                              print(fromDateTillYear);
                                              print("==========");
                                              print(toDateTillYear);

                                              dateStartSelectionChanged = fromDateTillYear;
                                              dateEndSelectionChanged = toDateTillYear;

                                              if(isInternetConnected) {
                                                _getOrderListData(true);
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

                                                if(isInternetConnected) {
                                                  _getOrderListData(true);
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
                                        const Divider(
                                          thickness: 0.5,
                                          color: kTextLightGray,
                                          endIndent: 16,
                                          indent: 16,
                                        ),
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

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is OrderListPage;
  }

  Future<void> _redirectToTransaction(BuildContext context, String orderId, String customerId, String customerName, String totalAmount) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentDetailPage(Order(), orderId, customerId, customerName, totalAmount, false)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getOrderListData(true);
      setState(() {
      });
    }
  }

  Future<void> _redirectToAddOrder(BuildContext context, Order getSet, bool isFromList) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddOrderPage(getSet, isFromList, CustomerList(), false)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getOrderListData(true);
      setState(() {
        isOrderListLoad = true;
      });
    }
  }

  Future<void> _redirectToOrderDetail(BuildContext context, String customerId, String orderId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailPage(customerId, orderId)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getOrderListData(true);
      setState(() {
        isOrderListLoad = true;
      });
    }
  }

  void _getOrderListData([bool isFirstTime = false, bool isFromClose = false]) async {

    if (isFirstTime) {
      if (searchText.isNotEmpty) {
        setState(() {
          _isLoading = false;
          _isSearchLoading = true;
          _isLoadingMore = false;
          _pageIndex = 0;
          _isLastPage = false;
        });
      }else {
        setState(() {
          if (isFromClose) {
            _isSearchLoading = true;
            _isLoading = false;
            _isLoadingMore = false;
            _pageIndex = 0;
            _isLastPage = false;
          }else {
            _isLoading = true;
            _isLoadingMore = false;
            _pageIndex = 0;
            _isLastPage = false;
          }

        });
      }
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + orderMasterList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'employee_id': sessionManager.getEmpId().toString().trim(),
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
      'search' : searchText,
      'fromDate' : dateStartSelectionChanged,
      'toDate': dateEndSelectionChanged
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> order = jsonDecode(body);
    var dataResponse = OrderListResponseModel.fromJson(order);

    if (isFirstTime) {
      if (listOrder.isNotEmpty) {
        listOrder = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      var orderListResponse = OrderListResponseModel.fromJson(order);
      totalAmount = checkValidString(dataResponse.totalAmount.toString());
      todaySale = checkValidString(dataResponse.todaysSale.toString());
      
      sessionManagerMethod.setTotalOrders(dataResponse.totalAmount.toString());

      if (orderListResponse.orderList != null) {
        List<OrderList>? _tempList = [];
        _tempList = orderListResponse.orderList;
        listOrder.addAll(_tempList!);

        if (_tempList.isNotEmpty) {
          _pageIndex += 1;
          if (_tempList.isEmpty || _tempList.length % _pageResult != 0) {
            _isLastPage = true;
          }
        }
      }

      setState(() {
        _isLoading = false;
        _isSearchLoading = false;

        _isLoadingMore = false;
      });

    }else {
      setState(() {
        _isLoading = false;
        _isSearchLoading = false;

        _isLoadingMore = false;
      });
    }
  }

}