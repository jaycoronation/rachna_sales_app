import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/customer_list_response_model.dart';
import 'package:salesapp/model/order_detail_response_model.dart';
import 'package:salesapp/screens/select_customer_list_page.dart';
import 'package:salesapp/screens/select_product_page_old.dart';

import '../Model/common_response_model.dart';
import '../constant/color.dart';
import '../model/product_item_data_response_model.dart';
import '../model/product_item_list_response_model_old.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class AddOrderPage extends StatefulWidget {
  final Order getSet;
  final bool isFromList;
  final CustomerList customerDetail;
  final bool isFromDetail;

  const AddOrderPage(this.getSet, this.isFromList, this.customerDetail, this.isFromDetail, {Key? key}) : super(key: key);

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends BaseState<AddOrderPage> {
  bool _isLoading = false;

  TextEditingController searchController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController adjustmentController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  bool isAdjPlus = true;
  bool isValidCustomer = false;
  bool isValidProduct = false;

  var searchText = "";
  FocusNode inputNode = FocusNode();

  // var listProduct = List<ItemData>.empty(growable: true);
  var listProduct = List<Products>.empty(growable: true);
  var customerDetail = CustomerList();

  var subTotal = 0.0;
  var mainListProduct = List<ItemData>.empty(growable: true);

  bool isFromDetail = false;

  @override
  void initState() {
    super.initState();

    customerDetail = (widget as AddOrderPage).customerDetail;
    isFromDetail = (widget as AddOrderPage).isFromDetail;

    if(isFromDetail) {
      setState(() {
        _isLoading = true;
        isValidCustomer = true;
      });

      if(listProduct.isEmpty) {
        Timer(const Duration(milliseconds: 500), () =>
            _redirectToAddItem(context, listProduct, true)
        );

        Timer(const Duration(seconds: 1), () =>
            setState(() {
              _isLoading = false;
            })
        );

      }else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 55,
        automaticallyImplyLeading: false,
        title: const Text("Add Order",
            style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
        leading: GestureDetector(
            onTap:() {
              Navigator.pop(context);
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
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
      ),
      body: _isLoading ? const LoadingWidget()
          : SingleChildScrollView(
            child: Column(
        children: [
/*            Container(
              color: kBlue,
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 22, top: 10, bottom: 15),
              child: const Text("Add Order",
                  style: TextStyle(fontWeight: FontWeight.w700, color: white, fontSize: 20)),
            ),*/
          isFromDetail ?
          Stack(
            children: [
              Container(
                color: kLightestPurple,
                child: Container(
                    // decoration: BoxDecoration(
                    //     color: white,
                    //     border: Border.all(width: 1, color: kLightPurple),
                    //     borderRadius: const BorderRadius.all(Radius.circular(8.0),),
                    //     shape: BoxShape.rectangle
                    // ),
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),

                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [kLightGradient, kDarkGradient],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Text("Add Items",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white),),
                ),
              ),
            ],
          ) :
          Stack(
              children: [
                Container(
                  color: kLightestPurple,
                  child: Container(
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(width: 1, color: kLightPurple),
                          borderRadius: const BorderRadius.all(Radius.circular(8.0),),
                          shape: BoxShape.rectangle
                      ),
                      margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textAlign: TextAlign.start,
                        readOnly: true,
                        controller: searchController,
                        cursorColor: black,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: black,),
                        decoration: InputDecoration(
                            hintText: "Search Customer",
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: kLightPurple, width: 0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: kLightPurple, width: 0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: kBlue,
                                fontSize: 14
                            ),
                            prefixIcon: const Icon(Icons.search, size: 26, color: kBlue)
                        ),
                        onChanged: (text) {
                        },
                        onTap: () {
                          _redirectToAddCustomer(context, customerDetail);
                        },
                      )
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 90),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [kLightGradient, kDarkGradient],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: const Text("Add Items",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white),),
                  ),
                ),
              ],
            ),
          const Gap(15),
          Visibility(
            visible: checkValidString(customerDetail.customerName).toString().isNotEmpty,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left:15,top: 15, bottom: 15),
                decoration: BoxDecoration(
                    color: kLightestPurple,
                    borderRadius: BorderRadius.circular(22)
                ),
                width: 40,
                height: 40,
                child: Text(customerDetail.customerName.toString().isNotEmpty ? getInitials(customerDetail.customerName.toString().trim()) : "",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: kBlue, fontWeight: FontWeight.w400),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(checkValidString(customerDetail.customerName),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Text("${checkValidString(customerDetail.addressLine1)}\n${checkValidString(customerDetail.addressLine2)}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 13, color: black, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ],
        )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
                  child: const Text("Order Items", style: TextStyle(fontWeight: FontWeight.w600, color: kBlue, fontSize: 15))),
              GestureDetector(
                onTap: () {
                  _redirectToAddItem(context, listProduct, false);
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 20, top: 20, bottom: 10),
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(width: 1, color: kBlue),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        shape: BoxShape.rectangle
                    ),
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: const Text("Add Item", style: TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14))),
              ),
            ],
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              itemCount: listProduct.length,
              itemBuilder: (ctx, index) => Container(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left:10, bottom: 6, top: 5),
                                child: Text(checkValidString(listProduct[index].stockName),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 13)
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text("MRP ${checkValidString(listProduct[index].stockPrice)}",
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 13)
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only( top: 5),
                                  child: TextButton(onPressed: () {
                                    _removeProduct(index);

                                    getPriceCalculated();
                                    getItemCalculation(listProduct[index], index);
                                    setState(() {
                                      // listProduct.remove(listProduct[index]);
                                      if(listProduct.isEmpty) {
                                        isValidProduct = false;
                                      }
                                    });
                                  },
                                    child: const Text("Remove",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: kBlue),),
                                  )
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.topRight,
                                margin: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {

                                        if (listProduct[index].quantity == 1)
                                        {
                                          _removeProduct(index);
                                        }
                                        else
                                        {
                                          listProduct[index].quantity = listProduct[index].quantity - 1;
                                        }

                                        getPriceCalculated();
                                        getItemCalculation(listProduct[index], index);

                                      },
                                      icon: Image.asset('assets/images/ic_blue_minus.png', height: 24, width: 24),
                                    ),
                                    Text(listProduct[index].quantity.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 13)),
                                    IconButton(
                                      onPressed: () {
                                        listProduct[index].quantity = listProduct[index].quantity + 1;
                                        getPriceCalculated();
                                        getItemCalculation(listProduct[index], index);
                                      },
                                      icon:Image.asset('assets/images/ic_blue_add.png', height: 24, width: 24),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 10, bottom: 20),
                                child: Text("${checkValidString(getPrice(listProduct[index].itemPrice.toString()))}",
                                    maxLines: 2,
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 13)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          height:index == listProduct.length-1 ? 0 : 0.8, color: kLightPurple),
                    ],
                  ),
                ),
              )),
          Visibility(
            visible: listProduct.isNotEmpty,
              child: Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              child: Text("Sub Total : ${getPrice(subTotal.toString())}",
                  style: const TextStyle(fontWeight: FontWeight.w700, color: black, fontSize: 16)))),
          Container(
            color: kLightestPurple,
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(width: 1, color: kLightPurple),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        shape: BoxShape.rectangle
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      cursorColor: black,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: black,),
                      onSubmitted: (value) {
                        setState(() {
                          if (value.isNotEmpty)
                          {
                            print("subTotal == $subTotal");
                            print("value == $value");
                            subTotal = subTotal - double.parse(value.isNotEmpty ? value : "0");
                          }
                          else
                          {
                            getPriceCalculated();
                          }
                        });
                      },
                      onChanged: (value) {
                        if (value.isEmpty) {
                          getPriceCalculated();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Discount",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kLightPurple, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kLightPurple, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter. digitsOnly
                      ],
                    )
                ),
                Container(
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(width: 1, color: kLightPurple),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        shape: BoxShape.rectangle
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                    child: TextField(
                      controller: adjustmentController,
                      keyboardType: TextInputType.number,
                      cursorColor: black,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: black,),
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          width: 70,
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isAdjPlus = true;
                                  });
                                  getPriceCalculated();
                                },
                                  child: Icon(Icons.add,color: isAdjPlus ? kBlue : black,)
                              ),
                              const Gap(6),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isAdjPlus = false;
                                  });
                                  getPriceCalculated();
                                },
                                  child: Icon(Icons.remove,color: !isAdjPlus ? kBlue : black)),
                            ],
                          ),
                        ),
                        hintText: "Adjustments",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kLightPurple, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kLightPurple, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          getPriceCalculated();
                        }
                      },
                      onSubmitted: (value) {
                        if (value.isEmpty)
                        {
                          getPriceCalculated();
                        }
                   /*     if (isAdjPlus)
                          {
                            subTotal = subTotal + double.parse(value.isNotEmpty ? value : "0.0");
                          }
                        else
                          {
                            subTotal = subTotal - double.parse(value.isNotEmpty ? value : "0.0");
                          }*/
                      },
                    )
                ),
                Container(
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(width: 1, color: kLightPurple),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                        shape: BoxShape.rectangle
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: TextField(
                      controller: remarkController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      textAlign: TextAlign.start,
                      cursorColor: black,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: black,),
                      decoration: InputDecoration(
                        hintText: "Remark",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kLightPurple, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: kLightPurple, width: 0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: kBlue, fontSize: 14),
                      ),
                      onChanged: (text) {
                      },
                    )
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
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

                print("listProduct--->" + listProduct.length.toString());
                if(listProduct.isEmpty) {
                  isValidProduct = false;
                }

                if (!isValidCustomer) {
                  showSnackBar("Please select customer", context);
                } else if (!isValidProduct) {
                  showSnackBar("Please select product", context);
                } else {
                  if (isInternetConnected) {
                    _saveOrderCall();
                  } else {
                    noInterNet(context);
                  }
                }
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

  void getItemCalculation(Products product, int index) {
    setState(() {
      product.itemPrice = 0.0;

      if (product.quantity == 1) {
        product.itemPrice = double.parse(product.itemPrice.toString()) + double.parse(product.stockPrice.toString());
      } else {
        var total = double.parse(product.stockPrice.toString()) * product.quantity;
        product.itemPrice = double.parse(product.itemPrice.toString()) + total;
      }
    });
  }

  void getPriceCalculated() {
    setState(() {
      subTotal = 0.0;

      for (var i = 0; i < listProduct.length; i++) {
        // print("subTotal ==== " + subTotal.toString());
        if (listProduct[i].quantity == 1) {
          subTotal = subTotal + double.parse(listProduct[i].stockPrice.toString());
        } else {
          var total = double.parse(listProduct[i].stockPrice.toString()) * listProduct[i].quantity;
          subTotal = subTotal + total;
        }
      }


      if (discountController.value.text.isNotEmpty) {
        var value = discountController.value.text;
        subTotal = subTotal - double.parse(value.isNotEmpty ? value : "0");
      }

      if (adjustmentController.value.text.isNotEmpty) {
        var value = adjustmentController.value.text;

        // print("value ==== $value");
        // print("subTotal ==== $subTotal");

        if (isAdjPlus)
        {
          var total = subTotal + (double.parse(value.isNotEmpty ? value : "0.0"));
          subTotal = total;
        }
        else
        {
          var total = subTotal - (double.parse(value.isNotEmpty ? value : "0.0"));
          subTotal = total;
        }
      }

    });
  }

  Future<void> _redirectToAddItem(BuildContext context, List<Products> listProductData, bool isFromDetail) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectProductPageOld(listProductData, isFromDetail)),
    );

    print("result ===== $result");
    setState(() {
      listProduct = [];
      subTotal = 0.0;
      if (result != null) {
        listProduct = result;

        for(var i = 0; i < listProduct.length; i++) {
          if (subTotal == 0.0) {
            subTotal = double.parse(listProduct[i].stockPrice.toString());
          }else {
            subTotal = subTotal + double.parse(listProduct[i].stockPrice.toString());
          }

          getItemCalculation(listProduct[i], i);
        }
      }
      isValidProduct = true;

    });

    if (result == "success") {
      setState(() {
      });
    }
  }

  /*Future<void> _redirectToAddItem(BuildContext context, List<ItemData> listProductData))  async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectProductPage(listProductData)),//SelectProductPage(listProductData)),
    );

    print("result ===== $result");
    setState(() {
      listProduct = [];
      subTotal = 0.0;
      if (result != null)
        {
          listProduct = result;

          for(var i = 0; i < listProduct.length; i++) {
            if (subTotal == 0.0) {
              subTotal = double.parse(listProduct[i].stockPrice.toString());
            }else {
              subTotal = subTotal + double.parse(listProduct[i].stockPrice.toString());
            }
          }

        }

      isValidProduct = true;
    });

    if (result == "success") {
      setState(() {
      });
    }
  }*/

  Future<void> _redirectToAddCustomer(BuildContext context, CustomerList customerData) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectCustomerListPage(customerData)),
    );

    print("result ===== $result");
    setState(() {
      customerDetail = result;
      isValidCustomer = true;
    });

    if (result == "success") {
      setState(() {
      });
    }
  }

  /* void _makeJsonData() async {

    List<ItemData> listProductsTemp = List<ItemData>.empty(growable: true);
    for (int i = 0; i < listProduct.length; i++) {
        listProductsTemp.add(listProduct[i]);
    }

    if (listProductsTemp.isNotEmpty) {
      listProduct.clear();
      listProduct.addAll(listProductsTemp);
    }

    print("<><> Json Product ${jsonEncode(listProduct).toString().trim()} END<><>");

  }
*/
  void _makeJsonData() async {
    List<Products> listProductsTemp = List<Products>.empty(growable: true);
    for (int i = 0; i < listProduct.length; i++) {
      listProductsTemp.add(listProduct[i]);
    }

    if (listProductsTemp.isNotEmpty) {
      listProduct.clear();
      listProduct.addAll(listProductsTemp);
    }

    print("<><> Json Product ${jsonEncode(listProduct).toString().trim()} END<><>");

  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is AddOrderPage;
  }

  void _removeProduct(int index) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  color: white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 40,
                    alignment: Alignment.center,
                    color: kBlue,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text('Remove Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: black))
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: const Text('Are you sure want to remove this product?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.4, color: kBlue),
                                borderRadius:  BorderRadius.all(Radius.circular(kButtonCornerRadius)),
                              ),
                              margin: const EdgeInsets.only(right: 10),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:const Text('No', style:TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kBlue,))
                              ),
                            ),
                          ),
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kButtonCornerRadius),
                                color:kBlue,
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                  listProduct.removeAt(index);

                                  getPriceCalculated();
                                  getItemCalculation(listProduct[index], index);

                                  setState(() {
                                    if(listProduct.isEmpty) {
                                      isValidProduct = false;
                                    }
                                  });
                                },
                                child:
                                const Text('Yes', style:TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: white)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _saveOrderCall() async {
    _makeJsonData();

    setState(() {
      _isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + orderSave);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'emp_id' : sessionManager.getEmpId().toString().trim(),
      'products' : listProduct.isNotEmpty ? jsonEncode(listProduct).toString().trim() : "",
      'customer_id' : checkValidString(customerDetail.customerId),
      'company_id' : "RBC",
      'discount' : discountController.value.text.trim(),
      'adjustments' : isAdjPlus ? adjustmentController.value.text.trim() : "-${adjustmentController.value.text.trim()}",
      'total_amount' : subTotal.toString(),
      'remark' : remarkController.value.text.trim(),
      'order_status' :'',
      'FromDate' : '',
      'ToDate' : '',
    };

    final response = await http.post(url, body: jsonBody);

    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      setState(() {
        _isLoading = false;
        tabNavigationReload();
      });
      showSnackBar(dataResponse.message, context);

      Navigator.pop(context, "success");

    }else {
      setState(() {
        _isLoading = false;
      });
    }
  }

}