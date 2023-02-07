import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/screens/add_employee_page.dart';

import '../../Model/common_response_model.dart';
import '../../Model/employee_list_response_model.dart';
import '../../constant/color.dart';
import '../../network/api_end_point.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/no_internet.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({Key? key}) : super(key: key);

  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends BaseState<EmployeeListPage> {
  bool _isLoading = false;

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 20;
  bool _isLastPage = false;

  var listEmployee = List<EmployeeList>.empty(growable: true);
  late ScrollController _scrollViewController;
  bool isScrollingDown = false;
  late num? totalAmount;
  late num? totalSale;
  EmployeeListResponseModel employeeListResponse = EmployeeListResponseModel();

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
      _getEmployeeListData(true);
    }else {
      noInterNet(context);
    }
    isEmployeeListReload = false;
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
          GestureDetector(
            onTap: () {
            },
            child: Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              child: const Icon(Icons.filter_alt_outlined, color: white, size: 28,),
            ),
          ),
          GestureDetector(
            onTap: () {
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
                    child: const Text("Employee List", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
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
                                                      TextSpan(text: checkValidString(employeeListResponse.totalSale.toString()),
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
                                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400,color: kGray),
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
                                                    // text: '₹ ',
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.red),
                                                    children: <TextSpan>[
                                                      TextSpan(text: "------",
                                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.red),
                                                          recognizer: TapGestureRecognizer()..onTap = () => {
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: const Text("Overdues",
                                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400,color: kGray),
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
                itemCount: listEmployee.length,
                itemBuilder: (ctx, index) => Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                    child: GestureDetector(
                      onTap: () {
                        EmployeeList getSet = listEmployee[index];
                        _redirectToAddEmployee(context, getSet, true);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text(checkValidString(listEmployee[index].empName),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 15),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: '₹ ',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kBlue),
                                    children: <TextSpan>[
                                      TextSpan(text: checkValidString(listEmployee[index].empTotalSale.toString()),
                                          style: const TextStyle(fontSize: 18, color: kBlue, fontWeight: FontWeight.w800),
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
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Total Sale : ',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: kGray),
                                children: <TextSpan>[
                                  TextSpan(text: '₹ ',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: black),
                                      recognizer: TapGestureRecognizer()..onTap = () => {
                                  }),
                                  TextSpan(text: checkValidString(listEmployee[index].empTotalSale.toString()),
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: black),
                                      recognizer: TapGestureRecognizer()..onTap = () => {
                                  }),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 120,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: kBlue),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(22.0),
                                    ),
                                    color: kLightestPurple,
                                    shape: BoxShape.rectangle
                                ),
                                alignment: Alignment.bottomLeft,
                                margin: const EdgeInsets.only(top:3, bottom: 3, left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/ic_customer_employee.png", height: 14, width: 14,),
                                    Container(
                                      margin: const EdgeInsets.only(top:6, bottom: 6, left: 6),
                                      child: const Text("Customer:25", style: TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 12)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_outlined, color: black, size: 24,),
                                iconSize: 24,
                                alignment: Alignment.center,
                                onPressed: () async {
                                  deleteCustomer(listEmployee[index], index);
                                },
                              ),
                            ],
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              height: index == listEmployee.length-1 ? 0 : 0.8, color: kLightPurple),
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
          _getEmployeeListData(false);
        });
      }
    }
  }

  Future<void> _redirectToAddEmployee(BuildContext context, EmployeeList getSet, bool isFromList) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEmployeePage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getEmployeeListData(true);
      setState(() {
        isEmployeeListReload = true;
      });
    }
  }

  void deleteCustomer(EmployeeList employee, int index) {
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
                      child: const Text('Delete Employee', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: black))
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: const Text('Are you sure want to delete this employee?',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black)),
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
                                  _makeDeleteEmployeeRequest(employee, index);
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

  void _getEmployeeListData([bool isFirstTime = false]) async {
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

    final url = Uri.parse(BASE_URL + employeeList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> order = jsonDecode(body);
    var dataResponse = EmployeeListResponseModel.fromJson(order);

    if (isFirstTime) {
      if (listEmployee.isNotEmpty) {
        listEmployee = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      employeeListResponse = EmployeeListResponseModel.fromJson(order);
      // totalAmount = dataResponse.totalAmount;
      // totalSale = dataResponse.todaysSale;

      if (employeeListResponse.employeeList != null) {

        List<EmployeeList>? _tempList = [];
        _tempList = employeeListResponse.employeeList;
        listEmployee.addAll(_tempList!);

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

  _makeDeleteEmployeeRequest(EmployeeList employee, int index) async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + deleteEmployee);

    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'emp_id': employee.empId.toString(),
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);

      setState(() {
        listEmployee.removeAt(index);
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
    widget is EmployeeListPage;
  }

}