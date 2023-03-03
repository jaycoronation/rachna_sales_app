import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/verify_otp_response_model.dart';
import 'package:salesapp/screens/tabs/bottom_tab_navigation.dart';
import 'package:salesapp/screens/tabs/tabnavigation.dart';

import '../Model/login_with_otp_response_model.dart';
import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/app_bar.dart';
import '../widget/loading.dart';

class VerifyOTPPage extends StatefulWidget {
  final String strMobileNo;
  const VerifyOTPPage({Key? key, required this.strMobileNo}) : super(key: key);

  @override
  _VerifyOTPPageState createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends BaseState<VerifyOTPPage> {
  bool _isLoading = false;
  int _start = 60;
  late Timer _timer;
  FocusNode inputNode = FocusNode();

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    startTimer();
    super.initState();

    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(inputNode);
    });

    if(isInternetConnected) {
      _makeCallRequestOtp((widget as VerifyOTPPage).strMobileNo);
    }else {
      noInterNet(context);
    }

  }

  @override
  void dispose() {
    _timer.cancel();
    inputNode.dispose();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var contactNum = (widget as VerifyOTPPage).strMobileNo;
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
          toolbarHeight: 55,
          automaticallyImplyLeading: false,
          title: const AppBarWidget(pageName: ""),
          centerTitle: false,
          elevation: 0,
          backgroundColor: appBG,
        ),
        body: _isLoading ? const LoadingWidget()
            : LayoutBuilder(
            builder: (context, constraints){
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top:20),
                            child: const Text("OTP Verification",
                                style:  TextStyle(fontWeight: FontWeight.w700, color: black,fontSize: 20)),
                          ),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(top: 8, right: 5),
                                child:RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'Code sent on',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: black),
                                    children: <TextSpan>[
                                      TextSpan(text: ' +91${(widget as VerifyOTPPage).strMobileNo}',
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: kBlue),
                                          recognizer: TapGestureRecognizer()..onTap = () => {
                                        Navigator.pop(context)
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Image.asset("assets/images/ic_edit_pen.png", height: 16, width:18,)
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 60),
                            child: TextField(
                              cursorColor: black,
                              focusNode: inputNode,
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              obscureText: true,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                              decoration: const InputDecoration(
                                  labelText: 'Enter OTP',
                                  counterText: '',
                                  prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter. digitsOnly
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 40, bottom: 10),
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
                                if(textEditingController.text.isEmpty) {
                                  showSnackBar("Please enter OTP", context);
                                }else if (textEditingController.text.length !=4) {
                                  showSnackBar("Please enter 4 digit OTP", context);
                                }else {
                                  if(isInternetConnected) {
                                    _makeCallVerifyOtp();
                                  }else{
                                    noInterNet(context);
                                  }
                                }
                              },
                              child: const Text("Verify & Continue",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white),),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 30),
                                  child:RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: "Didn't receive code?",
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: black),
                                      children: <TextSpan>[
                                        TextSpan(text: ' Resend OTP',
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: black),
                                            recognizer: TapGestureRecognizer()..onTap = () => {
                                            FocusScope.of(context).requestFocus(FocusNode()),
                                            setState(() {
                                              _start = 60;
                                              startTimer();

                                              if(isInternetConnected) {
                                                _makeCallRequestOtp((widget as VerifyOTPPage).strMobileNo);
                                              }else {
                                                noInterNet(context);
                                              }
                                             })
                                          }),
                                      ],
                                    ),
                                  ),
                              ),
                              const Spacer(),
                              Container(
                                  alignment: Alignment.bottomRight,
                                  margin: const EdgeInsets.only(bottom: 30),
                                  child: Text("00:$_start",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 14))
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
      ),
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is VerifyOTPPage;
  }

  //API call function...
  void _makeCallRequestOtp(String contactNum) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + loginWithOTP);

    Map<String, String> jsonBody = {
      'phone': contactNum.toString().trim(),
      'from_app': FROM_APP
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

  void _makeCallVerifyOtp() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + verifyOTP);

    Map<String, String> jsonBody = {
      "phone": (widget as VerifyOTPPage).strMobileNo,
      "otp": textEditingController.value.text.toString().trim(),
      "from_app": FROM_APP,
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = VerifyOtpResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      setState(() {
        _isLoading = false;
      });

      // sessionManager.setProfilePic(checkValidString(dataResponse.employeeDetails?.profile));
      await sessionManager.createLoginSession(dataResponse.user!.userId.toString(), dataResponse.user!.name.toString(), dataResponse.user!.empPhone.toString(),
          dataResponse.user!.email.toString(), "");

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomTabNavigation(0)), (Route<dynamic> route) => false);

    }else {
      setState(() {
        _isLoading = false;
      });
      textEditingController.clear();
      showSnackBar(dataResponse.message, context);
    }
  }

}