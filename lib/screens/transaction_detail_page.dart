import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/model/order_detail_response_model.dart';
import 'package:salesapp/model/transaction_detail_response_model.dart';

import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import 'add_payement_detail_page.dart';

class TransactionDetailPage extends StatefulWidget {
  final String transactionId;
  const TransactionDetailPage(this.transactionId, {Key? key}) : super(key: key);

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends BaseState<TransactionDetailPage> {
  bool _isLoading = false;

  TransactionDetailResponseModel transactionDetailResponseModel = TransactionDetailResponseModel();

  @override
  void initState() {
    super.initState();

    if(isInternetConnected) {
      _makeCallTransactionDetail();
    }else {
      noInterNet(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: appBG,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            title: const Text("Transaction Detail",
                style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
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
          body: _isLoading ? const LoadingWidget()
              : SingleChildScrollView(
            child: Column(
              children: [
                /*Container(
                  color: kBlue,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                  child: const Text("Transaction Detail", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
                ),*/
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 22, top: 20, bottom: 10),
                      child: const Text("Transaction Id :", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(right: 22, left: 10, bottom: 10, top: 20,),
                      child: Text(transactionDetailResponseModel.transectionDetails!.transectionId.toString().isNotEmpty
                          ? checkValidString(transactionDetailResponseModel.transectionDetails!.transectionId.toString())
                          : "-",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                      child: const Text("Transaction Mode :", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(right: 22, left: 10, top: 10,bottom: 10),
                      child: Text(transactionDetailResponseModel.transectionDetails!.transectionMode.toString().isNotEmpty
                          ? checkValidString(transactionDetailResponseModel.transectionDetails!.transectionMode).toString()
                          : "-",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 22, top: 10, bottom: 20),
                      child: const Text("Transaction Amount", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(right: 22, left: 10, top: 10, bottom: 20),
                      child: Text(transactionDetailResponseModel.transectionDetails!.transectionAmount.toString().isNotEmpty
                          ? checkValidString(getPrice(transactionDetailResponseModel.transectionDetails!.transectionAmount.toString()))
                          : "-",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                    ),
                  ],
                ),
                const Divider(indent: 8, endIndent: 8, color: kBlue, height: 2),
                Visibility(
                  visible: transactionDetailResponseModel.transectionDetails!.orderDetails!.orderNumber.toString().isNotEmpty,
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                          child: const Text("Order Detail",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kBlue),)
                      ),
                      const Divider(indent: 8, endIndent: 8, color: kBlue, height: 2),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 22, top: 10, bottom: 20),
                            child: const Text("Order Number", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(right: 22, left: 10, top: 10, bottom: 20),
                            child: Text(transactionDetailResponseModel.transectionDetails!.orderDetails!.orderNumber.toString().isNotEmpty
                                ? checkValidString(transactionDetailResponseModel.transectionDetails!.orderDetails!.orderNumber.toString())
                                : "-",
                                style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                          ),
                        ],
                      ),
                      const Divider(indent: 8, endIndent: 8, color: kBlue, height: 2),
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                    child: const Text("Employee Detail",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kBlue),)
                ),
                const Divider(indent: 8, endIndent: 8, color: kBlue, height: 2),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                      child: const Text("Employee Name :", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(right: 22, left: 10, top: 10, bottom: 10),
                      child: Text(transactionDetailResponseModel.transectionDetails!.employeeDetails!.empName.toString().isNotEmpty
                          ? checkValidString(transactionDetailResponseModel.transectionDetails!.employeeDetails!.empName.toString())
                          : "-",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                      child: const Text("Employee Phone No. : ", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(right: 22, left: 10,top: 10, bottom: 10),
                      child: Text(transactionDetailResponseModel.transectionDetails!.employeeDetails!.empPhone.toString().isNotEmpty
                          ? checkValidString(transactionDetailResponseModel.transectionDetails!.employeeDetails!.empPhone.toString())
                          : "-",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                      child: const Text("Employee Email : ", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(right: 22, left: 10,top: 10, bottom: 10),
                      child: Text(transactionDetailResponseModel.transectionDetails!.employeeDetails!.empEmail.toString().isNotEmpty
                          ? checkValidString(transactionDetailResponseModel.transectionDetails!.employeeDetails!.empEmail.toString())
                          : "-",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                    ),
                  ],
                ),
                const Divider(indent: 8, endIndent: 8, color: kBlue, height: 2),
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                    child: const Text("Customer Detail",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kBlue),)
                ),
                const Divider(indent: 8, endIndent: 8, color: kBlue, height: 2),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 22, top: 10, bottom: 20),
                      child: const Text("Customer Name : ", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(right: 22, left: 10, top: 10, bottom: 20),
                        child: Text(transactionDetailResponseModel.transectionDetails!.customerDetails!.customerName.toString().isNotEmpty
                            ? checkValidString(transactionDetailResponseModel.transectionDetails!.customerDetails!.customerName.toString())
                            : "-",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

      ),

    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is TransactionDetailPage;
  }

  Future<void> _redirectToTransaction(BuildContext context, Order getSet) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentDetailPage(getSet, "", "", "", "", false)),
    );

    print("result ===== $result");

    if (result == "success") {
      setState(() {
      });
    }
  }

  //API call function...
  _makeCallTransactionDetail() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + transactionDetail);

    Map<String, String> jsonBody = {
      'from_app' : FROM_APP,
      'id': checkValidString((widget as TransactionDetailPage).transactionId).toString()
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = TransactionDetailResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      transactionDetailResponseModel = dataResponse;

      setState(() {
        _isLoading = false;
      });
    }else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
      });
    }

  }

}