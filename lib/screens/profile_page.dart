import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/screens/edit_profile_page.dart';
import 'package:salesapp/screens/login_page.dart';

import '../constant/color.dart';
import '../constant/font.dart';
import '../model/profile_detail_response_model.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../utils/session_manager_methods.dart';
import '../widget/app_bar.dart';
import '../widget/loading.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  bool _isLoading = false;

  FocusNode inputNode = FocusNode();

  var totalCustomerCount;
  var incetive;
  var outstanding;
  var totalSales;

  @override
  void initState() {
    super.initState();

    if(isInternetConnected) {
      _profileDetailRequest();
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
            toolbarHeight: 55,
            automaticallyImplyLeading: false,
            title: const AppBarWidget(pageName: ""),
            centerTitle: false,
            elevation: 0,
            backgroundColor: appBG,
          ),
          body: _isLoading ? const LoadingWidget()
              : Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: kLightestPurple,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kLightPurple)

              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top:20),
                      child: cardProfileImage(),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top:20),
                      child: Text(sessionManager.getName().toString(),
                          style: const TextStyle(fontWeight: FontWeight.w700, color: kBlue, fontSize: 20)),
                    ),
                    Container(
                      width: 160,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 30, bottom: 20),
                      padding: const EdgeInsets.all(8),
                      // width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kLightGradient, kDarkGradient],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/ic_customer_employee.png', color:white, height: 20, width: 20,),
                          Gap(8),
                          Text("Customer: $totalCustomerCount",
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: white, fontFamily: kFontNameRubikBold),),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Gap(10),
                          Column(
                            children: [
                              const Text("Total Orders",
                                  style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 14, fontFamily: kFontNameRubikBold)),
                              const Gap(3),
                              Text(sessionManagerMethod.getTotalOrders().toString().isNotEmpty
                                  ? getPrice(sessionManagerMethod.getTotalOrders().toString()) : "-",
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 14))
                            ],
                          ),
/*                          Column(
                            children: [
                              Text("Incentive",
                                  style: const TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 14)),
                              Gap(3),
                              Text(getPrice(incetive),
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 14))
                            ],
                          ),*/
                          const VerticalDivider(
                            color: kGray,
                            width: 1,
                            thickness: 1,
                          ),
                          Column(
                            children: [
                              const Text("Total Sales",
                                  style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 14)),
                              const Gap(3),
                              Text(getPrice(totalSales),
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 14, fontFamily: kFontNameRubikBold))
                            ],
                          ),
            /*              Column(
                            children: [
                              const Text("Outstanding",
                                  style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 14)),
                              const Gap(3),
                              Text(getPrice(outstanding),
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 14))
                            ],
                          ),*/
                          const VerticalDivider(
                            color: kGray,
                            width: 1,
                            thickness: 1,
                          ),
                          Column(
                            children: [
                              const Text("Overdues",
                                  style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 14)),
                              const Gap(3),
                              Text(sessionManagerMethod.getOverdues().toString().isNotEmpty
                                  ? getPrice(sessionManagerMethod.getOverdues().toString()) : "-",
                                  style: const TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 14, fontFamily: kFontNameRubikBold))
                            ],
                          ),
                          const Gap(10),
                        ],
                      ),
                    ),
                    const Gap(10),
                    const Divider(indent: 8, endIndent: 8, color: kBlue, height: 1,),
                    const Gap(25),
                    Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/ic_settings.png', height: 40, width: 40,)),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: const Text("Settings",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black),),
                        ),
                        const Spacer(),
                        Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(right: 10),
                            child: Image.asset('assets/images/ic_right_arrow.png', height: 16, width: 16,)),
                      ],
                    ),
                    const Gap(25),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/ic_notification.png', height: 40, width: 40,)),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: const Text("Notification",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black),),
                        ),
                        const Spacer(),
                        Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(right: 10),
                            child: Image.asset('assets/images/ic_right_arrow.png', height: 16, width: 16,)),
                      ],
                    ),
                    const Gap(25),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/ic_information.png', height: 40, width: 40,)),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: const Text("Information",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black),),
                        ),
                        const Spacer(),
                        Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(right: 10),
                            child: Image.asset('assets/images/ic_right_arrow.png', height: 16, width: 16,)),
                      ],
                    ),
                    Gap(25),
                    GestureDetector(
                      onTap: () {
                        logoutFromApp();
                      },
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 10, right: 10),
                              child: Image.asset('assets/images/ic_logout.png', height: 40, width: 40,)),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            child: const Text("Logout",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black),),
                          ),
                          const Spacer(),
                          Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset('assets/images/ic_right_arrow.png', height: 16, width: 16,)),
                        ],
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

  void logoutFromApp() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  color: white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 40,
                    alignment: Alignment.center,
                    color: kBlue,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text('Logout from Sales App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: black))
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: const Text('Are you sure you want to logout from app?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.4, color: kBlue),
                                borderRadius: BorderRadius.all(Radius.circular(kButtonCornerRadius)),
                              ),
                              margin: const EdgeInsets.only(right: 10),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:const Text('No', style:TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kBlue,))
                              ),
                            ),
                          ),
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kButtonCornerRadius),
                                color:kBlue,
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  SessionManagerMethods.clear();
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (Route<dynamic> route) => false);
                                },
                                child:
                                const Text('Yes',style:TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is ProfilePage;
  }

  Widget cardProfileImage() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () {
          _redirectToProfile(context);

        },
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape:const CircleBorder(
            side: BorderSide(
              color: kBlue,//Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Container(
            color: Colors.white,
            width: 120,
            height: 120,
            child: sessionManager.getProfilePic().toString().isNotEmpty ?
            FadeInImage.assetNetwork(
              image: sessionManager.getProfilePic().toString(),
              fit: BoxFit.cover,
              placeholder: 'assets/images/img_user_placeholder.png',
            ) :
            Image.asset('assets/images/img_user_placeholder.png', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Future<void> _redirectToProfile(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );

    print("result ===== $result");

    if (result == "success") {
      _profileDetailRequest();
      setState(() {
      });
    }
  }

  //API call function...
  _profileDetailRequest() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + profileDetail);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'emp_id' : sessionManager.getEmpId().toString().trim()
    };

    final response = await http.post(url, body: jsonBody);

    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = ProfileDetailResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      setState(() {
        _isLoading = false;

        sessionManager.setEmpId(checkValidString(dataResponse.employeeDetails?.empId));
        sessionManager.setEmpName(checkValidString(dataResponse.employeeDetails?.empName));
        sessionManager.setEmpPhone(checkValidString(dataResponse.employeeDetails?.empPhone));
        sessionManager.setEmail(checkValidString(dataResponse.employeeDetails?.empEmail));
        sessionManager.setProfilePic(checkValidString(dataResponse.employeeDetails?.profile));
        sessionManager.setParentId(checkValidString(dataResponse.employeeDetails?.parent));

        totalCustomerCount = checkValidString(dataResponse.employeeDetails?.totalCustomers);
        // incetive = checkValidString(dataResponse.employeeDetails?.incentive);
        outstanding = checkValidString(dataResponse.employeeDetails?.outstanding);
        totalSales = checkValidString(dataResponse.employeeDetails?.totalSales);
      });

      setState(() {
        _isLoading = false;
      });

    }else {
      setState(() {
        _isLoading = false;
      });
    }

  }
}