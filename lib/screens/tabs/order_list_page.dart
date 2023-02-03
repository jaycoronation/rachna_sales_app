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
import 'package:salesapp/screens/order_detail_page.dart';
import 'package:salesapp/utils/app_utils.dart';

import '../../constant/color.dart';
import '../../network/api_end_point.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/no_internet.dart';
import '../add_order_page.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends BaseState<OrderListPage> {
  bool _isLoading = false;

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 20;
  bool _isLastPage = false;

  var listOrder = List<OrderList>.empty(growable: true);
  late ScrollController _scrollViewController;
  bool isScrollingDown = false;
  late String? totalAmount;
  late String? totalSale;

  String dateStartSelectionChanged = "";
  String dateEndSelectionChanged = "";

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
        toolbarHeight: 61,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddOrderPage()));
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
                                                        TextSpan(text: totalSale.toString(),
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
                ],
              ),
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                itemCount: listOrder.length,
                itemBuilder: (ctx, index) => InkWell(
                  hoverColor: Colors.white.withOpacity(0.0),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailPage(listOrder[index].customerId.toString(), listOrder[index].orderId.toString())));
                  },
                  child: Container(
                    color: white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                      child: GestureDetector(
                        onTap: () {
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

  void _getOrderListData([bool isFirstTime = false]) async {
    if (isFirstTime) {
      setState(() {
        _isLoading = true;
        _isLoadingMore = false;
        _pageIndex = 0;
        _isLastPage = false;
      });
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
      'search' : '',
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
      totalSale = checkValidString(dataResponse.todaysSale.toString());

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
        _isLoadingMore = false;
      });

    }else {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is OrderListPage;
  }

}