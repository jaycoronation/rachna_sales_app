import 'dart:convert';
/// success : 1
/// message : "Item List"
/// item_data : [{"stock_id":"2341","tally_id":"1","stock_name":"Mango Bite","stock_price":"60","category_id":"2","parent":"toffee","gst_applicable":"","tcs_applicable":"","description":"Kosar mango from gir gujarat","gst_type_supply":"","valuation_method":"Avg. Cost","base_units":"Dozen","additional_units":"Per Piece","tcs_category":"","gst_rep_um":"","gst_item_units":"Dozen","hsn_id":"25862435","cess":"","created_at":"1675334365","updated_at":"","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","item_conversion":"1","item_denominator":"0","integrated_tax":"27","in_stock":"0","order_count":"0"}]

ProductItemDataResponseModel productItemDataResponseModelFromJson(String str) => ProductItemDataResponseModel.fromJson(json.decode(str));
String productItemDataResponseModelToJson(ProductItemDataResponseModel data) => json.encode(data.toJson());
class ProductItemDataResponseModel {
  ProductItemDataResponseModel({
      num? success, 
      String? message, 
      List<ItemData>? itemData,}){
    _success = success;
    _message = message;
    _itemData = itemData;
}

  ProductItemDataResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['item_data'] != null) {
      _itemData = [];
      json['item_data'].forEach((v) {
        _itemData?.add(ItemData.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  List<ItemData>? _itemData;
ProductItemDataResponseModel copyWith({  num? success,
  String? message,
  List<ItemData>? itemData,
}) => ProductItemDataResponseModel(  success: success ?? _success,
  message: message ?? _message,
  itemData: itemData ?? _itemData,
);
  num? get success => _success;
  String? get message => _message;
  List<ItemData>? get itemData => _itemData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_itemData != null) {
      map['item_data'] = _itemData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// stock_id : "2341"
/// tally_id : "1"
/// stock_name : "Mango Bite"
/// stock_price : "60"
/// category_id : "2"
/// parent : "toffee"
/// gst_applicable : ""
/// tcs_applicable : ""
/// description : "Kosar mango from gir gujarat"
/// gst_type_supply : ""
/// valuation_method : "Avg. Cost"
/// base_units : "Dozen"
/// additional_units : "Per Piece"
/// tcs_category : ""
/// gst_rep_um : ""
/// gst_item_units : "Dozen"
/// hsn_id : "25862435"
/// cess : ""
/// created_at : "1675334365"
/// updated_at : ""
/// deleted_at : ""
/// is_deleted : "0"
/// status : "Y"
/// company_id : "1"
/// item_conversion : "1"
/// item_denominator : "0"
/// integrated_tax : "27"
/// in_stock : "0"
/// order_count : "0"

ItemData itemDataFromJson(String str) => ItemData.fromJson(json.decode(str));
String itemDataToJson(ItemData data) => json.encode(data.toJson());
class ItemData {
  ItemData({
      String? stockId, 
      String? tallyId, 
      String? stockName = "",
      String? stockPrice,
    String? stockQuantity,
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
      String? inStock, 
      String? orderCount,
    bool? isSelected = false,
    num quantity = 0,
  }){
    _stockId = stockId;
    _tallyId = tallyId;
    _stockName = stockName;
    _stockPrice = stockPrice;
    _stockQuantity = stockQuantity;
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
    _inStock = inStock;
    _orderCount = orderCount;
    _isSelected = isSelected;
    _quantity = quantity;
  }

  set isSelected(bool? value) {
    _isSelected = value;
  }

  set quantity(num value) {
    _quantity = value;
  }


  ItemData.fromJson(dynamic json) {
    _stockId = json['stock_id'];
    _tallyId = json['tally_id'];
    _stockName = json['stock_name'];
    _stockPrice = json['stock_price'];
    _stockQuantity = json['stock_quantity'];
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
    _inStock = json['in_stock'];
    _orderCount = json['order_count'];
    _isSelected = json['isSelected'];

  }
  String? _stockId;
  String? _tallyId;
  String? _stockName= "";
  String? _stockPrice;
  String? _stockQuantity;

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
  String? _inStock;
  String? _orderCount;
  bool? _isSelected;
  num _quantity = 1;

  ItemData copyWith({  String? stockId,
  String? tallyId,
  String? stockName,
  String? stockPrice,
    String? stockQuantity,

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
  String? inStock,
  String? orderCount,
    bool? isSelected,
    num quantity = 1,

  }) => ItemData(  stockId: stockId ?? _stockId,
  tallyId: tallyId ?? _tallyId,
  stockName: stockName ?? _stockName,
  stockPrice: stockPrice ?? _stockPrice,
    stockQuantity: stockQuantity ?? _stockQuantity,
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
  inStock: inStock ?? _inStock,
  orderCount: orderCount ?? _orderCount,
    isSelected: isSelected ?? _isSelected,
    quantity: quantity ?? _quantity,
  );
  String? get stockId => _stockId;
  String? get tallyId => _tallyId;
  String? get stockName => _stockName;
  String? get stockPrice => _stockPrice;
  String? get stockQuantity => _stockQuantity;
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
  String? get inStock => _inStock;
  String? get orderCount => _orderCount;
  bool? get isSelected => _isSelected;
  num get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = _stockId;
    map['quantity'] = _quantity;
    map['instock'] = _inStock;
    map['price'] = _stockPrice;

    /*map['stock_id'] = _stockId;
    map['tally_id'] = _tallyId;
    map['stock_name'] = _stockName;
    map['stock_price'] = _stockPrice;
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
    map['in_stock'] = _inStock;
    map['order_count'] = _orderCount;
    map['isSelected'] = _isSelected;*/

    return map;
  }

}