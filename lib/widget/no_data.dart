import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../constant/color.dart';

class MyNoDataWidget extends StatelessWidget {
  final String msg;
  final String subMsg;

  const MyNoDataWidget({Key? key, required this.msg, required this.subMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(msg, style: const TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.bold)),
              const Gap(6),
              Text(subMsg, style: const TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
            ],
          ),
        )
    );
  }
}
