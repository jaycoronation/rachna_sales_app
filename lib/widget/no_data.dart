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
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   /* Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(kNoDataViewCornerRadius))),
                        elevation: 0,
                        color: white,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 22.0, bottom: 22, left: 40, right: 40),
                          child: Image.asset("assets/images/$imageName", width: 60,height: 60, color: black,),
                        )
                    ),
                    const Gap(6),
                    */
                    Text(msg, style: const TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.bold,),),
                    const Gap(6),
                    Text(subMsg, style: const TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.w500,), textAlign: TextAlign.center,)
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
