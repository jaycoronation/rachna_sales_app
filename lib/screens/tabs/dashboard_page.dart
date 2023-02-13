import 'dart:convert';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/customer_list_response_model.dart';
import 'package:salesapp/Model/dash_board_data_response_model.dart';
import 'package:salesapp/Model/employee_list_response_model.dart';
import 'package:salesapp/model/order_detail_response_model.dart';
import 'package:salesapp/screens/add_customer_page.dart';
import 'package:salesapp/screens/add_employee_page.dart';
import 'package:salesapp/screens/add_order_page.dart';
import 'package:salesapp/screens/add_payement_detail_page.dart';
import 'package:salesapp/screens/daily_plans_pages.dart';
import 'package:salesapp/screens/profile_page.dart';
import 'package:salesapp/screens/transaction_list_page.dart';
import 'package:salesapp/utils/app_utils.dart';

import '../../constant/color.dart';
import '../../model/product_item_list_response_model_old.dart';
import '../../network/api_end_point.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/no_internet.dart';
import '../add_product_page.dart';
import '../product_list_page_old.dart';


class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends BaseState<DashboardPage> {
  bool _isLoading = false;

  late num? totalAmount;
  late num? totalOverdue;
  late num? totalEmployee;
  late num? totalCustomer;
  List<String> listOptions = List<String>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    listOptions = ["Add Customer", "Add Product", "Add Order", "Add Transaction"];

