import 'dart:io';

import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:salesapp/screens/transaction_list_page.dart';

import '../../constant/color.dart';
import '../../utils/app_utils.dart';
import '../../utils/session_manager.dart';
import 'customer_list_page.dart';
import 'dashboard_page.dart';
import 'employee_list_page.dart';
import 'order_list_page.dart';


class TabNavigation extends StatefulWidget {
  final int passIndex;
  const TabNavigation(this.passIndex, {Key? key}) : super(key: key);

  @override
  State<TabNavigation> createState() => _TabNavigationPageState();
}

class _TabNavigationPageState extends State<TabNavigation> {
  DateTime preBackPressTime = DateTime.now();
  late int _currentIndex;
  static final List<Widget> _pages = <Widget>[
    DashboardPage(),
    const OrderListPage(),
    const CustomerListPage(),
    const TransactionListPage(),
    // const EmployeeListPage(),
  ];

  SessionManager sessionManager = SessionManager();

  var _selectedTab = _pages[0];

  onTap(int value) {
    // setState(() {
    //   _selectedTab = _pages[i];
    // });
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if(value == 0 && isHomeLoad) {
      setState(() {
        _pages.removeAt(0);
        _pages.insert(0, DashboardPage(key: UniqueKey()));
      });

    }else if(value == 1 && isOrderListLoad) {
      setState(() {
        _pages.removeAt(1);
        _pages.insert(1, OrderListPage(key: UniqueKey()));
      });

    }else if(value == 2 && isCustomerListReload) {
      setState(() {
        _pages.removeAt(2);
        _pages.insert(2, CustomerListPage(key: UniqueKey()));
      });
    }
    else if(value == 3 && isTransactionListReload) {
      setState(() {
        _pages.removeAt(3);
        _pages.insert(3, TransactionListPage(key: UniqueKey()));
      });
    }
    /*else if(value == 3 && isEmployeeListReload) {
      setState(() {
        _pages.removeAt(3);
        _pages.insert(3, EmployeeListPage(key: UniqueKey()));
      });
    }*/
    setState(() => _currentIndex = value);
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = (widget).passIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_currentIndex != 0)
        {
          print("Is running if condition");
          setState(() {
            _currentIndex = 0;
          });
          return Future.value(false);
        }
        else
        {
          print("Is running else condition");
          final timeGap = DateTime.now().difference(preBackPressTime);
          final cantExit = timeGap >= const Duration(seconds: 2);
          preBackPressTime = DateTime.now();
          if (cantExit)
          {
            showSnackBar('Press back button again to exit', context);
            return Future.value(false);
          }
          else
          {
            SystemNavigator.pop();
            return Future.value(true);
          }
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Column(
          children: [
            Expanded(child: IndexedStack(
              index: _currentIndex,
              children: _pages,
            )),
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            DotNavigationBar(
              backgroundColor: kLightestPurple,
              boxShadow: const [
                BoxShadow(
                  color: kBlue,
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: Offset(0, 0), // changes position of shadow
                )
              ],
              key: bottomWidgetKey1,
              // margin: const EdgeInsets.only(left: 10, right: 10),
              currentIndex: _pages.indexOf(_selectedTab),
              dotIndicatorColor: kLightestPurple,
              unselectedItemColor: kBlue,
              marginR: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
              onTap: onTap,
              items: [
                DotNavigationBarItem(
                  icon: const ImageIcon(AssetImage("assets/images/ic_portfolio.png"),),
                  selectedColor: kBlue,
                ),
                DotNavigationBarItem(
                  icon: const ImageIcon(AssetImage("assets/images/ic_order_blank.png"),),
                  selectedColor:kBlue,
                ),
                DotNavigationBarItem(
                  icon: const ImageIcon(AssetImage("assets/images/ic_customer.png"),),
                  selectedColor: kBlue,
                ),
                DotNavigationBarItem(
                  icon: const ImageIcon(AssetImage("assets/images/ic_customer.png"),),
                  selectedColor: kBlue,
                ),
                /* DotNavigationBarItem(
                  icon: const ImageIcon(AssetImage("assets/images/ic_employee.png"),),
                  selectedColor:kBlue,
                ),*/
              ],
            ),
            Positioned(
              bottom: Platform.isAndroid ? 0 : 35,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                width: MediaQuery.of(context).size.width / 1.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: _currentIndex == 0 ? Container(
                          // margin: const EdgeInsets.only(right: 0),
                          color: Colors.transparent,
                          height: 10, width: 10,
                          child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 10, width: 10, color: _currentIndex == 0 ? kBlue : kLightestPurple,),
                        ) : Container()
                    ),
                    Expanded(
                        child: _currentIndex == 1 ? Container(
                          margin: const EdgeInsets.only(right:8),
                          color: Colors.transparent,
                          height: 10, width: 10,
                          child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 10, width: 10, color: _currentIndex == 1 ? kBlue : kLightestPurple,),
                        ) : Container()
                    ),
                    Expanded(
                        child: _currentIndex == 2 ? Container(
                          // margin: const EdgeInsets.only(right: 30),
                          color: Colors.transparent,
                          height: 10, width: 10,
                          child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 10, width: 10, color: _currentIndex == 2 ? kBlue : kLightestPurple,),
                        ) : Container()
                    ),
                    Expanded(
                        child: _currentIndex == 3 ? Container(
                          margin: const EdgeInsets.only(left: 8),
                          color: Colors.transparent,
                          height: 10, width: 10,
                          child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 10, width: 10, color: _currentIndex == 3 ? kBlue : kLightestPurple),
                        ) : Container()
                    ),
                    /*Expanded(child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      color: Colors.transparent,
                      height: 10, width: 10,
                      child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 10, width: 10, color: _currentIndex == 3 ? kBlue : white,),
                    )),*/
                  ],
                ),
              ),
            ),
            /* Container(
              margin: const EdgeInsets.only(top: 60, left: 10, right: 30),
              child:
            )*/
          ],
        ),
      ),
    );
  }

