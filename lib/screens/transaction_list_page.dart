import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../Model/login_with_otp_response_model.dart';
import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends BaseState<TransactionListPage> {
  bool _isLoading = false;
  TextEditingController searchController = TextEditingController();
  var searchText = "";

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
                height: 35,
                width: 35,
                alignment: Alignment.center,
                child: const Icon(Icons.calendar_today_outlined, color: white, size: 22,),
              ),
            ),
            GestureDetector(
              onTap: () {

              },
              child: Container(
                height: 45,
                width: 45,
                alignment: Alignment.center,
                child: const Icon(Icons.picture_as_pdf, color: white, size: 22,),
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
                    padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                    child: const Text("Transaction", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 50,
                        margin:  const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: kLightPurple),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            color: white,
                            shape: BoxShape.rectangle
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(left: 12, top:15, bottom: 15),
                                    child: const Icon(Icons.calendar_today_outlined, color: kBlue, size: 18,)),
                                Container(
                                  margin: const EdgeInsets.only(left: 8, top:15, bottom: 15),
                                  child: const Text("Start Date",
                                      style: TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 13)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(width: 0.8, color: kBlue, height: 50,),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top:15, bottom: 15),
                                    child: const Icon(Icons.calendar_today_outlined, color: kBlue, size: 18,)),
                                Container(
                                  margin: const EdgeInsets.only(left: 8, top:15, bottom: 15),
                                  child: const Text("End Date", style: TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 13)
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ],
                  )

                ],
              ),
            ),
            Container(
              color: kLightestPurple,
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(width: 1, color: kLightPurple),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          shape: BoxShape.rectangle
                      ),
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textAlign: TextAlign.start,
                        controller: searchController,
                        cursorColor: black,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: black,),
                        decoration: InputDecoration(
                            hintText: "Search Entries",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: kLightPurple, width: 0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: kLightPurple, width: 0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: kBlue,
                                fontSize: 14
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 26,
                              color: kBlue,
                            )
                        ),
                        onChanged: (text) {
                          searchController.text = text;
                          searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                          if(text.isEmpty)
                          {
                            searchText = "";
                            //_getAllProduct(false,true);
                          }
                          else if(text.length > 3)
                          {
                            searchText = searchController.text.toString().trim();
                            //_getAllProduct(false,true);
                          }
                        },
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 25, bottom: 15),
                        alignment: Alignment.center,
                        child: const Text("Net Balance",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: kBlue, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 25, top: 6, bottom: 15),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '₹ ',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kBlue),
                            children: <TextSpan>[
                              TextSpan(text: "8000",
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kBlue),
                                  recognizer: TapGestureRecognizer()..onTap = () => {
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (ctx, index) => InkWell(
                    hoverColor: Colors.white.withOpacity(0.0),
                    onTap: () async {},
                    child: Container(
                      color: white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 3),
                        child: GestureDetector(
                          onTap: () {
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 8, top: 6),
                                    alignment: Alignment.center,
                                    child: const Text("Ramada Hotel",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 8, top: 6),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: '₹ ',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: black),
                                        children: <TextSpan>[
                                          TextSpan(text: "2000",
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: black),
                                              recognizer: TapGestureRecognizer()..onTap = () => {
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.bottomLeft,
                                margin: const EdgeInsets.only(left: 10, top: 6),
                                child: const Text("07:15 pm, 14 May 2022",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 13, color: kGray, fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                  height: index == 8-1 ? 0 : 0.8, color: kLightPurple),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is TransactionListPage;
  }

  //API call function...
  _makeCallRequestOtp(String contactNum) async {
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