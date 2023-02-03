import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/color.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class AddPaymentDetailPage extends StatefulWidget {
  const AddPaymentDetailPage({Key? key}) : super(key: key);

  @override
  _AddPaymentDetailPageState createState() => _AddPaymentDetailPageState();
}

class _AddPaymentDetailPageState extends BaseState<AddPaymentDetailPage> {
  bool _isLoading = false;

  TextEditingController _transactionController = TextEditingController();
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _paymentTypeController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  FocusNode inputNode = FocusNode();
  bool _passwordVisible = true;

  @override
  void initState() {
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
                      Container(
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
                            String transaction = _transactionController.text.toString();
                            String customerName = _customerNameController.text.toString();
                            String paymentType = _paymentTypeController.text.toString();
                            String amount = _amountController.text.toString();

                            if (transaction.trim().isEmpty) {
                              showSnackBar("Please enter a transaction id", context);
                            } else if (customerName.trim().isEmpty) {
                              showSnackBar("Please enter a customer Name", context);
                            } else if(paymentType.isEmpty) {
                              showSnackBar('Please enter payment type',context);
                            } else if (amount.trim().isEmpty) {
                              showToast("Please enter amount");
                            } else {
                              if(isInternetConnected) {
                                Navigator.pop(context);
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

}