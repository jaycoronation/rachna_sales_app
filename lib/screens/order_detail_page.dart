import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/model/order_detail_response_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/color.dart';
import '../model/pdf_download_response_model.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import 'add_payement_detail_page.dart';

class OrderDetailPage extends StatefulWidget {
  final String customerId;
  final String orderId;
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
          automaticallyImplyLeading: false,
          title: const Text("Order Detail",
              style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
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
                getOrderPdf();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12,),
                height: 45,
                width: 45,
                alignment: Alignment.center,
                child: const Icon(Icons.share, color: white, size: 26),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: kBlue,
        ),
        body: _isLoading ? const LoadingWidget()
            : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 22, top: 20, bottom: 10),
                          child: const Text("Order No.", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 10),
                        child: const Text(" : ",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(right: 22, left: 10, bottom: 10, top: 20,),
                          child: Text(checkValidString(orderDetailResponseModel.order?.orderId.toString()),
                              style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 22, top: 10, bottom: 20),
                          child: const Text("Order Placed On", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: const Text(" : ",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(right: 22, left: 10, bottom: 20, top: 10),
                          child: Text(checkValidString(orderDetailResponseModel.order?.orderDate).toString(),
                              style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                  /*Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 22, top: 10, bottom: 20),
                          child: const Text("Total Amount Paid", style: TextStyle(fontWeight: FontWeight.w400, color: kGray, fontSize: 14)),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: const Text(" : ",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(left: 8,  top: 10, bottom: 20),
                          child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.grandTotal.toString())),
                              style: const TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),*/
                  const Divider(indent: 10, endIndent: 10, color: kBlue, height: 1),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, top: 20, bottom: 5),
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
                      itemBuilder: (ctx, index) => Container(
                        color: white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                                        margin: const EdgeInsets.only(left:10, bottom: 5, top: 5),
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
                                              margin: const EdgeInsets.only(left: 10),
                                              child: Text(checkValidString(getPrice(listOrderItems[index].itemPrice.toString())),
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(left: 5),
                                              child: const Text("x", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray))),
                                          Container(
                                              margin: const EdgeInsets.only(left: 5),
                                              child: Text(checkValidString(listOrderItems[index].itemQty),
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Text("${checkValidString(getPrice(listOrderItems[index].itemTotal.toString()))}",
                                        style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 13)
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10, top: 10),
                                  height:index == listOrderItems.length-1 ? 0 : 0.8, color: kBlue),
                            ],
                          ),
                        ),
                      )),
                  const Divider(indent: 10, endIndent: 10, color: kBlue, height: 1),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
                      child: const Text("Payment Summary",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kBlue),)
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 20, top: 5, bottom: 15),
                              child: Text("Price(${listOrderItems.length} items)",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                          ),
                          Container(
                              margin: const EdgeInsets.only(right: 20, top: 5, bottom: 15),
                              child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.subTotal.toString())),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: black),)
                          ),
                        ],
                      ),
                      Visibility(
                        visible: orderDetailResponseModel.order!.discount.toString().isNotEmpty,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 20, top: 5, bottom: 15),
                                child: const Text("Discount",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                            ),
                            Container(
                                margin: const EdgeInsets.only(right: 20, top: 5, bottom: 15),
                                child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.discount.toString())),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: black),)
                            ),
                          ],
                        ),
                      ),
                      checkValidString(orderDetailResponseModel.order!.adjustments.toString()).isNotEmpty ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 20, top: 15, bottom: 20),
                              child: const Text("Adjustment Amount",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: kGray),)
                          ),
                          Container(
                              margin: const EdgeInsets.only(right: 20, top: 15, bottom: 20),
                              child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.adjustments.toString())),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: black),)
                          ),
                        ],
                      ) : Container(),
                    ],
                  ),
                  const Divider(indent: 10, endIndent: 10, color: kBlue, height: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                          child: const Text("Amount Paid",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: kBlue),)
                      ),
                      Container(
                          margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
                          child: Text(checkValidString(getPrice(orderDetailResponseModel.order!.grandTotal.toString())),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kBlue),)
                      ),
                    ],
                  ),
                  const Divider(indent: 10, endIndent: 10, color: kBlue, height: 2,),
                  /*Container(
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
                  const Divider(indent: 10, endIndent: 10, color: kBlue, height: 2,),
                  */
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      child: const Text("Delivery Details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kBlue),)
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                      child: Text(checkValidString(orderDetailResponseModel.order!.customerName.toString()),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: black),)
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                      child: Text("${checkValidString(orderDetailResponseModel.order!.addressLine1.toString())} ${checkValidString(orderDetailResponseModel.order!.addressLine2.toString())}-${checkValidString(orderDetailResponseModel.order!.pincode.toString())} ${checkValidString(orderDetailResponseModel.order!.city.toString())} ${checkValidString(orderDetailResponseModel.order!.stateName.toString())} ${checkValidString(orderDetailResponseModel.order!.countryName.toString())}",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kGray),)
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, bottom: 80),
                      child: Text(checkValidString(orderDetailResponseModel.order!.customerMobile.toString()),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kGray),)
                  ),
                ],
              ),
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _redirectToTransaction(context, orderDetailResponseModel.order!);
            },
            backgroundColor: kBlue,
            child: const Icon(Icons.add, color: white,),
          )
      ),

    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is OrderDetailPage;
  }

  Future<void> _redirectToTransaction(BuildContext context, Order getSet) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentDetailPage(getSet, "", "", "", "", false)),
    );

    print("result ===== $result");

    if (result == "success") {
      setState(() {
      });
    }
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
      'customer_id': checkValidString((widget as OrderDetailPage).customerId).toString(),
      'from_app' : FROM_APP,
      'order_id': checkValidString((widget as OrderDetailPage).orderId).toString()
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = OrderDetailResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      orderDetailResponseModel = dataResponse;

      // print("orderId====>" + orderDetailResponseModel.order!.orderId.toString());
      // print("orderItems?.length====>" + orderDetailResponseModel.order!.orderItems!.length.toString());

      listOrderItems = [];
      if(orderDetailResponseModel.order != null) {
        if(orderDetailResponseModel.order!.orderItems!.isNotEmpty) {
          listOrderItems = orderDetailResponseModel.order!.orderItems ?? [];
        }
      }

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

  void getOrderPdf() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + downloadOrders);

    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'emp_id': sessionManager.getEmpId().toString().trim(),
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> getAnalysisReports = jsonDecode(body);

    var dataResponse = PdfDownloadResponseModel.fromJson(getAnalysisReports);

    if (statusCode == 200 && dataResponse.success == 1) {
      final uri = Uri.parse(dataResponse.data!.pdfLink.toString());
      final response = await get(uri);
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      var pdfName = dataResponse.data!.pdfLink?.split('/');
      final path = '${temp.path}/${pdfName?.last}';
      File(path).writeAsBytes(bytes);
      var invoicePath = path;
      Share.shareFiles([invoicePath], text: '');

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