import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../constant/color.dart';


/*show message to user*/
showSnackBar(String? message,BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 1),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

tabNavigationReload() {
  try {
    isHomeLoad = true;
    isCustomerListReload = true;
    isEmployeeListReload = true;
    isOrderListLoad = true;

  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

showToast(String? message) {
  try {
    return
        Fluttertoast.showToast(
            msg: message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 15
        );

  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

String getInitials(String bank_account_name) => bank_account_name.isNotEmpty
    ? bank_account_name.trim().split('  ').map((l) => l[0]).take(1).join()
    : '';

noInterNet(BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
      const SnackBar(
        content: Text("Please check your internet connection!"),
        duration: Duration(seconds: 1),
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

toDisplayCase (String str) {
  try {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

checkValidString (String? value) {
  if (value == null || value == "null" || value == "<null>")
  {
    value = "";
  }
  return value.trim();
}

separator(double height, Color color, double width) {
  final boxWidth = width;
  const dashWidth = 9.0;
  final dashHeight = height;
  final dashCount = (boxWidth / (2 * dashWidth)).floor();
  return Flex(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    direction: Axis.horizontal,
    children: List.generate(dashCount, (_) {
      return SizedBox(
        width: dashWidth,
        height: dashHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
        ),
      );
    }),
  );
}

String universalDateConverter(String inputDateFormat,String outputDateFormat, String date) {
  var inputFormat = DateFormat(inputDateFormat);
  var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

  var outputFormat = DateFormat(outputDateFormat);
  var outputDate = outputFormat.format(inputDate);
  print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format
  return outputDate;
}

/*check email validation*/
bool isValidEmail(String ? input) {
  try {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(input!);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

bool isValidGSTNo(String ? input) {
  try {
    return RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
        .hasMatch(input!);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

bool isValidIFSCCode(String ? input) {
  try {
    return RegExp(r'^[A-Za-z]{4}[a-zA-Z0-9]{7}$')
        .hasMatch(input!);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}


bool isValidSwiftCode(String ? input) {
  try {
    return RegExp(r'^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?$')
        .hasMatch(input!);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

bool hasValidUrl(String value) {
  String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return false;
  }
  else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}

/*check PAN validation*/
bool isValidPan(String ? input) {
  try {
    return RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}").hasMatch(input!);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

String convertToCommaSeperatedValue(double text) {
  var price = "";
  try {
    var formatter = NumberFormat('#,##,000');
    price = formatter.format(text);
  } catch (e) {
    print(e);
  }
  return price;
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';

  String get allInCaps => toUpperCase();

}

getRandomCartSession () {
  try {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(8, (index) => _chars[r.nextInt(_chars.length)]).join();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

String getPrice(String text) {
  if(text.isNotEmpty)
  {
    try {
      var formatter = NumberFormat('#,##,###');
      return "₹ " + formatter.format(double.parse(text));
    } catch (e) {
      return "₹ " + text;
    }
  }
  else
  {
    return "₹ " + text;
  }
}

convertToDate (String? value) {
  if (value == null || value == "null" || value == "<null>")
  {
    value = "";
  }
  final int timestamp1 = int.parse(value); // timestamp in seconds
  final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1 * 1000);
  value = DateFormat('dd MMM, yyyy').format(date1).toString();
  print(date1);
  return value.trim();
}