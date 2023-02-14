import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/screens/add_customer_page.dart';
import 'package:salesapp/screens/customer_detail_page.dart';

import '../../Model/common_response_model.dart';
import '../../Model/customer_list_response_model.dart';
import '../../constant/color.dart';
import '../../constant/font.dart';
import '../../network/api_end_point.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../../widget/loading.dart';
import '../../widget/no_data.dart';
import '../../widget/no_internet.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({Key? key}) : super(key: key);

  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends BaseState<CustomerListPage> {
  bool _isLoading = false;
  bool _isSearchLoading = false;

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 20;
  bool _isLastPage = false;

  var listCustomer = List<CustomerList>.empty(growable: true);
  late ScrollController _scrollViewController;
  bool isScrollingDown = false;
  late String? totalOverdue;
  late String? totalSale;

  String dateStartSelectionChanged = "";
  String dateEndSelectionChanged = "";

  TextEditingController textEditingController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  String searchText = "";

  var listFilter = ["Month to date", "Year to date", "Custom Range"];

  @override
  void initState() {
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

    isCustomerListReload = false;

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        title: const Text("Customer List",
            style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 12),
            child: GestureDetector(
              onTap: () {
                _redirectToAddCustomer(context, CustomerList(), false);
              },
              child: Container(
                height: 33,
                width: 34,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: kLightestPurple),
                    borderRadius: const BorderRadius.all(Radius.circular(14.0),),
                    color: white,
                    shape: BoxShape.rectangle
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.add, color: kBlue, size: 21,),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 11, bottom: 11, left:  15, right: 22),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _showFilterDialog();
              },
              child: const Icon(Icons.calendar_today_outlined, color: white, size: 28,),
            ),
          ),
         /* Container(
            margin: const EdgeInsets.only(top: 12, bottom: 12, right: 3),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _redirectToAddCustomer(context, CustomerList(), false);
              },
              child: Container(
                height: 33,
                width: 36,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: kLightestPurple),
                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                    color: white,
                    shape: BoxShape.rectangle
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.add, color: kBlue, size: 21,),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 3),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                DateTimeRange? result = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2022, 1, 1), // the earliest allowable
                    lastDate: DateTime.now(), // the latest allowable
                    currentDate: DateTime.now(),
                    saveText: 'Done',
                    builder: (context, Widget? child) => Theme(
                      data: Theme.of(context).copyWith(
                          appBarTheme: Theme.of(context).appBarTheme.copyWith(
                              backgroundColor: kBlue,
                              iconTheme: Theme.of(context).appBarTheme.iconTheme?.copyWith(color: Colors.white)),
                          scaffoldBackgroundColor: white,
                          colorScheme: const ColorScheme.light(
                              onPrimary: Colors.white,
                              primary: kBlue
                          )),
                      child: child!,
                    )
                );

                if(result != null)
                {
                  DateTime? startDate = result.start;
                  DateTime? endDate = result.end;
                  print(startDate);
                  print(endDate);
                  String startDateFormat = DateFormat('dd-MM-yyyy').format(startDate);
                  String endDateFormat = DateFormat('dd-MM-yyyy').format(endDate);
                  print("==============");
                  print(startDateFormat);
                  print(endDateFormat);
                  dateStartSelectionChanged = startDateFormat;
                  dateEndSelectionChanged = endDateFormat;

                  if (isInternetConnected) {
                    _getCustomerListData(true);
                  }else {
                    noInterNet(context);
                  }
                }
              },
              child: Container(
                height: 45,
                width: 45,
                alignment: Alignment.center,
                child: const Icon(Icons.calendar_today_outlined, color: white, size: 26,),
              ),
            ),
          ),*/
        ],
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
      ),
        body: isInternetConnected
            ? _isLoading
            ? const LoadingWidget()
            : setData()
            : const NoInternetWidget()
    );
  }

  SingleChildScrollView setData() {
    return SingleChildScrollView(
      controller: _scrollViewController,
      child: Column(
          children: [
            Container(
              color: kBlue,
              child: Column(
                children: [
                 /* Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 22),
                    child: const Text("Customer List", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
                  ),*/
                  Stack(
                    children: [
                      SizedBox(
                        height: 215,
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              color: kBlue,
                            ),
                            Container(
                              height: 95,
                              color: kLightestPurple,
                            ),
                          ],
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(width: 1, color: kLightPurple),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              shape: BoxShape.rectangle
                          ),
                          margin: const EdgeInsets.only(left: 15, right: 15, top: 150),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            controller: searchController,
                            cursorColor: black,
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: black,),
                            decoration: InputDecoration(
                                hintText: "Search customer",
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
                                  child: const Icon(
                                    Icons.close,
                                    size: 26,
                                    color: black,
                                  ),
                                  onTap: () {

                                    if (searchController.text.isNotEmpty) {
                                      setState(() {
                                        isCustomerListReload = false;
                                        searchController.text = "";
                                        searchText = "";
                                      });
                                      _getCustomerListData(true);
                                    }
                                  },
                                )
                            ),
                            onChanged: (text) {
                              searchController.text = text;
                              searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                              if (text.isEmpty) {
                                setState(() {
                                  searchText = "";
                                });

                                _getCustomerListData(true);
                              }
                              else if (text.length > 3) {
                                setState(() {
                                  searchText = searchController.text.toString().trim();
                                });
                                _getCustomerListData(true);
                              }
                            },
                          )
                      ),
                      SizedBox(
                        height: 135,
                        child: Column(
                          children: [
                            Container(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: kLightPurple),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                  color: white,
                                  shape: BoxShape.rectangle
                              ),
                              height: 125,
                              margin: const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.only(top: 5),
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      text: '₹ ',
                                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kGreen),
                                                      children: <TextSpan>[
                                                        TextSpan(text: checkValidString(convertToComaSeparated(totalSale.toString())),
                                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kGreen, fontFamily: kFontNameRubikBold),
                                                            recognizer: TapGestureRecognizer()..onTap = () => {
                                                            }),
                                                      ],
                                                    ),
                                                  ),
                                              ),
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: const Text("Total",
                                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: kGray),
                                                      textAlign: TextAlign.center)
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1.0,
                                          color: kLightestGray,
                                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets.only(top: 5),
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      text: '₹ ',
                                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: kRed),
                                                      children: <TextSpan>[
                                                        TextSpan(text: checkValidString(convertToComaSeparated(totalOverdue.toString())),
                                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kRed, fontFamily: kFontNameRubikBold),
                                                            recognizer: TapGestureRecognizer()..onTap = () => {
                                                            }),
                                                      ],
                                                    ),
                                                  ),
                                              ),
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: const Text("Overdues",
                                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: kGray),
                                                      textAlign: TextAlign.center)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(height: 0.5, color: kLightestGray),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 39,
                                          alignment: Alignment.center,
                                          child: const Text("VIEW REPORTS",
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,color: kBlue),
                                              textAlign: TextAlign.center)
                                      ),
                                      Image.asset("assets/images/ic_right_arrow.png", height: 14, width: 14,)
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            _isSearchLoading
                ? const Center(
              child: LoadingWidget(),
            ) :
            Stack(
              alignment: Alignment.center,
              children: [
                listCustomer.isNotEmpty ?
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    itemCount: listCustomer.length,
                    itemBuilder: (ctx, index) => Container(
                      color: white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            CustomerList getSet = listCustomer[index];
                            _redirectToCustomerDetail(context, getSet, true);
                            // _redirectToAddCustomer(context, getSet, true);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10, right: 5, bottom: 8),
                                child: Text(checkValidString(toDisplayUpperCase1(listCustomer[index].customerName.toString().trim())),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                ),
                              ),
  /*                            Container(
                                margin: const EdgeInsets.only(left: 10, right: 5),
                                child: const Text("Pending amount : ",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w400),
                                ),
                              ),*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10,),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'Total Sale : ',
                                        style:  const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: kGray),
                                        children: <TextSpan>[
                                          TextSpan(text:checkValidString(getPrice(listCustomer[index].customerTotalSale.toString())),
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: black),
                                              recognizer: TapGestureRecognizer()..onTap = () => {
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  /*IconButton(
                                    icon: const Icon(Icons.delete_outline_outlined, color: black, size: 24,),
                                    iconSize: 24,
                                    alignment: Alignment.center,
                                    onPressed: () async {
                                      _deleteCustomer(listCustomer[index], index);
                                    },
                                  ),*/
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                                  height: index == listCustomer.length-1 ? 0 : 0.8, color: kLightPurple),
                            ],
                          ),
                        ),
                      ),
                    ))
                : const SizedBox(height: 60,
                    child: MyNoDataWidget(msg: "", subMsg: "No customer found")),
                Visibility(
                    visible: _isLoadingMore,
                    child: Positioned(
                      bottom: Platform.isAndroid ? 80 : 110,
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
                    ))
              ],
            ),

          ]
      ),
    );
  }

  void pagination() {
    if(!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          _getCustomerListData(false);
        });
      }
    }
  }

  Future<void> _redirectToCustomerDetail(BuildContext context, CustomerList getSet, bool isFromList) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerDetailPage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getCustomerListData(true);
      setState(() {
        isCustomerListReload = true;
      });
    }
  }

  Future<void> _redirectToAddCustomer(BuildContext context, CustomerList getSet, bool isFromList) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCustomerPage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getCustomerListData(true);
      setState(() {
        isCustomerListReload = true;
      });
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12,right: 12,top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 60,
                            margin: const EdgeInsets.only(top: 12),
                            child: const Divider(
                              height: 1.5,
                              thickness: 1.5,
                              color: kBlue,
                            )),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                          child: const Text("Select Date", style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        Container(height: 6),
                        Expanded(child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                  itemCount: listFilter.length,
                                  shrinkWrap: true,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              // _transactionModeController.text = checkValidString(listFilter[index]);
                                            });
                                            Navigator.of(context).pop();

                                            if (index == 0) {
                                              var monthTillDate = "";
                                              monthTillDate = DateTime.now().toString();

                                              var dateParse = DateTime.parse(monthTillDate);
                                              String currentDate = DateFormat('dd-MM-yyyy').format(dateParse);

                                              print("==========");
                                              print(currentDate);
                                              print("==========");

                                              String fromDateTillMonth = "01-${DateFormat('MM-yyyy').format(dateParse)}";
                                              print("==========");
                                              print(fromDateTillMonth);

                                              dateStartSelectionChanged = fromDateTillMonth;
                                              dateEndSelectionChanged = currentDate;

                                              if(isInternetConnected) {
                                                _getCustomerListData(true);
                                              }else {
                                                noInterNet(context);
                                              }

                                            }else if (index == 1) {

                                              var yearTillDate = DateTime.now().toString();
                                              var dateParse = DateTime.parse(yearTillDate);

                                              String currentYear = DateFormat('yyyy').format(dateParse);
                                              String fromDateTillYear = "01-04-${DateFormat('yyyy').format(dateParse)}";

                                              var result = int.parse(currentYear) + 1;
                                              String toDateTillYear = "31-03-$result";

                                              print("==========");
                                              print(fromDateTillYear);
                                              print("==========");
                                              print(toDateTillYear);

                                              dateStartSelectionChanged = fromDateTillYear;
                                              dateEndSelectionChanged = toDateTillYear;

                                              if(isInternetConnected) {
                                                _getCustomerListData(true);
                                              }else {
                                                noInterNet(context);
                                              }

                                            }else if (index == 2) {

                                              DateTimeRange? result = await showDateRangePicker(
                                                  context: context,
                                                  firstDate: DateTime(2022, 1, 1), // the earliest allowable
                                                  lastDate: DateTime.now(), // the latest allowable
                                                  currentDate: DateTime.now(),
                                                  saveText: 'Done',
                                                  builder: (context, Widget? child) => Theme(
                                                    data: Theme.of(context).copyWith(
                                                        appBarTheme: Theme.of(context).appBarTheme.copyWith(
                                                            backgroundColor: kBlue,
                                                            iconTheme: Theme.of(context).appBarTheme.iconTheme?.copyWith(color: Colors.white)),
                                                        scaffoldBackgroundColor: white,
                                                        colorScheme: const ColorScheme.light(
                                                            onPrimary: Colors.white,
                                                            primary: kBlue
                                                        )),
                                                    child: child!,
                                                  )
                                              );

                                              if(result !=null)
                                              {
                                                DateTime? startDate = result.start;
                                                DateTime? endDate = result.end;
                                                print(startDate);
                                                print(endDate);
                                                String startDateFormat = DateFormat('dd-MM-yyyy').format(startDate);
                                                String endDateFormat = DateFormat('dd-MM-yyyy').format(endDate);
                                                print("==============");
                                                print(startDateFormat);
                                                print(endDateFormat);
                                                dateStartSelectionChanged = startDateFormat;
                                                dateEndSelectionChanged = endDateFormat;

                                                if(isInternetConnected) {
                                                  _getCustomerListData(true);
                                                }else {
                                                  noInterNet(context);
                                                }
                                              }

                                            }else {

                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              checkValidString(listFilter[index]),
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: black),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 0.5,
                                          color: kTextLightGray,
                                          endIndent: 16,
                                          indent: 16,
                                        ),
                                      ],
                                    );
                                  })
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                );
              });
        });

  }

  void _deleteCustomer(CustomerList customer, int index) {
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
                      child: const Text('Delete Customer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: black))
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: const Text('Are you sure want to delete this customer?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black)),
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
                                borderRadius:  BorderRadius.all(Radius.circular(kButtonCornerRadius)),
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
                                  _makeDeleteCustomerRequest(customer, index);
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

  void _getCustomerListData([bool isFirstTime = false]) async {
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

    final url = Uri.parse(BASE_URL + customerList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
      'search' : searchText,
      'fromDate' : dateStartSelectionChanged,
      'toDate': dateEndSelectionChanged
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
      totalOverdue = checkValidString(dataResponse.totalOverdue);
      totalSale = checkValidString(dataResponse.totalSale);

      sessionManagerMethod.setOverdues(totalOverdue.toString());

      if (customerListResponse.customerList != null) {

        List<CustomerList>? _tempList = [];
        _tempList = customerListResponse.customerList;
        listCustomer.addAll(_tempList!);

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

  void _makeDeleteCustomerRequest(CustomerList customer, int index) async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + deleteCustomerList);

    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'customer_id': checkValidString(customer.customerId.toString().trim()),
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);

      setState(() {
        // isAddedOrRemovedBank = true;
        listCustomer.removeAt(index);
        _isLoading = false;
        tabNavigationReload();
      });

    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is CustomerListPage;
  }

}