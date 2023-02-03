import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/model/order_detail_response_model.dart';

import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class OrderDetailPage extends StatefulWidget {
  final customerId;
  final orderId;
  const OrderDetailPage(this.customerId, this.orderId, {Key? key}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends BaseState<OrderDetailPage> {
  bool _isLoading = false;
  TextEditingController searchController = TextEditingController();
  List<OrderItems> listOrderItems = List<OrderItems>.empty();
  OrderDetailResponseModel orderDetailResponseModel = OrderDetailResponseModel();
  late ScrollController _scrollViewController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();

    if(isInternetConnected) {
      _makeCallOrderDetail();
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
                child: const Icon(Icons.share, color: white, size: 28,),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
          backgroundColor: kBlue,
        ),
        body: _isLoading ? const LoadingWidget()
            : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: kBlue,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
                    child: const Text("Order Detail", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 22, top: 40, bottom: 5),
                            child: const Text("Order ID", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 22, bottom: 10),
                            child: Text(checkValidString(orderDetailResponseModel.order?.orderId.toString()), style: TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 22, top: 30, bottom: 5),
                            child: const Text("Total Amount Paid", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 22, bottom: 10),
                            child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.grandTotal.toString())), style: TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(right: 22, top: 40, bottom: 5),
                            child: const Text("Order Placed On", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(right: 22, bottom: 10),
                            child: Text(checkValidString(orderDetailResponseModel.order?.orderDate.toString()), style: TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(right: 22, top: 30, bottom: 5),
                            child: const Text("Delivery On", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(right: 22, bottom: 10),
                            child: Text(checkValidString(orderDetailResponseModel.order?.deliveryDate.toString()), style: TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    color: kBlue,
                    height: 2,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: const Text("Items In Order",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: kGray),)
                  ),
                  ListView.builder(
                      controller: _scrollViewController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listOrderItems.length,
                      itemBuilder: (ctx, index) => InkWell(
                        hoverColor: Colors.white.withOpacity(0.0),
                        onTap: () async {},
                        child: Container(
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
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(left:10, bottom: 6, top: 5),
                                            child: Text(checkValidString(listOrderItems[index].stockName),
                                                maxLines: 2,
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 13)
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(left: 10, top: 5),
                                                  child: Text(checkValidString(listOrderItems[index].itemPrice),
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                                              ),
                                              Container(
                                                  margin: const EdgeInsets.only(left: 5, top: 5),
                                                  child: Text("x", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray))),
                                              Container(
                                                  margin: const EdgeInsets.only(left: 5, top: 5),
                                                  child: Text(checkValidString(listOrderItems[index].itemQty),
                                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(right: 10, bottom: 20),
                                        child: Text("${checkValidString(getPrice(listOrderItems[index].itemTotal.toString()))}",
                                            maxLines: 2,
                                            style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 13)
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                                      height:index == listOrderItems.length-1 ? 0 : 0.8
                                      , color: kLightPurple),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    color: kBlue,
                    height: 2,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: const Text("Payment Summary",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kBlue),)
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 20, top: 5),
                              child: Text("Price(${listOrderItems.length} items)",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                          ),
                          Container(
                              margin: const EdgeInsets.only(right: 20, top: 5),
                              child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.subTotal.toString())),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: black),)
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 20, top: 15),
                              child: Text("Shipping charges",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                          ),
                          Container(
                              margin: const EdgeInsets.only(right: 20, top: 15),
                              child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.shippingCharge.toString())),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: black),)
                          ),
                        ],
                      ),
                      checkValidString(orderDetailResponseModel.order!.adjustments.toString()).isNotEmpty ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 20, top: 15, bottom: 20),
                              child: Text("Adjustment Amount",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                          ),
                          Container(
                              margin: const EdgeInsets.only(right: 20, top: 15, bottom: 20),
                              child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.adjustments.toString())),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: black),)
                          ),
                        ],
                      ) : Container(),
                    ],
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    color: kBlue,
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                          child: Text("Amount Paid",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: kBlue),)
                      ),
                      Container(
                          margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
                          child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.grandTotal.toString())),
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kBlue),)
                      ),
                    ],
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    color: kBlue,
                    height: 2,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: const Text("Payment Mode",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: kGray),)
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, bottom: 10),
                      child: Text(checkValidString(orderDetailResponseModel.order!.paymentMode.toString()),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black),)
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    color: kBlue,
                    height: 2,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: const Text("Delivery Details",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kBlue),)
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                      child: Text(checkValidString(orderDetailResponseModel.order!.customerName.toString()),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: black),)
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                      child: Text("${checkValidString(orderDetailResponseModel.order!.addressLine1.toString())} ${checkValidString(orderDetailResponseModel.order!.addressLine2.toString())}-${checkValidString(orderDetailResponseModel.order!.pincode.toString())} ${checkValidString(orderDetailResponseModel.order!.city.toString())} ${checkValidString(orderDetailResponseModel.order!.stateName.toString())} ${checkValidString(orderDetailResponseModel.order!.countryName.toString())}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kGray),)
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, bottom: 10),
                      child: Text(checkValidString(orderDetailResponseModel.order!.customerMobile.toString()),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kGray),)
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
    widget is OrderDetailPage;
  }

  //API call function...
  _makeCallOrderDetail() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + orderDetails);

    Map<String, String> jsonBody = {
      'customer_id': (widget as OrderDetailPage).customerId.toString(),
      'from_app' : FROM_APP,
      'order_id': (widget as OrderDetailPage).orderId.toString()
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = OrderDetailResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      orderDetailResponseModel = dataResponse;

      print("orderId====>" + orderDetailResponseModel.order!.orderId.toString());

      print("orderItems?.length====>" + orderDetailResponseModel.order!.orderItems!.length.toString());


      listOrderItems = [];
      if(orderDetailResponseModel.order != null) {
        if(orderDetailResponseModel.order!.orderItems!.isNotEmpty) {
          listOrderItems = orderDetailResponseModel.order!.orderItems ?? [];
        }
      }
      showSnackBar(dataResponse.message, context);

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