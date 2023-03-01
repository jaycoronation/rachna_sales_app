/*
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../Model/common_response_model.dart';
import '../constant/color.dart';
import '../model/ProductCategoryList.dart';
import '../model/category_response_model.dart';
import '../model/product_item_data_response_model.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import 'add_product_page.dart';

class ProductListPage extends StatefulWidget {
  ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends BaseState<ProductListPage> with TickerProviderStateMixin  {
  bool _isLoading = false;
  TextEditingController searchController = TextEditingController();
  var searchText = "";

  var listCategory = List<CategoryDetails>.empty(growable: true);
  var listProduct = List<ItemData>.empty(growable: true);
  List<ItemData> _templistProduct = [];

  var selectedCategoryName = "";
  var selectedCategoryId = "1";
  var selectedCategoryProductCount = "";

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 20;
  bool _isLastPage = false;

  List<Tab> _tabs = [];
  String tabTitle = "";
  List<String> tabTitles = [];

  Map<String, List<ItemData>> listHashMap = HashMap();

  late ScrollController _scrollViewController;
  bool isScrollingDown = false;
  late TabController _tabController;

  List<ProductCategoryList> listProductTemp = [];

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }

      pagination();

    });

    if(isInternetConnected) {
      _makeCategoryListProduct();

    }else {
      noInterNet(context);
    }
  }

  void pagination() {
    if(!_isLastPage && !_isLoadingMore)
    {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          _getItemListData(false);
        });
      }
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
          title:  const Text("Product List",
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
          actions: [
            GestureDetector(
              onTap: () {
                _redirectToAddProduct(context, ItemData(), false);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12, right: 10),
                height: 34,
                width: 36,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: kLightestPurple),
                    borderRadius: const BorderRadius.all(Radius.circular(14.0),),
                    color: white,
                    shape: BoxShape.rectangle
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.add, color: kBlue, size: 21,),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
          backgroundColor: kBlue,
        ),
        body: _isLoading
            ? const LoadingWidget()
            : Column(
          children: [
            // Container(
            //   color: kBlue,
            //   alignment: Alignment.topLeft,
            //   padding: const EdgeInsets.only(left: 22, top: 10, bottom: 20),
            //   child: const Text("Product List", style: TextStyle(fontWeight: FontWeight.w700, color: white,fontSize: 20)),
            // ),
            Container(
              color: kLightestPurple,
              child: Column(
                children: [
                  Container(height: 36, width: double.infinity,
                    margin: const EdgeInsets.only(left: 12, right: 12, top: 20),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: kBlue,
                      labelColor: kBlue,
                      unselectedLabelColor: kBlue,
                      tabs: _tabs,
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(width: 1, color: kLightPurple),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          shape: BoxShape.rectangle
                      ),
                      margin: const EdgeInsets.only(left: 15, right: 15,top: 12,bottom: 12),
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

 searchController.text = text;
                              searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                              if(text.isEmpty) {
                                searchText = "";
                                _getItemListData();
                              }else if(text.length > 3) {
                                searchText = searchController.text.toString().trim();
                                // _getItemListData();
                              }


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
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: listProductTemp.isEmpty
                    ? <Widget>[]
                    : listProductTemp.map((dynamicContent) {
                  return Column(
                    children: [
                      Container(
                        color: white,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 20, top: 10, bottom: 15),
                        child:RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: dynamicContent.message,
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
                                    margin: const EdgeInsets.only(right: 70,left: 20),
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
                              itemCount: dynamicContent.itemData?.length,
                              itemBuilder: (ctx, index) => InkWell(
                                hoverColor: Colors.white.withOpacity(0.0),
                                onTap: () async {
                                  _redirectToAddProduct(context, _templistProduct.isNotEmpty ? _templistProduct[index] : listProduct[index], true);
                                },
                                child: Container(
                                  color: white,
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      if(_templistProduct != null && _templistProduct.length > 0)
                                      {
                                        setState(() {
                                          if(_templistProduct[index].isSelected ?? false) {
                                            _templistProduct[index].isSelected = false;
                                          }else {
                                            _templistProduct[index].isSelected = true;
                                          }
                                        });
                                      }
                                      else
                                      {
                                        setState(() {
                                          if(listProduct[index].isSelected ?? false) {
                                            listProduct[index].isSelected = false;
                                          }else {
                                            listProduct[index].isSelected = true;
                                          }
                                        });
                                      }
                                    },
                                    child: _showBottomSheetForProductsList(index,dynamicContent.itemData),
                                  ),
                                ),
                              ))
                      ),
                      if (_isLoadingMore == true)
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                              const Text(' Loading more...',
                                  style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                              )
                            ],
                          ),
                        ),
                    ],
                  );
                }
                ).toList(),
              ),
            ),
ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: listProductTemp.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          color: white,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 15),
                          child:RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: listProductTemp[_tabController.index].message,
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
                                      margin: const EdgeInsets.only(right: 70,left: 20),
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
                                itemCount:(_templistProduct.isNotEmpty)
                                    ? _templistProduct.length : listProduct.length,
                                itemBuilder: (ctx, index) => InkWell(
                                  hoverColor: Colors.white.withOpacity(0.0),
                                  onTap: () async {
                                    _redirectToAddProduct(context, _templistProduct.isNotEmpty ? _templistProduct[index] : listProduct[index], true);
                                  },
                                  child: Container(
                                    color: white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 5),
                                      child: _showBottomSheetForProductsList(index,_templistProduct.isNotEmpty ? _templistProduct : listProduct),
                                    ),
                                  ),
                                ))
                        ),
                        if (_isLoadingMore == true)
                          Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                                const Text(' Loading more...',
                                    style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                                )
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),

          ],
        ),
      ),
    );
  }

  List<Tab> getTabs(List<String> count) {
    _tabs.clear();

    for (int i = 0; i < count.length; i++) {
      _tabs.add(getTab(toDisplayCase(count[i].toString())));
    }
    print("SIZE ==== ${_tabs.length}");
    _tabController = getTabController();


    getTabListener();
    return _tabs;
  }

  Tab getTab(String tabTitle) {
    return Tab(
      child: Text(tabTitle, style: const TextStyle(color: black,fontSize: 14,fontWeight: FontWeight.w600),),
    );
  }

  TabController getTabController() {
    return TabController(length: _tabs.length, vsync: this);
  }

  getTabListener() {
    _tabController.addListener(() {
      if (_tabController.indexIsChanging)
      {
        setState(() {
          selectedCategoryId = listCategory[_tabController.index].categoryId.toString();
        });
      }
    });
  }

  List<ItemData> _buildSearchListForProducts(String productSearchTerm) {
    List<ItemData> _searchList = [];
    for (int i = 0; i < listProduct.length; i++) {
      String name = listProduct[i].stockName.toString().trim();
      if (name.toLowerCase().contains(productSearchTerm.toLowerCase())) {
        _searchList.add(listProduct[i]);
      }
    }
    return _searchList;
  }

  Widget _showBottomSheetForProductsList(int index, List<ItemData>? listData) {
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                          child: Text(listData?[index].stockName.toString() ?? "Test",
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: 13)
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          child: Text("MRP ${checkValidString(listData?[index].stockPrice)}",
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
                  margin: const EdgeInsets.only(top:5, bottom: 5, left: 8),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Text(checkValidString(listData?[index].stockQuantity),
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
                  margin: const EdgeInsets.only(top:5, bottom: 5, right: 8, left:30),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Text(checkValidString(listData?[index].orderCount),
                        style: const TextStyle(fontWeight: FontWeight.w500, color: kBlue, fontSize: 12)
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_outlined, color: black, size: 24),
                  iconSize: 24,
                  alignment: Alignment.center,
                  onPressed: () async {

                    if(_templistProduct.isNotEmpty) {
                      _deleteProduct(_templistProduct[index], index);
                    }else {
                      _deleteProduct(listProduct[index], index);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        Container(
            margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            height: index == 8-1 ? 0 : 0.8, color: kLightPurple),
      ],
    );

  }

  @override
  void castStatefulWidget() {
    widget is ProductListPage;
  }

  Future<void> _redirectToAddProduct(BuildContext context, ItemData getSet, bool isFromList) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductPage(getSet, isFromList)),
    );

    print("result ===== $result");

    if (result == "success") {
      _getItemListData();
      setState(() {
      });
    }
  }


  void _deleteProduct(ItemData product, int index) {
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
                      child: const Text('Delete product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: black))
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: const Text('Are you sure want to delete this product?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black)),
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
                                  _makeDeleteCustomerRequest(product, index);
                                },
                                child:
                                const Text('Yes',style:TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: white)),
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

  //API call function...
  _getItemListData([bool isFirstTime = false]) async {
    if (isFirstTime) {
      setState(() {
        _isLoading = true;
        _isLoadingMore = false;
        _pageIndex = 0;
        _isLastPage = false;
      });
    }

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + itemList);

    Map<String, String> jsonBody = {
      'from_app' : FROM_APP,
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
      'category_id' : selectedCategoryId,
      'search' : '',
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> itemData = jsonDecode(body);
    var dataResponse = ProductItemDataResponseModel.fromJson(itemData);

    if (isFirstTime) {
      if (listProduct.isNotEmpty) {
        listProduct = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1)
    {
      if (dataResponse.itemData != null)
      {
        List<ItemData>? _tempList = [];
        _tempList = dataResponse.itemData;

        listProduct.addAll(_tempList!);

        print(listProduct.length);

        if (_tempList.isNotEmpty)
        {
          _pageIndex += 1;
          if (_tempList.isEmpty || _tempList.length % _pageResult != 0)
          {
            _isLastPage = true;
          }
        }
      }

      for (var i=0; i < listCategory.length; i++)
      {
        for (var j=0; j < listProduct.length; j++)
        {
          if (listCategory[i].categoryId == listProduct[j].categoryId)
          {

            listHashMap[listCategory[j].categoryName ?? ""] = listProduct;

            ProductCategoryList getSet = ProductCategoryList();
            getSet.message = listCategory[j].categoryName ?? "";
            getSet.itemData?.add(listProduct[i]);
            listProductTemp.add(getSet);
          }
        }

        print("listProductTemp ===== ${ listProductTemp.length} ");
      }


      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });

    }
    else
    {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;

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
      listCategory = [];
      if(dataResponse.categoryDetails != null) {
        if(dataResponse.categoryDetails!.isNotEmpty) {
          listCategory = dataResponse.categoryDetails ?? [];

          for (var i=0; i < listCategory.length; i++)
          {
            tabTitles.add(listCategory[i].categoryName.toString());
          }

          print("${tabTitles.length} ==== TOTAL LENGHT FOR TABS");

          setState(() {
            _tabs = getTabs(tabTitles);
          });

        }
      }

    } else {

    }

    _getItemListData(true);
  }


  void _makeDeleteCustomerRequest(ItemData product, int index) async {
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + deleteStock);

    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'stock_id': checkValidString(product.stockId.toString().trim()),
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);

      setState(() {
        searchController.text = "";
        searchText = "";
        _templistProduct.clear();
        listProduct.remove(product);
        FocusScope.of(context).unfocus();

        _isLoading = false;
        tabNavigationReload();
      });

    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

}
*/
