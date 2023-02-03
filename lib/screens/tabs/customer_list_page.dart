import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/screens/add_customer_page.dart';

import '../../Model/common_response_model.dart';
import '../../Model/customer_list_response_model.dart';
import '../../constant/color.dart';
import '../../network/api_end_point.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/no_internet.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({Key? key}) : super(key: key);

  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends BaseState<CustomerListPage> {
  bool _isLoading = false;

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 20;
  bool _isLastPage = false;

  var listCustomer = List<CustomerList>.empty(growable: true);
  late ScrollController _scrollViewController;
  bool isScrollingDown = false;
  late String? totalOverdue;
  late String? totalSale;

  String dateStartSelectionChanged = "";
  String dateEndSelectionChanged = "";

  TextEditingController textEditingController = TextEditingController();

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
      _getCustomerListData(true);
    }else {
      noInterNet(context);
    }

    isCustomerListReload = false;

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
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
                _redirectToAddCustomer(context, CustomerList(), false);
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
            behavior: HitTestBehavior.opaque,
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
                  _getCustomerListData(true);
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
      child: Column(
          children: [
            Container(
              color: kBlue,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 22),
                    child: const Text("Customer List", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
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
                            Container(height: 10,),
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
                                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: kGreen),
                                                      children: <TextSpan>[
                                                        TextSpan(text: totalOverdue.toString(),
                                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kGreen),
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
            ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                controller: _scrollViewController,
                primary: false,
                shrinkWrap: true,
                itemCount: listCustomer.length,
                itemBuilder: (ctx, index) => InkWell(
                  hoverColor: Colors.white.withOpacity(0.0),
                  onTap: () async {},
                  child: Container(
                    color: white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          CustomerList getSet = listCustomer[index];
                          _redirectToAddCustomer(context, getSet, true);
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
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 10,right: 5),
                                              child: Text(checkValidString(listCustomer[index].customerName.toString().trim()),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            alignment: Alignment.bottomLeft,
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                text: '₹ ',
                                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.red),
                                                children: <TextSpan>[
                                                  TextSpan(text: checkValidString(listCustomer[index].creditLimit.toString()),
                                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.red),
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
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                text: 'Total Sale : ',
                                                style:  TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: kGray),
                                                children: <TextSpan>[
                                                  TextSpan(text: listCustomer[index].customerTotalSale.toString(),
                                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: black),
                                                      recognizer: TapGestureRecognizer()..onTap = () => {
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline_outlined, color: black, size: 24,),
                                            iconSize: 24,
                                            alignment: Alignment.center,
                                            onPressed: () async {
                                              _deleteCustomer(listCustomer[index], index);
                                            },
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
                                height: index == listCustomer.length-1 ? 0 : 0.8, color: kLightPurple),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            Visibility(visible: _isLoadingMore,
                child: Container(
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
              ))
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
          _getCustomerListData(false);
        });
      }
    }
  }

  Future<void> _redirectToAddCustomer(BuildContext context, CustomerList getSet, bool isFromList) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCustomerPage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getCustomerListData(true);
      setState(() {
        isCustomerListReload = true;
      });
    }
  }

  void _deleteCustomer(CustomerList customer, int index) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  color: white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 40,
                    alignment: Alignment.center,
                    color: kBlue,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text('Delete Customer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: black))
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: const Text('Are you sure want to delete this customer?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.4, color: kBlue),
                                borderRadius:  BorderRadius.all(Radius.circular(kButtonCornerRadius)),
                              ),
                              margin: const EdgeInsets.only(right: 10),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:const Text('No', style:TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kBlue,))
                              ),
                            ),
                          ),
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kButtonCornerRadius),
                                color:kBlue,
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  _makeDeleteCustomerRequest(customer, index);
                                },
                                child:
                                const Text('Yes',style:TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: white)),
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
          ],
        );
      },
    );
  }

  void _getCustomerListData([bool isFirstTime = false]) async {
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

    final url = Uri.parse(BASE_URL + customerList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
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
    var dataResponse = CustomerListResponseModel.fromJson(order);

    if (isFirstTime) {
      if (listCustomer.isNotEmpty) {
        listCustomer = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      var customerListResponse = CustomerListResponseModel.fromJson(order);
      totalOverdue = checkValidString(dataResponse.totalOverdue);
      totalSale = checkValidString(dataResponse.totalSale);

      if (customerListResponse.customerList != null) {

        List<CustomerList>? _tempList = [];
        _tempList = customerListResponse.customerList;
        listCustomer.addAll(_tempList!);

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
        // isAddedOrRemovedProduct = true;
      });

    }else {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _makeDeleteCustomerRequest(CustomerList customer, int index) async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + deleteCustomerList);

    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'customer_id': checkValidString(customer.customerId.toString().trim()),
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);

      setState(() {
        // isAddedOrRemovedBank = true;
        listCustomer.removeAt(index);
        _isLoading = false;
        tabNavigationReload();
      });

    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is CustomerListPage;
  }

}