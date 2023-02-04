import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:salesapp/model/customer_detail_response_model.dart';

import '../constant/color.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

class CustomerSalesHistoryListPage extends StatefulWidget {
  final CustomerDetails? dataGetSet;

  const CustomerSalesHistoryListPage(this.dataGetSet, {Key? key}) : super(key: key);

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
        body: Container(
          color: white,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              itemCount: dataGetSet?.salesHistory!.length,
              itemBuilder: (ctx, index) => InkWell(
                hoverColor: Colors.white.withOpacity(0.0),
                onTap: () async {},
                child: Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {

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
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 10,right: 5, bottom: 5, top: 10),
                                            child: Text("#${checkValidString(dataGetSet?.salesHistory![index].orderNumber.toString().trim())} | ${checkValidString(dataGetSet?.salesHistory![index].totalItem.toString())}+ Product",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(right: 10, bottom: 5, left: 10, top: 10),
                                          child: Text(checkValidString(getPrice(dataGetSet!.salesHistory![index].grandTotal!.toString())),
                                            textAlign: TextAlign.start,
                                            style:const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kGreen),
                                          ),
                                        ),

                                      ],
                                    ),
                                    const Gap(5),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10, bottom: 5),
                                      child: Text(checkValidString(dataGetSet?.salesHistory![index].createdAt.toString()),
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 13, color: kGray, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              height: index == dataGetSet!.salesHistory!.length - 1 ? 0 : 0.8, color: kLightPurple),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

 /* Future<void> _redirectToTransaction(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentDetailPage()),
    );

    print("result ===== $result");

    if (result == "success") {
      setState(() {
      });
    }
  }
  */

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is CustomerSalesHistoryListPage;
  }

}