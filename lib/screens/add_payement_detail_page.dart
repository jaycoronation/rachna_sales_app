import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/common_response_model.dart';

import '../constant/color.dart';
import '../model/order_detail_response_model.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class AddPaymentDetailPage extends StatefulWidget {
  final Order dataGetSet;
  final String orderId;
  final String customerId;
  final String customerName;
  const AddPaymentDetailPage(this.dataGetSet, this.orderId, this.customerId, this.customerName, {Key? key}) : super(key: key);

  @override
  _AddPaymentDetailPageState createState() => _AddPaymentDetailPageState();
}

class _AddPaymentDetailPageState extends BaseState<AddPaymentDetailPage> {
  bool _isLoading = false;

  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _transactionModeController = TextEditingController();
  // TextEditingController _paymentTypeController = TextEditingController();
  TextEditingController _transactionIdController = TextEditingController();

  FocusNode inputNode = FocusNode();
  Order? dataGetSet;

  String orderId = "";
  String customerId = "";

  bool isTransactionId = false;

  var listPaymentModes = ["Cash", "NEFT", "Net Banking", "UPI", "Cheque", "Debit Card", "Credit Card", "Google Pay", "Paytm"];

  @override
  void initState() {

    dataGetSet = (widget as AddPaymentDetailPage).dataGetSet;
    orderId = checkValidString((widget as AddPaymentDetailPage).orderId).toString();
    // print("orderId--->" + orderId);
    customerId = checkValidString((widget as AddPaymentDetailPage).customerId).toString();

    _customerNameController.text = checkValidString((widget as AddPaymentDetailPage).customerName).toString();;
    // print("customerId--->" + customerId);
    print("--------------");
    print(isTransactionId);
    print("--------------");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _customerNameController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Customer Name',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Payment Amount',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _transactionModeController,
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          onTap: () {
                            _showTransactionModeDialog();
                          },
                          decoration: const InputDecoration(
                              labelText: 'Transaction Mode',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                         /* onChanged: (value) {
                            setState(() {
                              print("==============");
                              print(value);
                              print("==============");
                              print(isTransactionId);
                              print("==============");

                              if (value == "Cash") {
                                isTransactionId = true;
                              }else {
                                isTransactionId = false;
                              }

                            });

                          },*/
                        ),
                      ),
                      /*Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _paymentTypeController,
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Payment Type',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                          onTap: () {
                            showPayementTypeActionDialog();
                          },
                        ),
                      ),*/
                      // Visibility(
                      //   visible: isTransactionId,
                      //   child:
                        Container(
                          margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                          child: TextField(
                            cursorColor: black,
                            controller: _transactionIdController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                            decoration: const InputDecoration(
                                labelText: 'Transaction Id',
                                prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                            ),
                          ),
                        ),
                      // ),
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
                            String customerName = _customerNameController.text.toString();
                            String amount = _amountController.text.toString();
                            String transactionMode = _transactionModeController.text.toString();
                            // String paymentType = _paymentTypeController.text.toString();
                            String transactionId = _transactionIdController.text.toString();

                            if (customerName.trim().isEmpty) {
                              showSnackBar("Please enter a customer name", context);
                            } else if (amount.trim().isEmpty) {
                              showToast("Please enter amount");
                            } else if (transactionMode.trim().isEmpty) {
                              showSnackBar("Please select a transaction mode", context);
                           /* } else if(paymentType.isEmpty) {
                              showSnackBar('Please select payment type',context);*/
                            } else if (transactionMode != "Cash" && transactionId.trim().isEmpty) {
                                showSnackBar("Please enter a transaction id", context);
                              
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

  void _showTransactionModeDialog() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
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
                          child: const Text("Payment Type", style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        Container(height: 6),
                        Expanded(child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                  itemCount: listPaymentModes.length,
                                  shrinkWrap: true,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _transactionModeController.text = checkValidString(listPaymentModes[index]);


                                              if (_transactionModeController.text.toString() == "Cash") {
                                                isTransactionId = true;
                                              }else {
                                                isTransactionId = false;
                                              }

                                              print("==============");
                                              print(_transactionModeController.text);
                                              print("==============");
                                              print(isTransactionId);
                                              print("==============");
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                            alignment: Alignment.centerLeft,
                                            child: listPaymentModes[index] == _transactionModeController.text.toString()
                                                ? Text(
                                              checkValidString(listPaymentModes[index]),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kBlue),
                                            )
                                                : Text(
                                              checkValidString(listPaymentModes[index]),
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

  /*void showPayementTypeActionDialog() {
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
                    const Text("Payment Type",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        _paymentTypeController.text = "Credit";
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Credit",
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
                        _paymentTypeController.text = "Debit";

                      },
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        child: const Text(
                          "Debit",
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
  }*/

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
      'order_id': orderId.isNotEmpty ? orderId : checkValidString(dataGetSet?.orderId).toString(),
      'emp_id': sessionManager.getEmpId().toString().trim(),
      'customer_id': customerId.isNotEmpty ? customerId : checkValidString(dataGetSet?.customerId).toString(),
      'transection_amount':_amountController.value.text.trim(),
      'transection_mode': _transactionModeController.value.text.trim(),
      'transection_type': 'credit', //_paymentTypeController.value.text.trim(),
      'transection_status': '',
      'transection_date':'',
      'transection_id' : _transactionIdController.value.text.trim(),
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