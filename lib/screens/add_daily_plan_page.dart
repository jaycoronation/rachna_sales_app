import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/common_response_model.dart';
import 'package:salesapp/screens/select_customer_list_page.dart';

import '../Model/customer_list_response_model.dart';
import '../constant/color.dart';
import '../model/order_detail_response_model.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class AddDailyPlanPage extends StatefulWidget {

  const AddDailyPlanPage({Key? key}) : super(key: key);

  @override
  _AddDailyPlanPageState createState() => _AddDailyPlanPageState();
}

class _AddDailyPlanPageState extends BaseState<AddDailyPlanPage> {
  bool _isLoading = false;

  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _selectDateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _otherController = TextEditingController();

  var customerDetail = CustomerList();

  FocusNode inputNode = FocusNode();
  String customerId = "";

  @override
  void initState() {

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
        title: const Text("Add Plan",
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
                          readOnly: true,
                          onTap: () {
                              _redirectToAddCustomer(context, customerDetail);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _selectDateController,
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Select Date and Time',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onTap: () async {
                            datePicker(context, setState, _selectDateController);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _descriptionController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          maxLines: 4,
                          onTap: () {
                          },
                          decoration: const InputDecoration(
                              labelText: 'Description',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),

                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _otherController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Other',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
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

                            String customerName = _customerNameController.text.toString();
                            String date = _selectDateController.text.toString();
                            String description = _descriptionController.text.toString();
                            String other = _otherController.text.toString();

                            if (customerName.trim().isEmpty) {
                              showSnackBar("Please select a customer", context);
                            } else if (date.trim().isEmpty ) {
                              showSnackBar("Please select date", context);
                            } else if (description.trim().isEmpty) {
                              showSnackBar("Please enter description", context);
                            }  else {
                              if(isInternetConnected) {
                                _savePlan();
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

  datePicker(BuildContext context, setState, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: kBlue, // <-- SEE HERE
                onPrimary: white, // <-- SEE HERE
                onSurface: black, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: kBlue, // button text color
                ),
              ),
            ),
            child: child!,
          );
        }
    );

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      print(formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        controller.text = formattedDate; //set output date to TextField value.
      });

    } else {}

  }

  Future<void> _redirectToAddCustomer(BuildContext context, CustomerList customerData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectCustomerListPage(customerData)),
    );

    print("result ===== $result");
    setState(() {
      customerDetail = result;
      customerId = customerDetail.customerId.toString();
      _customerNameController.text = checkValidString(customerDetail.customerName.toString());
    });

    if (result == "success") {
      setState(() {
      });
    }
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is AddDailyPlanPage;
  }

  void _savePlan() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + savePlan);

    Map<String, String> jsonBody = {
      "from_app": FROM_APP,
      'customer_id': customerId,
      "emp_id": sessionManager.getEmpId().toString().trim(),
      "description": _descriptionController.value.text.toString().trim(),
      "other": _otherController.value.text.toString().trim(),
      "plan_date": _selectDateController.value.text.toString().trim(),
      "id": ''
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