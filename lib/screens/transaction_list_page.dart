import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/model/transaction_list_response_model.dart';
import 'package:salesapp/screens/add_payement_detail_page.dart';
import 'package:salesapp/screens/transaction_detail_page.dart';

import '../constant/color.dart';
import '../model/order_detail_response_model.dart';
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
  bool _isSearchLoading = false;

  TextEditingController searchController = TextEditingController();
  var searchText = "";

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 10;
  bool _isLastPage = false;

  late ScrollController _scrollViewController;
  bool isScrollingDown = false;

  String dateStartSelectionChanged = "";
  String dateEndSelectionChanged = "";

  var listTransactions = List<TransectionLits>.empty(growable: true);
  TransactionListResponseModel transactionListResponse = TransactionListResponseModel();

  @override
  void initState() {
    super.initState();

    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }

      pagination();

    });

    if(isInternetConnected) {
      _getTransactionListData(true);
    }else {
      noInterNet(context);
    }
    isOrderListLoad = false;

    super.initState();

  }

  void pagination() {
    if(!_isLastPage && !_isLoadingMore)
    {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          _getTransactionListData(false);
        });
      }
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
                        margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: kLightPurple),
                            borderRadius: const BorderRadius.all(Radius.circular(8.0),),
                            color: white,
                            shape: BoxShape.rectangle
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14),
                            prefixIcon: const Icon(Icons.search, size: 26, color: kBlue),
                            suffixIcon: InkWell(
                              child: const Icon(
                                Icons.close,
                                size: 26,
                                color: black,
                              ),
                              onTap: () {
                                setState(() {
                                  isCustomerListReload = false;
                                  searchController.text = "";
                                  searchText = "";
                                });

                                _getTransactionListData(true);
                              },
                            )
                        ),
                        onChanged: (text) {
                          searchController.text = text;
                          searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                          if(text.isEmpty) {
                            searchText = "";
                            _getTransactionListData(true);
                          } else if(text.length > 3) {
                            searchText = searchController.text.toString().trim();
                            _getTransactionListData(true);
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
                              TextSpan(text: transactionListResponse.netBalance.toString(),
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
            _isSearchLoading
                ? const Center(
              child: LoadingWidget(),
            ) : Expanded(
              child: ListView.builder(
                  controller: _scrollViewController,
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: listTransactions.length,
                  itemBuilder: (ctx, index) => Container(
                    color: white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 3),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailPage(checkValidString(listTransactions[index].id).toString())));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 8, top: 6),
                              alignment: Alignment.topLeft,
                              child: Text(checkValidString(listTransactions[index].customerDetails!.customerName).toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                              ),
                            ),
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
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kTextLightGray),
                                      children: <TextSpan>[
                                        TextSpan(text: checkValidString(listTransactions[index].transectionMode).toString(),
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: black),
                                            recognizer: TapGestureRecognizer()..onTap = () => {
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                listTransactions[index].orderDetails!.subTotal!.toString().isNotEmpty
                                ? Container(
                                  margin: const EdgeInsets.only(right: 8, top: 6),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: '₹ ',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: black),
                                      children: <TextSpan>[
                                        TextSpan(text: checkValidString(listTransactions[index].transectionAmount).toString(),
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: black),
                                            recognizer: TapGestureRecognizer()..onTap = () => {
                                            }),
                                      ],
                                    ),
                                  ),
                                )
                                : Container(),
                              ],
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              margin: const EdgeInsets.only(left: 10, top: 6),
                              child: Text(checkValidString(listTransactions[index].transectionDate).toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 13, color: kGray, fontWeight: FontWeight.w400),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                                height: index == listTransactions.length-1 ? 0 : 0.8, color: kLightPurple),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
            Visibility(
                visible: _isLoadingMore,
                child: Positioned(
                  bottom: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                      const Text(
                          ' Loading more...',
                          style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                      )
                    ],
                  ),
                )),
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

  Future<void> _redirectToAddPayment(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPaymentDetailPage(Order(), "", "", "", "")),
    );

    print("result ===== $result");

    if (result == "success") {
      _getTransactionListData(true);
      setState(() {
        isOrderListLoad = true;
      });
    }

  }

  void _getTransactionListData([bool isFirstTime = false]) async {
    if (isFirstTime) {
      if (searchText.isNotEmpty) {
        setState(() {
          _isLoading = false;
          _isSearchLoading = true;
          _isLoadingMore = false;
          _pageIndex = 0;
          _isLastPage = false;
        });
      }else {
        setState(() {
          _isLoading = true;
          _isLoadingMore = false;
          _pageIndex = 0;
          _isLastPage = false;
        });
      }
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + transactionList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'page': _pageIndex.toString(),
      'limit': _pageResult.toString(),
      'search' : searchText,
      'fromDate' : dateStartSelectionChanged,
      'toDate': dateEndSelectionChanged,
      'emp_id' : sessionManager.getEmpId().toString().trim()
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> order = jsonDecode(body);
    var dataResponse = TransactionListResponseModel.fromJson(order);

    if (isFirstTime) {
      if (listTransactions.isNotEmpty) {
        listTransactions = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      transactionListResponse = dataResponse;

      if (transactionListResponse.transectionLits != null) {
        List<TransectionLits>? _tempList = [];
        _tempList = transactionListResponse.transectionLits;
        listTransactions.addAll(_tempList!);

        if (_tempList.isNotEmpty) {
          _pageIndex += 1;
          if (_tempList.isEmpty || _tempList.length % _pageResult != 0) {
            _isLastPage = true;
          }
        }
      }

      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _isSearchLoading = false;
      });

    }else {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _isSearchLoading = false;
      });

    }
  }

}