import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/common_response_model.dart';
import 'package:salesapp/model/customer_detail_response_model.dart';

import '../constant/color.dart';
import '../model/order_detail_response_model.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class AddPaymentDetailPage extends StatefulWidget {
  final Order dataGetSet;
  const AddPaymentDetailPage(this.dataGetSet, {Key? key}) : super(key: key);

  @override
  _AddPaymentDetailPageState createState() => _AddPaymentDetailPageState();
}

class _AddPaymentDetailPageState extends BaseState<AddPaymentDetailPage> {
  bool _isLoading = false;

  TextEditingController _transactionController = TextEditingController();
  TextEditingController _transactionModeController = TextEditingController();
  TextEditingController _paymentTypeController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  FocusNode inputNode = FocusNode();
  Order? dataGetSet;

  @override
  void initState() {

    dataGetSet = (widget as AddPaymentDetailPage).dataGetSet;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 55,
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
        elevation: 0,
        backgroundColor: kBlue,
      ),
      body: _isLoading ? const LoadingWidget()
          : LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        color: kBlue,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 22, top: 10, bottom: 15),
                        child: const Text("Add Payment Details",
                            style: TextStyle(fontWeight: FontWeight.w700, color: white, fontSize: 20)),
                      ),
                      /*Container(
                        margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _transactionController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Transaction',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),*/
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _transactionModeController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Transaction Mode',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _paymentTypeController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Payment Type',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _amountController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Amount',
                              counterText: '',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 10, left: 20, right: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kLightGradient, kDarkGradient],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            // String transaction = _transactionController.text.toString();
                            String transactionMode = _transactionModeController.text.toString();
                            String paymentType = _paymentTypeController.text.toString();
                            String amount = _amountController.text.toString();

                            /*if (transaction.trim().isEmpty) {
                              showSnackBar("Please enter a transaction id", context);
                            } else*/
                              if (transactionMode.trim().isEmpty) {
                              showSnackBar("Please enter a transaction mode", context);
                            } else if(paymentType.isEmpty) {
                              showSnackBar('Please enter payment type',context);
                            } else if (amount.trim().isEmpty) {
                              showToast("Please enter amount");
                            } else {
                              if(isInternetConnected) {
                                _saveTransaction();
                              }else{
                                noInterNet(context);
                              }
                            }
                          },
                          child: const Text("Submit",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white),),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is AddPaymentDetailPage;
  }

  void _saveTransaction() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + saveTransaction);

    Map<String, String> jsonBody = {
      'order_id': dataGetSet!.orderId!.toString(),
      'emp_id': sessionManager.getEmpId().toString().trim(),
      'customer_id': dataGetSet!.customerId!.toString(),
      'transection_amount':_amountController.value.text.trim(),
      'transection_mode': _transactionModeController.value.text.trim(),
      'transection_type':_paymentTypeController.value.text.trim(),
      'transection_status': '',
      'transection_date':'',
      "from_app": FROM_APP,
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context, "success");

    }else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(dataResponse.message, context);
    }
  }

}