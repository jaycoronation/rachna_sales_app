import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../Model/login_with_otp_response_model.dart';
import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class DailyPlansPage extends StatefulWidget {
  const DailyPlansPage({Key? key}) : super(key: key);

  @override
  _DailyPlansPageState createState() => _DailyPlansPageState();
}

class _DailyPlansPageState extends BaseState<DailyPlansPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if(isInternetConnected) {
      // _makeCallRequestOtp();
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
                  child: const Icon(Icons.calendar_today_outlined, color: white, size: 22,),
                ),
              ),
            ],
            centerTitle: false,
            elevation: 0,
            backgroundColor: kBlue,
          ),
          body: _isLoading ? const LoadingWidget()
              : Column(
                children: [
                  Container(
                    color: kBlue,
                    child: Column(
                      children: [
                        Container(
                          color: kBlue,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 22, top: 10, bottom: 20),
                          child: const Text("Daily Plans", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: 8,
                      itemBuilder: (ctx, index) => Container(
                        color: white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                          child: GestureDetector(
                            onTap: () {
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Gap(10),
                                        Stack(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 10),
                                              decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [kLightGradient, kDarkGradient],
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius: BorderRadius.circular(22)
                                              ),
                                              width: 35,
                                              height: 35,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(right: 3, left: 6, top: 13),
                                                  child: const Text("15",
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 13, color: white, fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(right: 3, left: 6, bottom: 3),
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
                                          margin: const EdgeInsets.only(left: 10, top: 6),
                                          alignment: Alignment.center,
                                          child: const Text("Hyatt Hotel",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10, top: 6),
                                      child: const Text("11:15AM - 1:00PM",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 12, color: kGray, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                    height: index == 8-1 ? 0 : 0.8, color: kLightPurple),
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is DailyPlansPage;
  }

  //API call function...
  _getDailyPlansList(String contactNum) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + loginWithOTP);

    Map<String, String> jsonBody = {
      'phone': contactNum.toString().trim(),
      'from_app' : FROM_APP
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = LoginWithOtpResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);

    }else {
      showSnackBar(dataResponse.message, context);
    }

  }

}