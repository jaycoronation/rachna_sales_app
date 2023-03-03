import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/screens/add_customer_page.dart';

import '../Model/customer_list_response_model.dart';
import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';

class SelectCustomerListPage extends StatefulWidget {
  final CustomerList dataGetSet;
  const SelectCustomerListPage(this.dataGetSet, {Key? key}) : super(key: key);

  @override
  _SelectCustomerListPageState createState() => _SelectCustomerListPageState();
}

class _SelectCustomerListPageState extends BaseState<SelectCustomerListPage> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 20;
  bool _isLastPage = false;

  var listCustomer = List<CustomerList>.empty(growable: true);
  List<CustomerList> _templistCustomer = [];

  late ScrollController _scrollViewController;
  bool isScrollingDown = false;
  late num? totalAmount;
  late num? totalSale;

  TextEditingController searchController = TextEditingController();
  var searchText = "";


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
      _getCustomerListData(true);
    }else {
      noInterNet(context);
    }

  }

  void pagination() {
    if(!_isLastPage && !_isLoadingMore)
    {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          _getCustomerListData(false);
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
          title: const Text("Customers",
              style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
          leading: GestureDetector(
              onTap:() {
                Navigator.pop(context, CustomerList());
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomerPage(CustomerList(), false)));
              },
              child: Container(
                height: 45,
                width: 45,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10, top: 5),
                child: Image.asset('assets/images/img.png', height: 40, width: 40),
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
           /* Container(
              color: kBlue,
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10),
              child: const Text("Customers", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
            ),*/
            Container(
              color: kLightestPurple,
              child: Container(
                  decoration: BoxDecoration(
                      color: white,
                      border: Border.all(width: 1, color: kLightPurple),
                      borderRadius: const BorderRadius.all(Radius.circular(8.0),),
                      shape: BoxShape.rectangle
                  ),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    textAlign: TextAlign.start,
                    controller: searchController,
                    cursorColor: black,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: black,),
                    decoration: InputDecoration(
                        hintText: "Search Customer",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kLightPurple, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kLightPurple, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, size: 26, color: kBlue,),
                        suffixIcon: InkWell(
                          child: const Icon(Icons.close, size: 26, color: black,),
                          onTap: () {
                            if (searchController.text.isNotEmpty) {
                              setState(() {
                                searchController.clear();
                                _templistCustomer.clear();
                              });
                            }
                          },
                        )
                    ),
                    onChanged: (text) {
                      if(text.isNotEmpty) {
                        setState(() {
                          _templistCustomer = _buildSearchListForCustomers(text);
                        });
                      } else {
                        setState(() {
                          searchController.clear();
                          _templistCustomer.clear();
                        });
                      }
                    },
                  )
              ),
            ),
            listCustomer.isNotEmpty ?
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scrollViewController,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: (_templistCustomer.isNotEmpty) ? _templistCustomer.length : listCustomer.length,
                      itemBuilder: (ctx, index) => Container(
                        color: white,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (_templistCustomer.isNotEmpty) {
                                Navigator.pop(context, _templistCustomer[index]);
                              }else {
                                Navigator.pop(context, listCustomer[index]);
                              }
                            },
                            child: (_templistCustomer.isNotEmpty)
                                ? _showBottomSheetForCustomerList(
                                index, _templistCustomer)
                                : _showBottomSheetForCustomerList(
                                index, listCustomer),
                          ),
                        ),
                      )
                  ),
                  /*Visibility(
                      visible: _isLoadingMore,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.bottomCenter,
                              // margin: const EdgeInsets.only(bottom: 10),
                              width: 30,
                              height: 30,
                              child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                          Container(
                            alignment: Alignment.bottomCenter,
                            // margin: const EdgeInsets.only(bottom: 10),
                            child: const Text(' Loading more...',
                                style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                            ),
                          )
                        ],
                      )),*/
                  Visibility(
                      visible: _isLoadingMore,
                      child: Positioned(
                        bottom: Platform.isAndroid ? 0 : 20,
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                              const Text(' Loading more...',
                                  style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                              )
                            ],
                          ),
                        ),
                      )
                  ),
                ],
              ),
            )
            : const Center(
              child: SizedBox(
                  height: 60,
                  child: MyNoDataWidget(msg: "", subMsg: "No customers found")),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is SelectCustomerListPage;
  }

  List<CustomerList> _buildSearchListForCustomers(String customerSearchTerm) {
    List<CustomerList> searchList = [];
    for (int i = 0; i < listCustomer.length; i++) {
      String name = listCustomer[i].customerName.toString().trim();
      if (name.toLowerCase().contains(customerSearchTerm.toLowerCase())) {
        searchList.add(listCustomer[i]);
      }
    }
    return searchList;
  }

  Widget _showBottomSheetForCustomerList(int index, List<CustomerList> listData) {
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              decoration: BoxDecoration(
                  color: kLightestPurple,
                  borderRadius: BorderRadius.circular(22)
              ),
              width: 40,
              height: 40,
              child: Text(listData[index].customerName.toString().isNotEmpty ? getInitials(listData[index].customerName.toString()) : "",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: kBlue, fontWeight: FontWeight.w400),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(checkValidString(listData[index].customerName.toString().trim()),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Text("${checkValidString(listData[index].addressLine1.toString().trim())}\n${checkValidString(listData[index].addressLine2.toString().trim())}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 13, color: black, fontWeight: FontWeight.w400),
                    ),
                  ),
                /*  Container(
                    margin: const EdgeInsets.only(left: 10,),
                    alignment: Alignment.center,
                    child: Text("${listData[index].ledgerMobile.toString().isNotEmpty ? checkValidString(listData[index].ledgerMobile.toString().trim()) : ""} ",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 12, color: kGray, fontWeight: FontWeight.w500),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
        Container(
            margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
            height: index == listData.length-1 ? 0 : 0.8, color: kLightPurple),
      ],
    );
  }

  //API call function...
  void _getCustomerListData([bool isFirstTime = false]) async {
    if (isFirstTime) {
      setState(() {
        _isLoading = true;
        _isLoadingMore = false;
        _pageIndex = 0;
        _isLastPage = false;
      });
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + customerList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
      'search': searchText
    };

    final response = await http.post(url, body: jsonBody);

    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> order = jsonDecode(body);
    var dataResponse = CustomerListResponseModel.fromJson(order);

    if (isFirstTime) {
      if (listCustomer.isNotEmpty) {
        listCustomer = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      var customerListResponse = CustomerListResponseModel.fromJson(order);
      // totalAmount = dataResponse.totalAmount;
      // totalSale = dataResponse.todaysSale;

      if (customerListResponse.customerList != null) {

        List<CustomerList>? tempList = [];
        tempList = customerListResponse.customerList;
        listCustomer.addAll(tempList!);

        if (tempList.isNotEmpty) {
          _pageIndex += 1;
          if (tempList.isEmpty || tempList.length % _pageResult != 0) {
            _isLastPage = true;
          }
        }
      }

      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });

    }else {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

}