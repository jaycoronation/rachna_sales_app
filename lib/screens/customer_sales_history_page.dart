import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:salesapp/model/customer_detail_response_model.dart';
import 'package:salesapp/screens/order_detail_page.dart';
import 'package:salesapp/widget/no_data.dart';

import '../constant/color.dart';
import '../model/order_detail_response_model.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import 'add_payement_detail_page.dart';

class CustomerSalesHistoryListPage extends StatefulWidget {
  final CustomerDetails? dataGetSet;
  final void Function(bool isFrom) callAPI;

  const CustomerSalesHistoryListPage(this.dataGetSet, this.callAPI, {Key? key}) : super(key: key);

  @override
  _CustomerSalesHistoryListPageState createState() => _CustomerSalesHistoryListPageState();
}

class _CustomerSalesHistoryListPageState extends BaseState<CustomerSalesHistoryListPage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    CustomerDetails? dataGetSet = (widget as CustomerSalesHistoryListPage).dataGetSet;

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
        body: dataGetSet!.salesHistory!.isNotEmpty ? Container(
          color: white,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              itemCount: dataGetSet?.salesHistory!.length,
              itemBuilder: (ctx, index) => Container(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _redirectToOrderDetailPage(context, checkValidString(dataGetSet!.customerId).toString(),
                          checkValidString(dataGetSet!.salesHistory![index].orderId).toString());
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child:
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Gap(10),
                                            Text(checkValidString(dataGetSet?.salesHistory![index].orderId).toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                            ),
                                            const Gap(5),
                                            Container(width: 2, height: 15, color: black,),
                                            const Gap(5),
                                            Expanded(
                                              child: Text(checkValidString(dataGetSet?.customerName).toString(),
                                                maxLines:2,
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        alignment: Alignment.bottomLeft,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: '₹ ',
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kBlue),
                                            children: <TextSpan>[
                                              TextSpan(text: checkValidString(convertToComaSeparated(dataGetSet!.salesHistory![index].grandTotal.toString())),
                                                  style: const TextStyle(fontSize: 18, color: kBlue, fontWeight: FontWeight.w700),
                                                  recognizer: TapGestureRecognizer()..onTap = () => {
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10, bottom: 5),
                                        child: Text(
                                          checkValidString(dataGetSet?.salesHistory![index].createdAt),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(fontSize: 13, color: kGray, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Visibility(
                                        visible: checkValidString(dataGetSet?.salesHistory![index].pendingAmount).toString() == "0" ? false : true,
                                        child: Container(
                                            height: 32,
                                            margin: const EdgeInsets.only(left: 10, bottom: 5, top: 5, right: 10),
                                            decoration: BoxDecoration(
                                                color: kLightestPurple,
                                                border: Border.all(width: 1, color: kLightPurple),
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(12.0),
                                                ),
                                                shape: BoxShape.rectangle
                                            ),
                                            child: TextButton(
                                              child:const Text("Receive Payment",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(fontSize: 13, color: black, fontWeight: FontWeight.w500),
                                              ),
                                              onPressed: () {
                                                _redirectToTransaction(context, checkValidString(dataGetSet?.salesHistory![index].orderId).toString(),
                                                    checkValidString(dataGetSet?.customerId).toString(), checkValidString(dataGetSet?.customerName).toString(),
                                                    checkValidString(dataGetSet?.salesHistory![index].pendingAmount).toString());
                                              },
                                            )
                                          //
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                            height: index == dataGetSet!.salesHistory!.length-1 ? 0 : 0.8, color: kLightPurple),
                      ],
                    ),

                  ),
                ),
              )),
        )
        : MyNoDataWidget(msg: "", subMsg: "No sales history found",),
      ),
    );
  }

  Future<void> _redirectToTransaction(BuildContext context, String orderId, String customerId, String customerName, String totalAmount) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentDetailPage(Order(), orderId, customerId, customerName, totalAmount, false)),
    );

    print("result ===== $result");

    if (result == "success") {
      setState(() {
        isCustomerListReload = true;
        tabNavigationReload();

        (widget as CustomerSalesHistoryListPage).callAPI(true);

      });
    }
  }

  Future<void> _redirectToOrderDetailPage(BuildContext context, String customerId, String orderId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailPage(customerId, orderId)),
    );

    print("result ===== $result");

    if (result == "success") {
      setState(() {
        tabNavigationReload();
      });
    }
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is CustomerSalesHistoryListPage;
  }

}