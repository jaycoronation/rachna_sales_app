import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/screens/add_customer_page.dart';
import 'package:salesapp/screens/customer_transaction_page.dart';

import '../../Model/customer_list_response_model.dart';
import '../../constant/color.dart';
import '../../network/api_end_point.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/no_internet.dart';
import '../model/customer_detail_response_model.dart';
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

  CustomerDetailResponseModel customerDetailResponseModel = CustomerDetailResponseModel();

  var listCustomerTransaction = List<CustomerTransection>.empty(growable: true);
  var listCustomerSalesHistory = List<SalesHistory>.empty(growable: true);

  late String? totalOverdue;
  late String? totalSale;

  late TabController _tabController;

  @override
  void initState() {
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
        appBar:AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          toolbarHeight: 61,
          automaticallyImplyLeading: false,
          title: const Text(""),
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
          centerTitle: false,
          elevation: 0.0,
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 22,right: 5),
                        child: Text(checkValidString(customerDetailResponseModel.customerDetails!.customerName.toString().trim()),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 20, color: white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _redirectToAddCustomer(context, (widget as CustomerDetailPage).getSet, true);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 5),
                        height: 33,
                        width: 34,
                        alignment: Alignment.center,
                        child: const Icon(Icons.edit, color: white, size: 21,),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 22),
                  child: Text(checkValidString(customerDetailResponseModel.customerDetails!.customerName.toString()),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
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
                          padding: const EdgeInsets.only(left: 22, top: 20, ),
                          child: Text(checkValidString(getPrice(customerDetailResponseModel.customerDetails!.creditLimit.toString())),
                              style: const TextStyle(fontWeight: FontWeight.w600, color: white,fontSize: 14)),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 22, top: 5, ),
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
                          padding: const EdgeInsets.only(left: 22, top: 20, ),
                          child: Text("${checkValidString(customerDetailResponseModel.customerDetails!.billCreditPeriod.toString())}",
                              style: TextStyle(fontWeight: FontWeight.w600, color: white,fontSize: 14)),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 22, top: 5, ),
                          child: const Text("Limit Period",
                              style: TextStyle(fontWeight: FontWeight.w400, color: white,fontSize: 14)),
                        ),
                      ],
                    ) :
                    Container(),
                    customerDetailResponseModel.customerDetails!.ledgerMobile.toString().isNotEmpty ?
                    GestureDetector(
                        onTap:() {
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
                      height: 210,
                      child: Column(
                        children: [
                          Container(height: 80, color: kBlue),
                          Container(
                            height: 130,
                            color: kLightestPurple,
                            child: Container(
                            margin: const EdgeInsets.only(top: 70, bottom: 10, left: 10, right: 10),
                            child: TabBar(
                              controller: _tabController,
                              indicatorColor: kBlue,
                              labelColor: kBlue,
                              unselectedLabelColor: kBlue,
                              tabs:  const [
                                Tab(text: 'Transactions', ),
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
          Expanded(
            child: TabBarView(
              dragStartBehavior: DragStartBehavior.down,
              controller: _tabController,
              children: [
                CustomerTransactionListPage(customerDetailResponseModel.customerDetails),
                CustomerSalesHistoryListPage(customerDetailResponseModel.customerDetails),
              ],
            ),
          ),
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
      'customer_id': (widget as CustomerDetailPage).getSet.customerId.toString().trim(),
      'from_app' : FROM_APP,
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CustomerDetailResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      customerDetailResponseModel = dataResponse;
      totalSale = dataResponse.totalSale.toString();
      totalOverdue = dataResponse.totalOverdue.toString();

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