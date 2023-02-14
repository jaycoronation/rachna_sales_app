import 'dart:io';

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


class BottomTabNavigation extends StatefulWidget {
  final int passIndex;
  const BottomTabNavigation(this.passIndex, {Key? key}) : super(key: key);

  @override
  State<BottomTabNavigation> createState() => _BottomTabNavigationPageState();
}

class _BottomTabNavigationPageState extends State<BottomTabNavigation> {
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
            height: Platform.isAndroid ? 89 : 109,
            child: Container(
              margin: Platform.isAndroid ? const EdgeInsets.only(left: 30, right: 30, bottom: 20) :  const EdgeInsets.only(left: 30, right: 30, bottom: 40) ,
              child: Card(
                color: kLightestPurple,
                elevation: 0,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: const BorderSide(width: 1, color: kLightPurple)
                ),
                child: Stack(
                  children: [
                    BottomNavigationBar(
                      key: bottomWidgetKey,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _currentIndex,
                      backgroundColor: kLightestPurple,
                      elevation: 0,
                      selectedItemColor: kBlue,
                      unselectedItemColor: kBlue,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      selectedFontSize: 0,
                      iconSize: 28,
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

                        }else if(value == 3 && isTransactionListReload) {
                          setState(() {
                            _pages.removeAt(3);
                            _pages.insert(3, TransactionListPage(key: UniqueKey()));
                          });

                        }
                        setState(() => _currentIndex = value);
                      },
                      items: const [
                        BottomNavigationBarItem(
                          label: '',
                          icon: ImageIcon(AssetImage("assets/images/ic_01.png"),
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: ImageIcon(AssetImage("assets/images/ic_02.png"),
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: ImageIcon(AssetImage("assets/images/ic_03.png"), size: 30,
                          ),
                        ),
                        BottomNavigationBarItem(
                          label: '',
                          icon: ImageIcon(AssetImage("assets/images/ic_04.png"), size: 30,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 48),
                      child: Row(
                        children: [
                          Expanded(child: Container(
                            color: kLightestPurple,
                            height: 12, width: 12,
                            child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 12, width: 12, color: _currentIndex == 0 ? kBlue : kLightestPurple,),
                          )),
                          Expanded(child: Container(
                            color: kLightestPurple,
                            height: 12, width: 12,
                            child: Image.asset("assets/images/ic_view_pager_bottom.png",height: 12, width: 12, color: _currentIndex == 1 ? kBlue : kLightestPurple,),
                          )),
                          Expanded(child: Container(
                            color: kLightestPurple,
                            height: 12, width: 12,
                            child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 12, width: 12,color: _currentIndex == 2 ? kBlue : kLightestPurple,),
                          )),
                          Expanded(child: Container(
                            color: kLightestPurple,
                            height: 12, width: 12,
                            child: Image.asset("assets/images/ic_view_pager_bottom.png", height: 12, width: 12, color: _currentIndex == 3 ? kBlue : kLightestPurple,),
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
  }

}
