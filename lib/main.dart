import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salesapp/screens/login_page.dart';
import 'package:salesapp/screens/tabs/tabnavigation.dart';
import 'package:salesapp/utils/session_manager.dart';
import 'package:salesapp/utils/session_manager_methods.dart';

import 'constant/color.dart';
import 'constant/global_context.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManagerMethods.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: appBG,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light,
    ));
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: createMaterialColor(primaryColor),
        // scaffoldBackgroundColor: primaryColor,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kTextLightGray),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kBlue),
          ),
          contentPadding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
          labelStyle: TextStyle(
            color: kTextLightGray,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: kTextLightGray,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        fontFamily: 'Rubik',
      ),
      navigatorKey: NavigationService.navigatorKey,
      home: const MyHomePage(title: 'Rachna Sales App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<void> _initializeFlutterFireFuture;

  bool isLoggedIn = false;

  SessionManager sessionManager = SessionManager();
  SessionManagerMethods sessionManagerMethods = SessionManagerMethods();

  @override
  void initState() {
    super.initState();

    checkLoginSession();
  }

  Future<void>checkLoginSession() async {
    try {
      isLoggedIn = sessionManager.checkIsLoggedIn() ?? false;
      print(isLoggedIn);

      if(isLoggedIn == true) {
          Timer(const Duration(seconds: 3), () =>
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => TabNavigation(0)), (Route<dynamic> route) => false)
          );
      }else {
        Timer(const Duration(seconds: 3), () =>
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (Route<dynamic> route) => false)
        );
      }

    }catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(true);
      },
      child:Scaffold(
        backgroundColor: appBG,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 50),
                  child: const Text('Rachna Sales App')
                  //Image.asset("assets/images/ic_logo.png",width: 300, height: 300, alignment: Alignment.center)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
