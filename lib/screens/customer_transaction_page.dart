import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:salesapp/model/customer_detail_response_model.dart';

import '../constant/color.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

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
        body:Container(
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
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 10,right: 5, bottom: 5, top: 10),
                                          child: Text(checkValidString(dataGetSet?.customerTransection![index].transectionMode.toString().trim()),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 10, bottom: 5, left: 10, top: 10),
                                        child: Text(checkValidString(getPrice(dataGetSet!.customerTransection![index].transectionAmount.toString())),
                                          textAlign: TextAlign.start,
                                          style:const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kGreen),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(5),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, bottom: 5),
                                    child: Text(checkValidString(dataGetSet?.customerTransection![index].transectionDate.toString()),
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
                            height: index == dataGetSet!.customerTransection!.length - 1 ? 0 : 0.8, color: kLightPurple),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is CustomerTransactionListPage;
  }
  

}