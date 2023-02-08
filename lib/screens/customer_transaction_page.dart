import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:salesapp/model/customer_detail_response_model.dart';
import 'package:salesapp/screens/transaction_detail_page.dart';

import '../constant/color.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/no_data.dart';

class CustomerTransactionListPage extends StatefulWidget {
  final CustomerDetails? dataGetSet;

  const CustomerTransactionListPage(this.dataGetSet, {Key? key}) : super(key: key);

  @override
  _CustomerTransactionListPageState createState() => _CustomerTransactionListPageState();
}

class _CustomerTransactionListPageState extends BaseState<CustomerTransactionListPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    CustomerDetails? dataGetSet = (widget as CustomerTransactionListPage).dataGetSet;
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
        body: dataGetSet!.customerTransection!.isNotEmpty
            ? Container(
          color: white,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              itemCount: dataGetSet?.customerTransection!.length,
              itemBuilder: (ctx, index) => Container(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailPage(checkValidString(dataGetSet?.customerTransection![index].id).toString())));

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
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Transaction Mode : ',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black),
                                  children: <TextSpan>[
                                    TextSpan(text: checkValidString(dataGetSet?.customerTransection![index].transectionMode).toString(),
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: black),
                                        recognizer: TapGestureRecognizer()..onTap = () => {
                                        }),
                                  ],
                                ),
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
                                    TextSpan(text: checkValidString(dataGetSet?.customerTransection![index].transectionAmount).toString(),
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: black),
                                        recognizer: TapGestureRecognizer()..onTap = () => {
                                        }),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.only(left: 10, top: 6),
                          child: Text(checkValidString(dataGetSet?.customerTransection![index].transectionDate).toString(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 13, color: kGray, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                            height: index == dataGetSet!.customerTransection!.length-1 ? 0 : 0.8, color: kLightPurple),
                      ],
                    )
                  ),
                ),
              )),
        )
        : MyNoDataWidget(msg: "", subMsg: "No transaction history found",),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is CustomerTransactionListPage;
  }


}