
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salesapp/screens/verify_otp_page.dart';

import '../constant/color.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> {
  bool _isLoading = false;
  TextEditingController _phoneNumController = TextEditingController();
  FocusNode inputNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      body: _isLoading ? const LoadingWidget()
          : LayoutBuilder(
          builder: (context, constraints) {
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
                          margin: const EdgeInsets.only(top:80),
                          child: const Text("Login with OTP",
                              style: TextStyle(fontWeight: FontWeight.w700, color: black, fontSize: 20)),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(top: 8),
                          child:RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Enter mobile no to',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: black),
                              children: <TextSpan>[
                                TextSpan(text: ' Create Account', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: kBlue),
                                    recognizer: TapGestureRecognizer()..onTap = () => {
                                    }),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 60),
                          child: TextField(
                            cursorColor: black,
                            focusNode: inputNode,
                            controller: _phoneNumController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                            decoration: const InputDecoration(
                                labelText: 'Enter Mobile No',
                                prefixText: '+91  ',
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
                              String phone = _phoneNumController.text.toString();

                              if(phone.isEmpty) {
                                showSnackBar('Please enter phone number',context);
                              }else if (phone.length != 10) {
                                showSnackBar('Please enter valid phone number',context);
                              }else {
                                if(isInternetConnected) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOTPPage(strMobileNo: _phoneNumController.value.text)));
                                }else{
                                  noInterNet(context);
                                }
                              }
                            },
                            child: const Text("Continue",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white),),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom:30),
                          child: const Text("We will send you one time password(OTP)",
                              style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 14)),
                        ),
                      ],
                    ),
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
    widget is LoginPage;
  }

}