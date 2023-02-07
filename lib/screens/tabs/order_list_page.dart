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

import '../../Model/customer_list_response_model.dart';
import '../../constant/color.dart';
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        title: const Text(""),
        actions: [
          GestureDetector(
            onTap: () {
            },
            child: Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              child: const Icon(Icons.search, color: white, size: 28,),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 14, bottom: 14),
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
          GestureDetector(
            onTap: () async {
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
            },
            child: Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              child: const Icon(Icons.calendar_today_outlined, color: white, size: 22,),
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

  SingleChildScrollView setData() {
    return SingleChildScrollView(
      controller: _scrollViewController,
      child: Column(
          children: [
            Container(
              color: kBlue,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 22),
                    child: const Text("Orders", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
                  ),
                  Stack(
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
                                  child: const Icon(
                                    Icons.close,
                                    size: 26,
                                    color: black,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isOrderListLoad = false;
                                      searchController.text = "";
                                      searchText = "";
                                    });

                                    _getOrderListData(true);
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
                                                      TextSpan(text: totalAmount.toString(),
                                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kGreen),
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
                                                      TextSpan(text: todaySale.toString(),
                                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kGreen),
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

                  /*Stack(
                    children: [
                      SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              color: kBlue,
                            ),
                            Container(
                              height: 30,
                              color: kLightestPurple,
                            )
                          ],
                        ),
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
                                                        TextSpan(text: totalAmount.toString(),
                                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kGreen),
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
                                                        TextSpan(text: todaySale.toString(),
                                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kGreen),
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
                  ),*/
                ],
              ),
            ),
            _isSearchLoading
                ? const Center(
              child: LoadingWidget(),
            ) :
            ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
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
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                              Container(width: 2, height: 15, color: black,),
                                              const Gap(5),
                                              Expanded(
                                                child: Text(checkValidString(listOrder[index].customerName),
                                                  maxLines:2,
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
                                                TextSpan(text: checkValidString(listOrder[index].grandTotal.toString()),
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
                                        Container(
                                            margin: const EdgeInsets.only(left: 10, bottom: 5),
                                            child: TextButton(
                                              child:const Text("Receive Payment",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(fontSize: 13, color: black, fontWeight: FontWeight.w500),
                                              ),
                                              onPressed: () {
                                                _redirectToTransaction(context, checkValidString(listOrder[index].orderId).toString(), checkValidString(listOrder[index].customerId).toString());
                                              },
                                            )
                                          //
                                        ),
                                      ],
                                    ),
                                  ],
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
                )),
            if (_isLoadingMore == true)
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 30,
                        height: 30, child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                    const Text(
                        ' Loading more...',
                        style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                    )
                  ],
                ),
              ),
          ]
      ),
    );
  }

  void pagination() {
    if(!_isLastPage && !_isLoadingMore)
    {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          _getOrderListData(false);
        });
      }
    }
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is OrderListPage;
  }

  Future<void> _redirectToTransaction(BuildContext context, String orderId, String customerId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentDetailPage(Order(), orderId, customerId)),
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

  void _getOrderListData([bool isFirstTime = false]) async {

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
          _isLoading = true;
          _isLoadingMore = false;
          _pageIndex = 0;
          _isLastPage = false;
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