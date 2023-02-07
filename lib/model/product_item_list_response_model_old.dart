import 'dart:convert';
/// success : 1
/// message : "Item List"
/// item_data : [{"category_id":"1","category_name":"Dairy & Bakery","crated_at":"1668507999","status":"1","products":[{"stock_id":"1","tally_id":"168","stock_name":"Biscreme -B Shortening14kg Bi","stock_price":"2500","category_id":"1","parent":"3F STOCK","gst_applicable":"","tcs_applicable":"","description":"Ideal for crisp and delicious cookies.Gives uniform crumb structure. Disperses well. Increases shelf-life of products","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"NOS","additional_units":"","tcs_category":"","gst_rep_um":"","gst_item_units":"NOS","hsn_id":"8","cess":"","created_at":"1669014184","updated_at":"1669014184","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"0","item_denominator":"0","integrated_tax":"18"},{"stock_id":"2","tally_id":"172","stock_name":"Item1","stock_price":"1000","category_id":"1","parent":"Finish Goods","gst_applicable":"","tcs_applicable":"","description":"","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"NOS","additional_units":"","tcs_category":"","gst_rep_um":"","gst_item_units":"NOS","hsn_id":"9","cess":"","created_at":"1669014184","updated_at":"1669014184","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"0","item_denominator":"0","integrated_tax":"18"},{"stock_id":"3","tally_id":"186","stock_name":"Item2","stock_price":"1000","category_id":"1","parent":"Finish Goods","gst_applicable":"","tcs_applicable":"","description":"","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"NOS","additional_units":"","tcs_category":"","gst_rep_um":"","gst_item_units":"NOS","hsn_id":"10","cess":"","created_at":"1669014184","updated_at":"1669014184","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"0","item_denominator":"0","integrated_tax":"0"}]},{"category_id":"2","category_name":"Fruits & Vegitables","crated_at":"1668507999","status":"1","products":[{"stock_id":"5","tally_id":"","stock_name":"Soda","stock_price":"1000","category_id":"2","parent":"Finish Goods","gst_applicable":"","tcs_applicable":"","description":"","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"Bottle","additional_units":"","tcs_category":"","gst_rep_um":"","gst_item_units":"Bottle","hsn_id":"10","cess":"","created_at":"1667818690","updated_at":"","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"0","item_denominator":"0","integrated_tax":"0"},{"stock_id":"6","tally_id":"","stock_name":"Meggi","stock_price":"1000","category_id":"2","parent":"Finish Goods","gst_applicable":"","tcs_applicable":"","description":"","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"Packet","additional_units":"","tcs_category":"","gst_rep_um":"","gst_item_units":"Packet","hsn_id":"10","cess":"","created_at":"1667818690","updated_at":"","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"0","item_denominator":"0","integrated_tax":"0"},{"stock_id":"7","tally_id":"","stock_name":"TV","stock_price":"1000","category_id":"2","parent":"Finish Goods","gst_applicable":"","tcs_applicable":"","description":"","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"Unit","additional_units":"","tcs_category":"","gst_rep_um":"","gst_item_units":"Unit","hsn_id":"10","cess":"","created_at":"1667818690","updated_at":"","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"0","item_denominator":"0","integrated_tax":"0"}]}]

ProductItemListResponseModelOld productItemListResponseModelFromJson(String str) => ProductItemListResponseModelOld.fromJson(json.decode(str));
String productItemListResponseModelToJson(ProductItemListResponseModelOld data) => json.encode(data.toJson());
class ProductItemListResponseModelOld {
  ProductItemListResponseModelOld({
      num? success, 
      String? message, 
      List<ItemDataOld>? itemDataOld,}){
    _success = success;
    _message = message;
    _itemDataOld = itemDataOld;
}