/* @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          extendBody: true,
          backgroundColor: appBG,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Expanded(child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              )),
            ],
          ),
          bottomNavigationBar:
          SizedBox(
            height: Platform.isAndroid ? 82 : 84,
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Card(
                color: white,
                elevation: 5,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Stack(
                  children: [
                    BottomNavigationBar(
                      key: bottomWidgetKey,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _currentIndex,
                      backgroundColor: white,
                      elevation: 0,
                      selectedItemColor: kBlue,
                      unselectedItemColor: kBlue,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      selectedFontSize: 0,
                      iconSize: 26,
                      onTap: (value) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if(value == 0 && isHomeLoad) {
                          setState(() {
                            _pages.removeAt(0);
                            _pages.insert(0, DashboardPage(key: UniqueKey()));
                          });

                        }else if(value == 1 && isOrderListLoad) {
                          setState(() {
                            _pages.removeAt(1);
                            _pages.insert(1, OrderListPage(key: UniqueKey()));
                          });

                        }else if(value == 2 && isCustomerListReload) {
                          setState(() {
                            _pages.removeAt(2);
                            _pages.insert(2, CustomerListPage(key: UniqueKey()));
                          });

                        }else if(value == 3 && isEmployeeListReload) {
                          setState(() {
                            _pages.removeAt(3);
                            _pages.insert(3, EmployeeListPage(key: UniqueKey()));
                          });

                        }
                        setState(() => _currentIndex = value);
                      },
                      items: [
                        BottomNavigationBarItem(
                          label: '',
                          icon: Container(
                            // margin: const EdgeInsets.only(top: 10),
                            child: const ImageIcon(
                              AssetImage("assets/images/ic_portfolio.png"),
                            ),
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: ImageIcon(
                            AssetImage("assets/images/ic_order_blank.png"),
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: ImageIcon(
                            AssetImage("assets/images/ic_customer.png"),
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: ImageIcon(
                            AssetImage("assets/images/ic_employee.png"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 48),
                      child: Row(
                        children: [
                          Expanded(child: Container(
                            color: white,
                            height: 12, width: 12,
                            child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 12, width: 12, color: _currentIndex == 0 ? kBlue : white,),
                          )),
                          Expanded(child: Container(
                            color: white,
                            height: 12, width: 12,
                            child: Image.asset("assets/images/ic_view_pager_bottom.png",height: 12, width: 12, color: _currentIndex == 1 ? kBlue : white,),
                          )),
                          Expanded(child: Container(
                            color: white,
                            height: 12, width: 12,
                            child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 12, width: 12,color: _currentIndex == 2 ? kBlue : white,),
                          )),
                          Expanded(child: Container(
                            color: white,
                            height: 12, width: 12,
                            child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 12, width: 12, color: _currentIndex == 3 ? kBlue : white,),
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
            return Future.value(false);
          } else {
            final timeGap = DateTime.now().difference(preBackPressTime);
            final cantExit = timeGap >= const Duration(seconds: 2);
            preBackPressTime = DateTime.now();
            if (cantExit) {
              showSnackBar('Press back button again to exit', context);
              return Future.value(false);
            } else {
              SystemNavigator.pop();
              return Future.value(true);
            }
          }
        });
  }*/

