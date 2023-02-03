import 'package:flutter/material.dart';

import '../constant/color.dart';

class AppBarWidget extends StatelessWidget {
  final String pageName;

  const AppBarWidget({Key? key, required this.pageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap:() {
              Navigator.pop(context);
            },
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  color: Colors.white
              ),
              alignment: Alignment.topLeft,
              child: Image.asset('assets/images/ic_back_arrow.png', color: black, height: 22, width: 22),
            )
        ),
        Expanded(
          child: Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 10),
          child: Text(
          pageName,
          textAlign: TextAlign.center,
          style: const TextStyle(
          fontSize: 16,
          color: black,
          fontWeight: FontWeight.w600),),
          )
        )
      ],
    );
  }
}

class DashboardAppBarWidget extends StatelessWidget {
  final String pageName;

  const DashboardAppBarWidget({Key? key, required this.pageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap:() {
              Navigator.pop(context);
            },
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  color: Colors.white
              ),
              alignment: Alignment.topLeft,
              child: Image.asset('assets/images/ic_back_arrow.png', color: black, height: 22, width: 22),
            )
        ),
        Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                pageName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    color: black,
                    fontWeight: FontWeight.w600),),
            )
        )
      ],
    );
  }
}