  ProductItemListResponseModelOld.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['item_data_old'] != null) {
      _itemDataOld = [];
      json['item_data_old'].forEach((v) {
        _itemDataOld?.add(ItemDataOld.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  List<ItemDataOld>? _itemDataOld;
ProductItemListResponseModelOld copyWith({  num? success,
  String? message,
  List<ItemDataOld>? itemDataOld,
}) => ProductItemListResponseModelOld(  success: success ?? _success,
  message: message ?? _message,
  itemDataOld: itemDataOld ?? _itemDataOld,
);
  num? get success => _success;
  String? get message => _message;
  List<ItemDataOld>? get itemDataOld => _itemDataOld;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_itemDataOld != null) {
      map['item_data_old'] = _itemDataOld?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// category_id : "1"
/// category_name : "Dairy & Bakery"
/// crated_at : "1668507999"
/// status : "1"
/// products : [{"stock_id":"1","tally_id":"168","stock_name":"Biscreme -B Shortening14kg Bi","stock_price":"2500","category_id":"1","parent":"3F STOCK","gst_applicable":"","tcs_applicable":"","description":"Ideal for crisp and delicious cookies.Gives uniform crumb structure. Disperses well. Increases shelf-life of products","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"NOS","additional_units":"","tcs_category":"","gst_rep_um":"","gst_item_units":"NOS","hsn_id":"8","cess":"","created_at":"1669014184","updated_at":"1669014184","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"0","item_denominator":"0","integrated_tax":"18"},{"stock_id":"2","tally_id":"172","stock_name":"Item1","stock_price":"1000","category_id":"1","parent":"Finish Goods","gst_applicable":"","tcs_applicable":"","description":"","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"NOS","additional_units":"","tcs_category":"","gst_rep_um":"","gst_item_units":"NOS","hsn_id":"9","cess":"","created_at":"1669014184","updated_at":"1669014184","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"0","item_denominator":"0","integrated_tax":"18"},{"stock_id":"3","tally_id":"186","stock_name":"Item2","stock_price":"1000","category_id":"1","parent":"Finish Goods","gst_applicable":"","tcs_applicable":"","description":"","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"NOS","additional_units":"","tcs_category":"","gst_rep_um":"","gst_item_units":"NOS","hsn_id":"10","cess":"","created_at":"1669014184","updated_at":"1669014184","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"0","item_denominator":"0","integrated_tax":"0"}]

ItemDataOld itemDataOldFromJson(String str) => ItemDataOld.fromJson(json.decode(str));
String itemDataOldToJson(ItemDataOld data) => json.encode(data.toJson());
class ItemDataOld {
  ItemDataOld({
      String? categoryId, 
      String? categoryName, 
      String? cratedAt, 
      String? status,
      bool? isSelected,

    List<Products>? products,}){
    _categoryId = categoryId;
    _categoryName = categoryName;
    _cratedAt = cratedAt;
    _status = status;
    _products = products;
    _isSelected = isSelected;
}

  set isSelected(bool? value) {
    _isSelected = value;
  }


  ItemDataOld.fromJson(dynamic json) {
    _categoryId = json['category_id'];
    _categoryName = json['category_name'];
    _cratedAt = json['crated_at'];
    _status = json['status'];
    _isSelected = json['isSelected'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products?.add(Products.fromJson(v));
      });
    }
  }
  String? _categoryId;
  String? _categoryName;
  String? _cratedAt;
  String? _status;
  bool? _isSelected;
  List<Products>? _products;
ItemDataOld copyWith({  String? categoryId,
  String? categoryName,
  String? cratedAt,
  String? status,
  bool? isSelected,
  List<Products>? products,
}) => ItemDataOld(  categoryId: categoryId ?? _categoryId,
  categoryName: categoryName ?? _categoryName,
  cratedAt: cratedAt ?? _cratedAt,
  status: status ?? _status,
  isSelected: isSelected ?? _isSelected,
  products: products ?? _products,
);
  String? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  String? get cratedAt => _cratedAt;
  String? get status => _status;
  bool? get isSelected => _isSelected;
  List<Products>? get products => _products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category_id'] = _categoryId;
    map['category_name'] = _categoryName;
    map['crated_at'] = _cratedAt;
    map['status'] = _status;
    map['isSelected'] = _isSelected;
    if (_products != null) {
      map['products'] = _products?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// stock_id : "1"
/// tally_id : "168"
/// stock_name : "Biscreme -B Shortening14kg Bi"
/// stock_price : "2500"
/// category_id : "1"
/// parent : "3F STOCK"
/// gst_applicable : ""
/// tcs_applicable : ""
/// description : "Ideal for crisp and delicious cookies.Gives uniform crumb structure. Disperses well. Increases shelf-life of products"
/// gst_type_supply : ""
/// valuation_method : "Avg. Cost"
/// base_units : "NOS"
/// additional_units : ""
/// tcs_category : ""
/// gst_rep_um : ""
/// gst_item_units : "NOS"
/// hsn_id : "8"
/// cess : ""
/// created_at : "1669014184"
/// updated_at : "1669014184"
/// deleted_at : ""
/// is_deleted : "0"
/// status : "Y"
/// company_id : "1"
/// item_conversion : "0"
/// item_denominator : "0"
/// integrated_tax : "18"

Products productsFromJson(String str) => Products.fromJson(json.decode(str));
String productsToJson(Products data) => json.encode(data.toJson());
class Products {
  Products({
      String? stockId, 
      String? tallyId, 
      String? stockName, 
      String? stockPrice, 
      String? categoryId, 
      String? parent, 
      String? gstApplicable, 
      String? tcsApplicable, 
      String? description, 
      String? gstTypeSupply, 
      String? valuationMethod, 
      String? baseUnits, 
      String? additionalUnits, 
      String? tcsCategory, 
      String? gstRepUm, 
      String? gstItemUnits, 
      String? hsnId, 
      String? cess, 
      String? createdAt, 
      String? updatedAt, 
      String? deletedAt, 
      String? isDeleted, 
      String? status, 
      String? companyId, 
      String? itemConversion, 
      String? itemDenominator, 
      String? integratedTax,
      bool? isProductSelected,
    num quantity = 0,
    String? inStock,
    String? orderCount
  }){
    _stockId = stockId;
    _tallyId = tallyId;
    _stockName = stockName;
    _stockPrice = stockPrice;
    _categoryId = categoryId;
    _parent = parent;
    _gstApplicable = gstApplicable;
    _tcsApplicable = tcsApplicable;
    _description = description;
    _gstTypeSupply = gstTypeSupply;
    _valuationMethod = valuationMethod;
    _baseUnits = baseUnits;
    _additionalUnits = additionalUnits;
    _tcsCategory = tcsCategory;
    _gstRepUm = gstRepUm;
    _gstItemUnits = gstItemUnits;
    _hsnId = hsnId;
    _cess = cess;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _isDeleted = isDeleted;
    _status = status;
    _companyId = companyId;
    _itemConversion = itemConversion;
    _itemDenominator = itemDenominator;
    _integratedTax = integratedTax;
    _isProductSelected = isProductSelected;
    _quantity = quantity;
    _inStock = inStock;
    _orderCount = orderCount;
  }

  set isProductSelected(bool? value) {
    _isProductSelected = value;
  }

  set quantity(num value) {
    _quantity = value;
  }

  Products.fromJson(dynamic json) {
    _stockId = json['stock_id'];
    _tallyId = json['tally_id'];
    _stockName = json['stock_name'];
    _stockPrice = json['stock_price'];
    _categoryId = json['category_id'];
    _parent = json['parent'];
    _gstApplicable = json['gst_applicable'];
    _tcsApplicable = json['tcs_applicable'];
    _description = json['description'];
    _gstTypeSupply = json['gst_type_supply'];
    _valuationMethod = json['valuation_method'];
    _baseUnits = json['base_units'];
    _additionalUnits = json['additional_units'];
    _tcsCategory = json['tcs_category'];
    _gstRepUm = json['gst_rep_um'];
    _gstItemUnits = json['gst_item_units'];
    _hsnId = json['hsn_id'];
    _cess = json['cess'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _isDeleted = json['is_deleted'];
    _status = json['status'];
    _companyId = json['company_id'];
    _itemConversion = json['item_conversion'];
    _itemDenominator = json['item_denominator'];
    _integratedTax = json['integrated_tax'];
    _isProductSelected = json['isProductSelected'];
    _inStock = json['in_stock'];
    _orderCount = json['order_count'];
  }
  String? _stockId;
  String? _tallyId;
  String? _stockName;
  String? _stockPrice;
  String? _categoryId;
  String? _parent;
  String? _gstApplicable;
  String? _tcsApplicable;
  String? _description;
  String? _gstTypeSupply;
  String? _valuationMethod;
  String? _baseUnits;
  String? _additionalUnits;
  String? _tcsCategory;
  String? _gstRepUm;
  String? _gstItemUnits;
  String? _hsnId;
  String? _cess;
  String? _createdAt;
  String? _updatedAt;
  String? _deletedAt;
  String? _isDeleted;
  String? _status;
  String? _companyId;
  String? _itemConversion;
  String? _itemDenominator;
  String? _integratedTax;
  bool? _isProductSelected;
  num _quantity = 1;
  String? _inStock;
  String? _orderCount;


  Products copyWith({
    String? stockId,
  String? tallyId,
  String? stockName,
  String? stockPrice,
  String? categoryId,
  String? parent,
  String? gstApplicable,
  String? tcsApplicable,
  String? description,
  String? gstTypeSupply,
  String? valuationMethod,
  String? baseUnits,
  String? additionalUnits,
  String? tcsCategory,
  String? gstRepUm,
  String? gstItemUnits,
  String? hsnId,
  String? cess,
  String? createdAt,
  String? updatedAt,
  String? deletedAt,
  String? isDeleted,
  String? status,
  String? companyId,
  String? itemConversion,
  String? itemDenominator,
  String? integratedTax,
    bool? isProductSelected,
    num quantity = 1,
    String? inStock,
    String? orderCount

}) => Products(  stockId: stockId ?? _stockId,
      tallyId: tallyId ?? _tallyId,
      stockName: stockName ?? _stockName,
      stockPrice: stockPrice ?? _stockPrice,
      categoryId: categoryId ?? _categoryId,
      parent: parent ?? _parent,
      gstApplicable: gstApplicable ?? _gstApplicable,
      tcsApplicable: tcsApplicable ?? _tcsApplicable,
      description: description ?? _description,
      gstTypeSupply: gstTypeSupply ?? _gstTypeSupply,
      valuationMethod: valuationMethod ?? _valuationMethod,
      baseUnits: baseUnits ?? _baseUnits,
      additionalUnits: additionalUnits ?? _additionalUnits,
      tcsCategory: tcsCategory ?? _tcsCategory,
      gstRepUm: gstRepUm ?? _gstRepUm,
      gstItemUnits: gstItemUnits ?? _gstItemUnits,
      hsnId: hsnId ?? _hsnId,
      cess: cess ?? _cess,
      createdAt: createdAt ?? _createdAt,
      updatedAt: updatedAt ?? _updatedAt,
      deletedAt: deletedAt ?? _deletedAt,
      isDeleted: isDeleted ?? _isDeleted,
      status: status ?? _status,
      companyId: companyId ?? _companyId,
      itemConversion: itemConversion ?? _itemConversion,
      itemDenominator: itemDenominator ?? _itemDenominator,
      integratedTax: integratedTax ?? _integratedTax,
      isProductSelected: isProductSelected ?? _isProductSelected,
      quantity: quantity ?? _quantity,
      inStock: inStock ?? _inStock,
      orderCount: orderCount ?? _orderCount,

);
  String? get stockId => _stockId;
  String? get tallyId => _tallyId;
  String? get stockName => _stockName;
  String? get stockPrice => _stockPrice;
  String? get categoryId => _categoryId;
  String? get parent => _parent;
  String? get gstApplicable => _gstApplicable;
  String? get tcsApplicable => _tcsApplicable;
  String? get description => _description;
  String? get gstTypeSupply => _gstTypeSupply;
  String? get valuationMethod => _valuationMethod;
  String? get baseUnits => _baseUnits;
  String? get additionalUnits => _additionalUnits;
  String? get tcsCategory => _tcsCategory;
  String? get gstRepUm => _gstRepUm;
  String? get gstItemUnits => _gstItemUnits;
  String? get hsnId => _hsnId;
  String? get cess => _cess;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get deletedAt => _deletedAt;
  String? get isDeleted => _isDeleted;
  String? get status => _status;
  String? get companyId => _companyId;
  String? get itemConversion => _itemConversion;
  String? get itemDenominator => _itemDenominator;
  String? get integratedTax => _integratedTax;
  bool? get isProductSelected => _isProductSelected;
  num get quantity => _quantity;
  String? get inStock => _inStock;
  String? get orderCount => _orderCount;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = _stockId;
    map['quantity'] = _quantity;
    map['instock'] = _inStock;
    map['price'] = _stockPrice;

    /*map['tally_id'] = _tallyId;
    map['stock_name'] = _stockName;
    map['category_id'] = _categoryId;
    map['parent'] = _parent;
    map['gst_applicable'] = _gstApplicable;
    map['tcs_applicable'] = _tcsApplicable;
    map['description'] = _description;
    map['gst_type_supply'] = _gstTypeSupply;
    map['valuation_method'] = _valuationMethod;
    map['base_units'] = _baseUnits;
    map['additional_units'] = _additionalUnits;
    map['tcs_category'] = _tcsCategory;
    map['gst_rep_um'] = _gstRepUm;
    map['gst_item_units'] = _gstItemUnits;
    map['hsn_id'] = _hsnId;
    map['cess'] = _cess;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    map['is_deleted'] = _isDeleted;
    map['status'] = _status;
    map['company_id'] = _companyId;
    map['item_conversion'] = _itemConversion;
    map['item_denominator'] = _itemDenominator;
    map['integrated_tax'] = _integratedTax;
    map['isProductSelected'] = _isProductSelected;

    map['order_count'] = _orderCount;*/

    return map;
  }

}