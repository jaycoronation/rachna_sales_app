import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../constant/color.dart';
import '../model/product_item_list_response_model_old.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class SelectProductPageOld extends StatefulWidget {
  final List<Products> passListProduct;
  final bool isFromDetail;
  SelectProductPageOld(this.passListProduct, this.isFromDetail, {Key? key}) : super(key: key);

  @override
  _SelectProductPageState createState() => _SelectProductPageState();
}

class _SelectProductPageState extends BaseState<SelectProductPageOld> {
  bool _isLoading = false;
  TextEditingController searchController = TextEditingController();
  var searchText = "";
  var listCategory = List<ItemDataOld>.empty(growable: true);
  var listProduct = List<Products>.empty(growable: true);
  List<Products> _templistProduct = [];
  var passListProduct = List<Products>.empty(growable: true);

  var selectedCategoryName = "";
  var selectedCategoryProductCount = "";

  @override
  void initState() {
    super.initState();

    passListProduct = (widget as SelectProductPageOld).passListProduct;

    if(isInternetConnected) {
      _getItemListData();
    }else {
      noInterNet(context);
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
          title: const Text("Select Item",
              style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
          leading: GestureDetector(
              onTap:() {
                Navigator.pop(context);
                // passListProduct = [];
                // for(var n = 0; n < listCategory.length; n++) {
                //   for(var i = 0; i < listCategory[n].products!.length; i++) {
                //     if(listCategory[n].products![i].isProductSelected == true) {
                //       passListProduct.add(listCategory[n].products![i]);
                //     }else {
                //       passListProduct.remove(listCategory[n].products![i]);
                //     }
                //   }
                // }
                //
                // print("passListProduct.length--->" + passListProduct.length.toString());
                // print(passListProduct);
                // Navigator.pop(context, passListProduct);
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
/*          actions: [
            GestureDetector(
              onTap: () {
              },
              child: Container(
                height: 45,
                width: 45,
                alignment: Alignment.center,
                child: const Icon(Icons.search, color: white, size: 28,),
              ),
            ),
            GestureDetector(
              onTap: () {
              },
              child: Container(
                height: 45,
                width: 45,
                alignment: Alignment.center,
                child: const Icon(Icons.calendar_today_outlined, color: white, size: 22,),
              ),
            ),
          ],*/
          centerTitle: false,
          elevation: 0,
          backgroundColor: kBlue,
        ),
        body: _isLoading ? const LoadingWidget()
            : Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 145,
                  color: kLightestPurple,
                ),
                Container(height: 36, width: double.infinity,
                  margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: false,
                      itemCount: listCategory.length,
                      itemBuilder: (ctx, index) =>
                      (Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        height: 36,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: listCategory[index].isSelected ?? false ? kBlue : white,
                            onPrimary: kBlue,
                            elevation: 0.0,
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            side: const BorderSide(color: kLightPurple, width: 0.5, style: BorderStyle.solid),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kTextFieldCornerRadius),),
                            tapTargetSize: MaterialTapTargetSize.padded,
                            animationDuration: const Duration(milliseconds: 100),
                            enableFeedback: true,
                            alignment: Alignment.center,
                          ),
                          onPressed: () {
                            setState(() {
                              for (var j = 0; j < listCategory.length; j++) {
                                if (index == j) {
                                  listCategory[j].isSelected = true;
                                  listProduct = listCategory[index].products!;
                                  selectedCategoryName =  checkValidString(listCategory[index].categoryName);
                                  selectedCategoryProductCount = checkValidString(listCategory[index].products!.length.toString());
                                } else {
                                  listCategory[j].isSelected = false;
                                }
                              }
                            });
                          },
                          child: Text(checkValidString(listCategory[index].categoryName),
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: listCategory[index].isSelected ?? false ? white : kBlue),),
                        ),
                      ))
                  ),),
                Container(
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(width: 1, color: kLightPurple),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        shape: BoxShape.rectangle
                    ),
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 75),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      textAlign: TextAlign.start,
                      controller: searchController,
                      cursorColor: black,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: black,),
                      decoration: InputDecoration(
                          hintText: "Search product",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: kLightPurple, width: 0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: kLightPurple, width: 0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, size: 26, color: kBlue,)
                      ),
                      onChanged: (text) {

                       /* searchController.text = text;
                        searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                        if(text.isEmpty) {
                          searchText = "";
                          _getItemListData();
                        }else if(text.length > 3) {
                          searchText = searchController.text.toString().trim();
                          // _getItemListData();
                        }*/

                        if(text.isNotEmpty) {
                          setState(() {
                            _templistProduct = _buildSearchListForProducts(text);
                          });
                        } else {
                          setState(() {
                            searchController.clear();
                            _templistProduct.clear();
                          });
                        }
                      },
                    )
                ),
              ],
            ),
            Container(
              color: white,
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 15),
              child:RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: selectedCategoryName,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: kBlue),
                  children: <TextSpan>[
                    TextSpan(text: "  ($selectedCategoryProductCount products)",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kGray),
                        recognizer: TapGestureRecognizer()..onTap = () => {
                        }),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 20,),
                    child: const Text("Product Name", style: TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 15))),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'In stock\n',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: black),
                          children: <TextSpan>[
                            TextSpan(text: "(In pack)",
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: black),
                                recognizer: TapGestureRecognizer()..onTap = () => {
                                }),
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 15, right: 15,),
                          child: const Text("Order", style: TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 15))),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                itemCount:(_templistProduct.isNotEmpty) ? _templistProduct.length : listProduct.length,
                itemBuilder: (ctx, index) => Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if(_templistProduct != null && _templistProduct.length > 0) {
                          setState(() {
                            if(_templistProduct[index].isProductSelected ?? false) {
                              _templistProduct[index].isProductSelected = false;
                            }else {
                              _templistProduct[index].isProductSelected = true;
                            }
                          });
                        } else {
                          setState(() {
                            if(listProduct[index].isProductSelected ?? false) {
                              listProduct[index].isProductSelected = false;
                            }else {
                              listProduct[index].isProductSelected = true;
                            }
                          });
                        }
                      },
                      child: (_templistProduct.isNotEmpty)
                          ? _showBottomSheetForProductsList(
                          index, _templistProduct)
                          : _showBottomSheetForProductsList(
                          index, listProduct),
                    ),
                  ),
                ))),
            Container(
              margin: const EdgeInsets.only( bottom: 30, left: 20, right: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kLightGradient, kDarkGradient],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8)
              ),
              child: TextButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  // if (listProduct.isNotEmpty || _templistProduct.isNotEmpty) {
                    passListProduct = [];
                    for(var n = 0; n < listCategory.length; n++) {
                      for(var i = 0; i < listCategory[n].products!.length; i++) {
                        if(listCategory[n].products![i].isProductSelected == true) {
                          passListProduct.add(listCategory[n].products![i]);
                        }else {
                          passListProduct.remove(listCategory[n].products![i]);
                        }
                      }
                    }

                    // print("passListProduct.length--->" + passListProduct.length.toString());
                    // print(passListProduct);
                    Navigator.pop(context, passListProduct);

                    if (isInternetConnected) {

                    } else {
                      noInterNet(context);
                    }
                  // }else {
                  //   showSnackBar("Please select item", context);
                  // }

                },
                child: const Text("Submit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Products> _buildSearchListForProducts(String productSearchTerm) {
    List<Products> _searchList = [];
    for (int i = 0; i < listProduct.length; i++) {
      String name = listProduct[i].stockName.toString().trim();
      if (name.toLowerCase().contains(productSearchTerm.toLowerCase())) {
        _searchList.add(listProduct[i]);
      }
    }
    return _searchList;
  }

  Widget _showBottomSheetForProductsList(int index, List<Products> listData) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 10),
                      child: listData[index].isProductSelected ?? false
                          ? Image.asset("assets/images/check-box.png", height: 28, width: 28,)
                          : Image.asset("assets/images/ic_checkbox_blue.png", height: 28, width: 28,)
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                          child: Text(checkValidString(listData[index].stockName),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 13)
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          child: Text("MRP ${checkValidString(listData[index].stockPrice)}",
                              maxLines: 2,
                              style: const TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 13)
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: kLightPurple),
                      borderRadius: const BorderRadius.all(Radius.circular(12.0),),
                      color: kLightestPurple,
                      shape: BoxShape.rectangle
                  ),
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top:5, bottom: 5, left: 8,),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Text(checkValidString(listData[index].stockQuantity),
                        style: const TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 12)
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: kLightPurple),
                      borderRadius: const BorderRadius.all(Radius.circular(12.0),),
                      color: white,
                      shape: BoxShape.rectangle
                  ),
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top:5, bottom: 5, right: 8, left: 25),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Text(checkValidString(listData[index].orderCount),
                        style: const TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 12)
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            height: index == listData.length-1 ? 0 : 0.8, color: kLightPurple),
      ],
    );

  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is SelectProductPageOld;
  }

  //API call function...
  _getItemListData() async {
    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.NONE),
    ]);

    final url = Uri.parse(BASE_URL + itemListOld);

    Map<String, String> jsonBody = {
      'from_app' : FROM_APP
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> itemData = jsonDecode(body);
    var dataResponse = ProductItemListResponseModelOld.fromJson(itemData);

    if (statusCode == 200 && dataResponse.success == 1) {
      var itemListResponse = ProductItemListResponseModelOld.fromJson(itemData);
      listCategory = itemListResponse.itemDataOld!;
      listCategory[0].isSelected = true;
      listProduct = listCategory[0].products!;
      selectedCategoryName = checkValidString(listCategory[0].categoryName);
      selectedCategoryProductCount = checkValidString(listCategory[0].products!.length.toString());

      for (var i=0; i < passListProduct.length; i++) {
        for (var j=0; j < listProduct.length; j++) {
          if (passListProduct[i].stockId == listProduct[j].stockId) {
            listProduct[j].quantity = passListProduct[i].quantity;
            listProduct[j].isProductSelected = true;
          }
        }
      }
      setState(() {
        _isLoading = false;
      });

    }else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
      });
    }
  }

}