import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/model/daily_plan_detail_response_model.dart';
import 'package:salesapp/model/order_detail_response_model.dart';
import 'package:salesapp/model/transaction_detail_response_model.dart';
import 'package:salesapp/screens/add_daily_plan_page.dart';

import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class PlanDetailPage extends StatefulWidget {
  final String planId;
  const PlanDetailPage(this.planId, {Key? key}) : super(key: key);

  @override
  _PlanDetailPageState createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends BaseState<PlanDetailPage> {
  bool _isLoading = false;

  DailyPlanDetailResponseModel dailyPlanDetailResponseModel = DailyPlanDetailResponseModel();

  @override
  void initState() {
    super.initState();

    if(isInternetConnected) {
      _makeCallPlanDetail();
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
          title: const Text("Plan Detail",
              style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
          leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
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
             /* Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(flex: 2,
                    child:  Text("SKU",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                    ),),
                  const Text(" : ",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                  ),
                  Expanded(flex: 4,
                    child:  Text("${productData.sku}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                    ),)
                ],
              )*/
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 22, top: 20, bottom: 10),
                      child: const Text("Customer Name", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    child: const Text(" : ",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(right: 22, left: 10, bottom: 10, top: 20,),
                      child: Text(dailyPlanDetailResponseModel.dailyPlanDetails!.customer!.customerName.toString().isNotEmpty
                          ? checkValidString(dailyPlanDetailResponseModel.dailyPlanDetails!.customer!.customerName.toString())
                          : "-",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                      child: const Text("Plan Date", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Text(" : ",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(right: 22, left: 10, top: 10, bottom: 10),
                      child: Text(dailyPlanDetailResponseModel.dailyPlanDetails!.planDate.toString().isNotEmpty
                          ? checkValidString(dailyPlanDetailResponseModel.dailyPlanDetails!.planDate!).toString()
                          : "-",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                      child: const Text("Description", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Text(" : ",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(right: 22, left: 10, top: 10, bottom: 10),
                      child: Text(dailyPlanDetailResponseModel.dailyPlanDetails!.description!.toString().isNotEmpty
                          ? checkValidString(dailyPlanDetailResponseModel.dailyPlanDetails!.description!.toString())
                          : "-",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                      child: const Text("Other", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Text(" : ",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(right: 22, left: 10, top: 10, bottom: 10),
                      child: Text(dailyPlanDetailResponseModel.dailyPlanDetails!.other!.toString().isNotEmpty
                          ? checkValidString(dailyPlanDetailResponseModel.dailyPlanDetails!.other!.toString())
                          : "-",
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
    widget is PlanDetailPage;
  }

 /* Future<void> _redirectToPlan(BuildContext context, PlanDetailPage getSet) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDailyPlanPage(getSet, "", "", "", "", false)),
    );

    print("result ===== $result");

    if (result == "success") {
      setState(() {
      });
    }
  }
*/
  //API call function...
  _makeCallPlanDetail() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + dailyPlanDetail);

    Map<String, String> jsonBody = {
      'from_app' : FROM_APP,
      'id': checkValidString((widget as PlanDetailPage).planId).toString()
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = DailyPlanDetailResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      dailyPlanDetailResponseModel = dataResponse;

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