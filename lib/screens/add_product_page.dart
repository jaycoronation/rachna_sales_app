import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/Product_item_list_response_model.dart';
import 'package:salesapp/model/category_response_model.dart';

import '../Model/common_response_model.dart';
import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class AddProductPage extends StatefulWidget {
  final Products getSet;
  final bool isFromList;
  const AddProductPage(this.getSet, this.isFromList, {Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends BaseState<AddProductPage> {
  bool _isLoading = false;
  List<CategoryDetails> listCategories = List<CategoryDetails>.empty();
  List<CategoryDetails> _tempListCategories = List<CategoryDetails>.empty(growable: true);
  var categoryIdApi = "";

  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _itemGroupController = TextEditingController();
  TextEditingController _itemUnitController = TextEditingController();
  TextEditingController _itemAlterUnitController = TextEditingController();
  TextEditingController _itemConversionController = TextEditingController();
  TextEditingController _itemDenominatorController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _valuationController = TextEditingController();
  TextEditingController _hsnController = TextEditingController();
  TextEditingController _gstController = TextEditingController();
  TextEditingController _companyIDController = TextEditingController();
  TextEditingController _tallyIDController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  FocusNode inputNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if ((widget as AddProductPage).isFromList) {

      _itemNameController.text = checkValidString((widget as AddProductPage).getSet.stockName).toString();
      _itemPriceController.text = checkValidString((widget as AddProductPage).getSet.stockPrice).toString();
      _itemGroupController.text = checkValidString((widget as AddProductPage).getSet.tcsCategory).toString();
      _itemUnitController.text = checkValidString((widget as AddProductPage).getSet.baseUnits).toString();
      _itemAlterUnitController.text = checkValidString((widget as AddProductPage).getSet.additionalUnits).toString();
      _itemConversionController.text = checkValidString((widget as AddProductPage).getSet.itemConversion).toString();

      _itemDenominatorController.text = checkValidString((widget as AddProductPage).getSet.itemDenominator).toString();
      _descriptionController.text = checkValidString((widget as AddProductPage).getSet.description).toString();
      _valuationController.text = checkValidString((widget as AddProductPage).getSet.valuationMethod).toString();
      _hsnController.text = checkValidString((widget as AddProductPage).getSet.hsnId).toString();
      // _gstController.text = checkValidString((widget as AddProductPage).getSet).toString();

      categoryIdApi = checkValidString((widget as AddProductPage).getSet.categoryId).toString();
    }

    if(isInternetConnected) {
      _makeCategoryListProduct();
    }else {
      noInterNet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 55,
        automaticallyImplyLeading: false,
        title: const Text(""),
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
          : LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        color: kBlue,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 22, top: 10, bottom: 15),
                        child: Text((widget as AddProductPage).isFromList ? "Update Product" : "Add Product",
                            style: TextStyle(fontWeight: FontWeight.w700, color: white, fontSize: 20)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _itemNameController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _itemPriceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Price',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter. digitsOnly
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _itemGroupController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Group',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _categoryController,
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Select Category',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                          onTap: () {
                            _showCategoriesDialog(context);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _itemUnitController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Unit Type',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _itemAlterUnitController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Alter Unit',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _itemConversionController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Conversion',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _itemDenominatorController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Denominator',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _descriptionController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _valuationController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Valuation',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _hsnController,
                          maxLength: 8,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'HSN No.',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _gstController,
                          maxLength: 15,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'GST No',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      /*Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _companyIDController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Company Id',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _tallyIDController,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Tally Id',
                            counterText: '',
                            prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          ),
                        ),
                      ),*/
                      Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 10, left: 20, right: 20),
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
                            String name = _itemNameController.text.toString();
                            String price = _itemPriceController.text.toString();
                            String hsn = _hsnController.text.toString();
                            String gstNo = _gstController.text.toString();

                            if (name.trim().isEmpty) {
                              showSnackBar("Please enter a item name", context);
                            } else if (price.trim().isEmpty) {
                              showSnackBar("Price can't be empty", context);
                            } else if(hsn.isEmpty) {
                              showSnackBar('Please enter HSN Code',context);
                              /* } else if (amount.trim().isEmpty) {
                              showToast("Please enter amount");*/
                            }else if (gstNo.isNotEmpty && !isValidGSTNo(gstNo.trim())) {
                              showSnackBar('Please enter valid GST number',context);
                            } else {
                              if(isInternetConnected) {
                                _makeCallAddProduct();
                              }else{
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
              ),
            );
          }
      ),
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is AddProductPage;
  }

  void _showCategoriesDialog(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.88,
                child: Column(children: [
                  Container(
                      width: 60,
                      margin: const EdgeInsets.only(top: 12),
                      child: const Divider(
                        height: 1.5,
                        thickness: 1.5,
                        color: kBlue,
                      )),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    child: const Text("Select Category", style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Container(height: 6),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _tempListCategories.isNotEmpty ? _tempListCategories.length : listCategories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              child: _tempListCategories.isNotEmpty
                                  ? _showBottomSheetForCategory(index, _tempListCategories)
                                  : _showBottomSheetForCategory(index, listCategories),
                              onTap: () {
                                setState(() {
                                  if (_tempListCategories.isNotEmpty) {
                                    _categoryController.text = checkValidString(toDisplayCase(_tempListCategories[index].categoryName.toString()));
                                    categoryIdApi = checkValidString(_tempListCategories[index].categoryId.toString());
                                    // _validateCategory = true;
                                  } else {
                                    _categoryController.text = checkValidString(toDisplayCase(listCategories[index].categoryName.toString()));
                                    categoryIdApi = checkValidString(listCategories[index].categoryId.toString());
                                    // _validateCategory = true;
                                  }
                                });
                                Navigator.of(context).pop();
                              });
                        }),
                  )

                ]));
          });
        });
  }

  Widget _showBottomSheetForCategory(int index, List<CategoryDetails> listData) {

    // for(var i= 0; i < listData.length; i++) {
    //   listData[i].isSelected = false;
    // }

    // for (var i=0; i < listCategories.length; i++) {
    //   for (var j=0; j < listData.length; j++) {
    //     if(listCategories[i].id == listData[j].id) {
    //       // businessTypesResponseModel.businessTypes![i].isSelected = true;
    //     }
    //   }
    // }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
          alignment: Alignment.centerLeft,
          child: listData[index].categoryName == _categoryController.text.toString()
              ? Text(
            checkValidString(toDisplayCase(listData[index].categoryName.toString())),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kBlue),
          )
              : Text(
            checkValidString(toDisplayCase(listData[index].categoryName.toString())),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        const Divider(
          thickness: 0.5,
          color: kTextLightGray,
          endIndent: 16,
          indent: 16,
        )
      ],
    );
  }

  _makeCallAddProduct() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + addStock);

    Map<String, String> jsonBody = {
    'TallyID': "1",
    'CmpID': "RBC",
    'ItemName': _itemNameController.value.text.trim(),
    'ItemPrice': _itemPriceController.value.text.trim(),
    'ItemGroup': _itemGroupController.value.text.trim(),
    'ItemUnit': _itemUnitController.value.text.trim(),
    'ItemAlterUnit': _itemAlterUnitController.value.text.trim(),
    'ItemConversion': _itemConversionController.value.text.trim(),
    'ItemDenominator': _itemDenominatorController.value.text.trim(),
    'description': _descriptionController.value.text.trim(),
    'valuationmethod': _valuationController.value.text.trim(),
    'hsncode': _hsnController.value.text.trim(),
    'GSTPer': _gstController.value.text.trim(),
    'from_app' : FROM_APP,
      'stock_id': (widget as AddProductPage).isFromList ? (widget as AddProductPage).getSet.stockId.toString() : "",
      'category_id': categoryIdApi

   };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      tabNavigationReload();

      Navigator.pop(context, "success");
      showSnackBar(dataResponse.message, context);

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

  _makeCategoryListProduct() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + categoryList);

    Map<String, String> jsonBody = {
      'from_app':FROM_APP,
    'page':'',
    'limit':''
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CategoryResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      listCategories = [];
      if(dataResponse.categoryDetails != null) {
        if(dataResponse.categoryDetails!.isNotEmpty) {
          listCategories = dataResponse.categoryDetails ?? [];
        }
      }

      setState(() {
        _isLoading = false;
      });
    }else {
      setState(() {
        _isLoading = false;
      });
    }
  }

}