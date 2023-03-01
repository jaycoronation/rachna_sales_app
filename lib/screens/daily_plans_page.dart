import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/common_response_model.dart';
import 'package:salesapp/model/daily_plan_response_model.dart';
import 'package:salesapp/screens/add_daily_plan_page.dart';
import 'package:salesapp/screens/plan_detail_page.dart';

import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';

class DailyPlansPage extends StatefulWidget {
  const DailyPlansPage({Key? key}) : super(key: key);

  @override
  _DailyPlansPageState createState() => _DailyPlansPageState();
}

class _DailyPlansPageState extends BaseState<DailyPlansPage> {
  bool _isLoading = false;
  bool _isSearchLoading = false;

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 20;
  bool _isLastPage = false;

  var listDailyPlan = List<DailyPlanList>.empty(growable: true);
  var listDailyPlanDate = List<DailyPlanList>.empty(growable: true);

  late ScrollController _scrollViewController;
  bool isScrollingDown = false;
  TextEditingController searchController = TextEditingController();
  String searchText = "";

  String dateStartSelectionChanged = "";
  String dateEndSelectionChanged = "";
  var listFilter = ["Month to date", "Year to date", "Custom Range"];

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
      _getDailyPlansList(true);
    }else {
      noInterNet(context);
    }

  }

  void pagination() {
    if(!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          _getDailyPlansList(false);
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
            title: const Text("Daily Plan",
                style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
            leading: GestureDetector(
                onTap:() {
                  Navigator.pop(context, "success");
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
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12, right: 10),
                child: GestureDetector(
                  onTap: () {
                    _redirectToAddPlan(context, DailyPlanList(), false);
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
                margin: const EdgeInsets.only(top: 11, bottom: 11, left:  5, right: 22),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _showFilterDialog();
                  },
                  child: const Icon(Icons.calendar_today_outlined, color: white, size: 28,),
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
                              hintText: "Search Plan",
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
                                      searchController.text = "";
                                      searchText = "";
                                      dateStartSelectionChanged = "";
                                      dateEndSelectionChanged = "";
                                      isOrderListLoad = false;
                                    });
                                    _getDailyPlansList(true);

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

                              _getDailyPlansList(true);

                            } else if (text.length > 3) {
                              setState(() {
                                searchText = searchController.text.toString().trim();
                              });
                              _getDailyPlansList(true);
                            }

                          },
                        )
                    ),
                  ),
                  Expanded(
                    child: _isSearchLoading ? const LoadingWidget() : listDailyPlan.isNotEmpty ? ListView.builder(
                        controller: _scrollViewController,
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: listDailyPlan.length,
                        itemBuilder: (ctx, index) => Container(
                          color: white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _redirectToPlanDetail(context, checkValidString(listDailyPlan[index].id).toString().trim());
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 5, left: 10),
                                          decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [kLightGradient, kDarkGradient],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius: BorderRadius.circular(22)
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(right: 3, left: 3, top: 3),
                                                child: Text(universalDateConverter("dd-MM-yyyy","dd",checkValidString(listDailyPlan[index].planDate).toString()),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 13, color: white, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(right: 3, left: 3, bottom: 3),
                                                child: Text(universalDateConverter("dd-MM-yyyy","MMM",checkValidString(listDailyPlan[index].planDate).toString()),// planDate.toString().split('-')[1].trim()
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 11, color: white, fontWeight: FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 10,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(left: 10, right: 10),
                                              alignment: Alignment.centerLeft,
                                              child: Text(listDailyPlan[index].customer!.customerName.toString().isNotEmpty ?
                                              checkValidString(listDailyPlan[index].customer!.customerName.toString().trim()) : "-",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 10, right: 10),
                                              child: Text(checkValidString(listDailyPlan[index].planDate.toString().trim()),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(fontSize: 12, color: kGray, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: InkWell(
                                            onTap:() {
                                              showPlanActionDialog(listDailyPlan[index], index);
                                            },
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              margin: const EdgeInsets.only(right: 5),
                                              width: 50,
                                              height: 40,
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: Image.asset('assets/images/ic_more.png',
                                                    color: black, height: 18, width: 40),
                                              ),
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                                      height: index == listDailyPlan.length-1 ? 0 : 0.8, color: kLightPurple),
                                ],
                              ),
                            ),
                          ),
                        )) : const MyNoDataWidget(msg: "", subMsg: "No plans found")
                  ),
                  Visibility(
                      visible: _isLoadingMore,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 80),
                              width: 30,
                              height: 30,
                              child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                          Container(
                            margin: const EdgeInsets.only(bottom: 80),
                            child: const Text(
                                ' Loading more...',
                                style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                            ),
                          )
                        ],
                      )),
                ],
              ),
      ),
    );
  }

  void showPlanActionDialog(DailyPlanList dailyPlanList,int index) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
      elevation: 5,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(height: 2, width : 40, color: kBlue, margin: const EdgeInsets.only(bottom:12)),
                    const Text("Select Option", textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);

                        DailyPlanList getSet = listDailyPlan[index];
                        _redirectToAddPlan(context, getSet, true);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18,right: 18,top: 15,bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset('assets/images/ic_edit.png', height: 18, width: 18),
                            Container(width: 15),
                            const Text("Edit", textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: kLightestGray, height: 1),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
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
                                        height: 2, width: 40,
                                        alignment: Alignment.center,
                                        color: black,
                                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                                          child: const Text('Delete?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: black))
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10, bottom: 15),
                                        child: const Text('Are you sure you want to Delete?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: black)),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(kButtonCornerRadius)),
                                                  color: kBlue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('No',
                                                      style:TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: white)),
                                                ),
                                              ),
                                            ),
                                            const Gap(8),
                                            Expanded(
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius:  BorderRadius.all(Radius.circular(kButtonCornerRadius)),
                                                  color: kBlue,
                                                ),
                                                child: TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    _makeDeletePlanRequest(dailyPlanList.id.toString());
                                                  },
                                                  child: const Text('Yes',
                                                      style:TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: white)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset('assets/images/ic_delete.png', height: 18, width: 18),
                            Container(width: 15),
                            const Text("Delete", textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: kLightestGray, height: 1),
                    Container(height: 12)
                  ],
                ))
          ],
        );
      },
    );
  }

  Future<void> _redirectToAddPlan(BuildContext context, DailyPlanList getSet, bool isFromList) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDailyPlanPage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getDailyPlansList(true);
      setState(() {
      });
    }

  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is DailyPlansPage;
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
                        Expanded(child:
                        SingleChildScrollView(
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
                                                _getDailyPlansList(true);
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
                                                _getDailyPlansList(true);
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
                                                  _getDailyPlansList(true);
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

  Future<void> _redirectToPlanDetail(BuildContext context, String planId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanDetailPage(planId)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getDailyPlansList(true);

      setState(() {
      });
    }
  }

  //API call function...
  _getDailyPlansList([bool isFirstTime = false]) async {
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

    final url = Uri.parse(BASE_URL + dailyPlanList);

    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'limit' : _pageResult.toString(),
      'page' : _pageIndex.toString(),
      'search' : searchText,
      'fromDate' : dateStartSelectionChanged,
      'toDate': dateEndSelectionChanged,
      'emp_id' : sessionManager.getEmpId().toString().trim()
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> dailyPlan = jsonDecode(body);
    var dataResponse = DailyPlanResponseModel.fromJson(dailyPlan);

    if (isFirstTime) {
      if (listDailyPlan.isNotEmpty) {
        listDailyPlan = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.dailyPlanList != null) {
        List<DailyPlanList>? _tempList = [];
        _tempList = dataResponse.dailyPlanList;
        listDailyPlan.addAll(_tempList!);

        if (_tempList.isNotEmpty) {
          _pageIndex += 1;
          if (_tempList.isEmpty || _tempList.length % _pageResult != 0) {
            _isLastPage = true;
          }
        }
      }

      setState(() {
        _isLoading = false;
        _isSearchLoading = false;
        _isLoadingMore = false;
      });

    }else {

      setState(() {
        _isLoading = false;
        _isSearchLoading = false;
        _isLoadingMore = false;
      });

    }
  }

  _makeDeletePlanRequest(String planId) async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + dailyPlanDelete);

    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'id': planId,
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      setState(() {
        _isLoading = false;

      });

      _getDailyPlansList(true);

    }else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(dataResponse.message, context);
    }
  }

}