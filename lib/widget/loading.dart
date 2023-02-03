import 'package:flutter/material.dart';

import '../constant/color.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                        border: Border.all(
                          color: kBlue,
                          width: 2,
                        )),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(color: kBlue, strokeWidth: 2),
                      )
                  ),
                  ),
                ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Loading...', style: TextStyle(color: kBlue, fontWeight: FontWeight.w600, fontSize: 14),
              )
            ],
          ),
        ));
  }
}