/* @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: appBG,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(child: IndexedStack(
                  index: _currentIndex,
                  children: _pages,
                )),
              ],
            ) ,
          ),
          bottomNavigationBar: Container(
            key: bottomWidgetKey1,
            height: 65,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
             child: Card(
               color: white,
               elevation: 5,
               clipBehavior: Clip.antiAliasWithSaveLayer,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(40),
               ),
               child: Column(
                 children: [
                 Container(height: 5),
                   Expanded(
                       child: SizedBox(
                         height: 47,
                         child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         IconButton(
                           splashColor: Colors.transparent,
                           onPressed: () {
                             onTap(0);
                           },
                           icon: const ImageIcon(
                             size : 24,
                             color : kBlue,
                             AssetImage("assets/images/ic_portfolio.png",),
                           )
                         ),
                         IconButton(
                           onPressed: () {
                             onTap(1);
                           },
                           icon: const ImageIcon(
                             size : 24,
                             color : kBlue,
                             AssetImage("assets/images/ic_order_blank.png"),
                           ),
                         ),
                         IconButton(
                           onPressed: () {
                             onTap(2);
                           },
                           icon: const ImageIcon(
                             size : 24,
                             color : kBlue,
                             AssetImage("assets/images/ic_customer.png"),
                           ),
                         ),
                         IconButton(
                           onPressed: () {
                             onTap(3);
                           },
                           icon: const ImageIcon(
                             size : 24,
                             color : kBlue,
                             AssetImage("assets/images/ic_employee.png"),
                           ),
                         ),
                       ],
                     ),
                   )),
                   Container(
                     height: 10,
                     color: Colors.transparent,
                     alignment: Alignment.bottomCenter,
                     child: Row(
                       children: [
                         Expanded(child: Container(
                           color: white,
                           height: 10, width: 10,
                           child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 12, width: 12, color: _currentIndex == 0 ? kBlue : white,),
                         )),
                         Expanded(child: Container(
                           color: white,
                           height: 10, width: 10,
                           child: Image.asset("assets/images/ic_view_pager_bottom.png",height: 12, width: 12, color: _currentIndex == 1 ? kBlue : white,),
                         )),
                         Expanded(child: Container(
                           color: white,
                           height: 10, width: 10,
                           child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 12, width: 12,color: _currentIndex == 2 ? kBlue : white,),
                         )),
                         Expanded(child: Container(
                           color: white,
                           height: 10, width: 10,
                           child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 12, width: 12, color: _currentIndex == 3 ? kBlue : white,),
                         )),
                       ],
                     ),
                   )
                 ],
               )
             ),
          ),
        ),
        onWillPop: () async {
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
            return Future.value(false);
          } else {
            final timeGap = DateTime.now().difference(preBackPressTime);
            final cantExit = timeGap >= const Duration(seconds: 2);
            preBackPressTime = DateTime.now();
            if (cantExit) {
              showSnackBar('Press back button again to exit', context);
              return Future.value(false);
            } else {
              SystemNavigator.pop();
              return Future.value(true);
            }
          }
        });
  }

  onTap(int value) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if(value == 0 && isHomeLoad) {
      setState(() {
        _pages.removeAt(0);
        _pages.insert(0, DashboardPage(key: UniqueKey()));
      });

    }else if(value == 1 && isOrderListLoad) {
      setState(() {
        _pages.removeAt(1);
        _pages.insert(1, OrderListPage(key: UniqueKey()));
      });

    }else if(value == 2 && isCustomerListReload) {
      setState(() {
        _pages.removeAt(2);
        _pages.insert(2, CustomerListPage(key: UniqueKey()));
      });

    }else if(value == 3 && isEmployeeListReload) {
      setState(() {
        _pages.removeAt(3);
        _pages.insert(3, EmployeeListPage(key: UniqueKey()));
      });

    }
    setState(() => _currentIndex = value);

  }*/

}