    if(isInternetConnected) {
      _makeCallDashboardData();
    }else {
      noInterNet(context);
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 55,
        automaticallyImplyLeading: false,
        title: const Text(""),
        leading: GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: kLightPurple),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: sessionManager.getProfilePic().toString().isNotEmpty ? FadeInImage.assetNetwork(
                      image: sessionManager.getProfilePic().toString(),
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      placeholder: 'assets/images/img_user_placeholder.png',
                    ) :
                Image.asset('assets/images/img_user_placeholder.png', width: 45, height: 45)
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          },
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 12, top: 9, bottom: 9),
            child: GestureDetector(
              onTap: () {
                showOptionActionDialog();
              },
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: kLightPurple),
                    borderRadius: const BorderRadius.all(Radius.circular(14.0),),
                    color: kLightestPurple,
                    shape: BoxShape.rectangle
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.add, color: kBlue, size: 20,),
              ),
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
        backgroundColor: appBG,
      ),
      body: isInternetConnected
          ? _isLoading
          ? const LoadingWidget()
          : setData()
          : const NoInternetWidget()
    );
  }
  
  Padding setData() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top:10, bottom: 10, left: 10),
                child: Text("Hi, ${checkValidString(sessionManager.getName().toString().trim())}",
                    style: const TextStyle(fontWeight: FontWeight.w700, color: black, fontSize: 20)),
              ),
              SizedBox(
                height: 150,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 150,
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      child: Image.asset("assets/images/ic_bg_blue.png")
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: '₹ ',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: white),
                                      children: <TextSpan>[
                                        TextSpan(text: checkValidString(convertToComaSeparated(totalAmount.toString())),
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: white),
                                            recognizer: TapGestureRecognizer()..onTap = () => {
                                            }),
                                      ],
                                    ),
                                  ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  child: const Text("Total Sales",
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: white),
                                      textAlign: TextAlign.center)
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 40, bottom: 40),
                            child: const VerticalDivider(width: 1.0, thickness: 1.0, color: white, indent: 10.0, endIndent: 10.0)),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: '₹ ',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: white),
                                      children: <TextSpan>[
                                        TextSpan(text: checkValidString(convertToComaSeparated(totalOverdue.toString())),
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: white),
                                            recognizer: TapGestureRecognizer()..onTap = () => {
                                            }),
                                      ],
                                    ),
                                  ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  child: const Text("Overdue",
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: white),
                                      textAlign: TextAlign.center)
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
                  // bar.onTap!(2);
                  final DotNavigationBar bar = bottomWidgetKey1.currentWidget as DotNavigationBar;
                  bar.onTap!(2);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: kLightPurple),
                      borderRadius: const BorderRadius.all(Radius.circular(6.0),),
                      color: kLightestPurple,
                      shape: BoxShape.rectangle
                  ),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top:30, bottom: 5, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top:6, bottom: 6),
                          child: Image.asset("assets/images/ic_bg_customer.png", height: 42, width: 45,)
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top:5, bottom: 5, left: 5),
                        child: Text("Customer (${checkValidString(totalCustomer.toString())})",
                            style: const TextStyle(fontWeight: FontWeight.w400, color: black,fontSize: 14)
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        /*GestureDetector(
                          onTap: () {
                            final DotNavigationBar bar = bottomWidgetKey1.currentWidget as DotNavigationBar;
                            bar.onTap!(3);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: kLightPurple),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                              color: kLightestPurple,
                              shape: BoxShape.rectangle
                            ),
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top:30, bottom: 5, left: 10, right: 5),
                            child: Row(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top:6, bottom: 6, left: 10),
                                    child: Image.asset("assets/images/ic_employee_bag.png", height: 42, width: 45,)
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top:5, bottom: 5, left: 5),
                                  child:  Text("Employee (${checkValidString(totalEmployee.toString())})",
                                      style: const TextStyle(fontWeight: FontWeight.w400, color: black,fontSize: 14)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),*/
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionListPage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: kLightPurple),
                                borderRadius: const BorderRadius.all(Radius.circular(6.0),),
                                color: kLightestPurple,
                                shape: BoxShape.rectangle
                            ),
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top:5, bottom: 5, left: 10, right: 5),
                            child: Row(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top:6, bottom: 6, left: 10),
                                    child: Image.asset("assets/images/ic_transaction.png", height: 42, width: 45,)
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top:5, bottom: 5, left: 5),
                                  child: const Text("Transactions", style: TextStyle(fontWeight: FontWeight.w400, color: black,fontSize: 14)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
                            // bar.onTap!(1);
                            final DotNavigationBar bar = bottomWidgetKey1.currentWidget as DotNavigationBar;
                            bar.onTap!(1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: kLightPurple),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                color: kLightestPurple,
                                shape: BoxShape.rectangle
                            ),
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top:5, bottom: 5, left: 10, right: 5),
                            child: Row(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top:6, bottom: 6, left: 10),
                                    child: Image.asset("assets/images/ic_orders.png", height: 42, width: 45,)
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top:5, bottom: 5, left: 5),
                                  child: const Text("Orders", style: TextStyle(fontWeight:FontWeight.w400, color: black,fontSize: 14)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: kLightPurple),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                color: kLightestGray,
                                shape: BoxShape.rectangle
                            ),
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top:5, bottom: 5, left: 5, right: 10),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top:6, bottom: 6, left: 10),
                                  child: Image.asset("assets/images/ic_reports.png", height: 42, width: 45,)
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top:5, bottom: 5, left: 10),
                                  child: const Text("Reports",
                                      style: TextStyle(fontWeight: FontWeight.w400, color: black,fontSize: 14)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListPage()));
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListPageOld()));

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: kLightPurple),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                color: kLightestPurple,
                                shape: BoxShape.rectangle
                            ),
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top:5, bottom: 5, left: 5, right: 10),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top:6, bottom: 6, left: 10),
                                  child: Image.asset("assets/images/ic_products.png", height: 42, width: 45,)
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top:5, bottom: 5, left: 5, right: 10),
                                  child: const Text("Products",
                                      style: TextStyle(fontWeight:FontWeight.w400, color: black,fontSize: 14)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top:30, bottom: 5, left: 10),
                    child: const Text("Daily Plans", style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 20)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyPlansPage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: kLightestGray,//kLightestPurple,
                          border: Border.all(width: 1, color: kLightPurple),
                          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                          shape: BoxShape.rectangle
                      ),
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(top:30, bottom: 5, left: 10, right: 10),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text("View All", style: TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 30),
                child: SizedBox(
                    height: 110,
                    child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (ctx, index) => (InkWell(
                      hoverColor: Colors.white.withOpacity(0.0),
                      onTap: () async {
                        setState(() {
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: kLightPurple, // Set border color
                                width: 1.0),
                            color: kLightestPurple,
                            borderRadius: const BorderRadius.all(Radius.circular(12))),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(right: 10),
                        width: 115,
                        height: 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      color: kBlue,
                                      borderRadius: BorderRadius.all(Radius.circular(kTextFieldCornerRadius))),
                                    width: 35,
                                    height: 35,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 3, left: 7, top: 12),
                                      child: const Text("15",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12, color: white, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 3, left: 7, bottom: 3),
                                      child: const Text("May",
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 11, color: white, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 4),
                              child: const Text("Hyatt Hotel",
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14, color: kBlue, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Text("11:15AM - 1:00PM",
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12, color: kGray, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    )))),
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _redirectToAddCustomer(context, CustomerList(), false);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: kLightPurple),
                            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                            color: kLightestPurple,
                            shape: BoxShape.rectangle
                        ),
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, color: kBlue, size: 18,),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top:15, bottom:15, left: 8),
                              child: const Text("Add Customer", style: TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        // _redirectToAddProduct(context, ItemData(), false); //ItemData()
                        _redirectToAddProduct(context, Products(), false);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: kLightPurple),
                            borderRadius: const BorderRadius.all(Radius.circular(6.0),),
                            color: kLightestPurple,
                            shape: BoxShape.rectangle
                        ),
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.only(bottom: 5, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, color: kBlue, size: 18,),
                            Container(
                              margin: const EdgeInsets.only(top:15, bottom: 15, left: 8),
                              child: const Text("Add Product", style: TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                *//*  Flexible(
                    child: Column(
                      children: [
                        *//**//*GestureDetector(
                          onTap: () {
                            _redirectToAddEmployee(context,EmployeeList(), false);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: kLightPurple),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                                color: kLightestPurple,
                                shape: BoxShape.rectangle
                            ),
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top:5, bottom: 5, left: 10, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: kBlue, size: 18,),
                                Container(
                                  margin: const EdgeInsets.only(top:15, bottom: 15),
                                  child: const Text("Add Employee",
                                      style: TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),*//**/
              /*
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPaymentDetailPage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: kLightPurple),
                                borderRadius: const BorderRadius.all(Radius.circular(6.0),),
                                color: kLightestPurple,
                                shape: BoxShape.rectangle
                            ),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top:5, bottom: 5, left: 5, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: kBlue, size:18,),
                                Container(
                                  margin: const EdgeInsets.only(top:15, bottom: 15, left: 8),
                                  child: const Text("Add Payments", style: TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )*/

              /*
                ],
              ),*/
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        )
    );
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
      _makeCallDashboardData();
      setState(() {
        isHomeLoad = true;
      });
    }
  }

  Future<void> _redirectToAddCustomer(BuildContext context, CustomerList getSet, bool isFromList) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCustomerPage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _makeCallDashboardData();
      setState(() {
        isHomeLoad = true;
      });
    }
  }

 /* Future<void> _redirectToAddProduct(BuildContext context, ItemData getSet, bool isFromList) async { //ItemData getSet,
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductPage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _makeCallDashboardData();
      setState(() {
        isHomeLoad = true;
      });
    }
  }*/

  Future<void> _redirectToAddProduct(BuildContext context, Products getSet, bool isFromList) async { //ItemData getSet,
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductPage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _makeCallDashboardData();
      setState(() {
        isHomeLoad = true;
      });
    }
  }

  Future<void> _redirectToAddOrder(BuildContext context, Order getSet, bool isFromList) async {
    var customerData = CustomerList();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddOrderPage(getSet, isFromList, customerData, false)),
    );

    print("result ===== $result");

    if (result == "success") {
      _makeCallDashboardData();
      setState(() {
        isHomeLoad = true;
      });
    }
  }

  Future<void> _redirectToTransaction(BuildContext context, Order getSet, bool isFromDashboard) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentDetailPage(getSet, "", "", "", "", isFromDashboard)),
    );

    print("result ===== $result");

    if (result == "success") {
      _makeCallDashboardData();
      setState(() {
        isHomeLoad = true;
      });
    }
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
                    const Text("Add Option",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        _redirectToAddCustomer(context, CustomerList(), false);
                      },
                      child: Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top:6, bottom: 6),
                              child: Image.asset("assets/images/ic_bg_customer.png", height: 42, width: 45,)
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 18, top: 15, bottom: 15),
                            alignment: Alignment.topLeft,
                            child: const Text("Customer",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: kLightestGray,
                      height: 1,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        _redirectToAddProduct(context, Products(), false);
                      },
                      child: Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top:6, bottom: 6),
                              child: Image.asset("assets/images/ic_products.png", height: 42, width: 45,)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            child: const Text("Product",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: kLightestGray,
                      height: 1,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        _redirectToAddOrder(context, Order(), false);
                      },
                      child: Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top:6, bottom: 6),
                              child: Image.asset("assets/images/ic_orders.png", height: 42, width: 45,)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(right: 18, top: 15, bottom: 15),
                            child: const Text("Order",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: kLightestGray,
                      height: 1,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        _redirectToTransaction(context, Order(), true);
                      },
                      child: Row(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top:6, bottom: 6),
                              child: Image.asset("assets/images/ic_transaction.png", height: 42, width: 45,)
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(right: 18, top: 15, bottom: 15),
                            child: const Text("Transaction",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        );
      },
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is DashboardPage;
  }

  //API Call Functions...
  void _makeCallDashboardData() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + dashboardData);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'customer_id': sessionManager.getEmpId().toString().trim(),
    };

    final response = await http.post(url, body: jsonBody);

    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = DashBoardDataResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      setState(() {
        _isLoading = false;
      });

      totalAmount = dataResponse.data?.totalAmount;
      totalOverdue = dataResponse.data?.totalOverdue;
      totalEmployee = dataResponse.data?.totalEmployee;
      totalCustomer = dataResponse.data?.totalCustomer;

    }else {
      setState(() {
        _isLoading = false;
      });

    }
  }

}