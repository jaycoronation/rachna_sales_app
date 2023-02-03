import 'dart:io';

import 'package:flutter/material.dart';

import '../screens/tabs/tabnavigation.dart';

var bottomWidgetKey = GlobalKey<State<BottomNavigationBar>>();
var bottomWidgetKey1 = GlobalKey<State<TabNavigation>>();

bool isHomeLoad = false;
bool isOrderListLoad = false;
bool isCustomerListReload = false;
bool isEmployeeListReload = false;

double kTextFieldCornerRadius = 22.0;
double kButtonCornerRadius = 6.0;
double kNoDataViewCornerRadius = 60.0;

const kBlue = Color(0xFF0f3cc9);
const Color black = Color(0xFF3a3a3a);
const Color white = Color(0xffffffff);
const kTextColor = Color(0xFF344f61);
const kGray = Color(0xff8c9099);
const kTextLightGray = Color(0xffaaa9a3); // text light
const kGreen = Color(0xff0f814c); // text light

const Color kDarkGradient = Color(0xff0f3cc9);
const Color kLightGradient = Color(0xff7da2ff);

const Color kLightPurple = Color(0xffc8d9ff);
const Color kLightestPurple = Color(0xffeef4ff);
const Color kLightestGray= Color(0xffe0e0e0);





const kBackGroundColor = Color(0xffeaefee); // text light

const appBG = Colors.white;