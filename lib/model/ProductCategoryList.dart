import 'dart:convert';

import 'product_item_data_response_model.dart';

ProductCategoryList productItemDataResponseModelFromJson(String str) => ProductCategoryList.fromJson(json.decode(str));
String productItemDataResponseModelToJson(ProductCategoryList data) => json.encode(data.toJson());
class ProductCategoryList {
  ProductCategoryList({
    String? message,
    List<ItemData>? itemData,}){
    _message = message;
    _itemData = itemData;
  }

  ProductCategoryList.fromJson(dynamic json) {
    _message = json['message'];
    if (json['item_data'] != null) {
      _itemData = [];
      json['item_data'].forEach((v) {
        _itemData?.add(ItemData.fromJson(v));
      });
    }
  }
  String? _message;
  List<ItemData>? _itemData;
  ProductCategoryList copyWith({  num? success,
    String? message,
    List<ItemData>? itemData,
  }) => ProductCategoryList(
    message: message ?? _message,
    itemData: itemData ?? _itemData,
  );
  String? get message => _message;
  List<ItemData>? get itemData => _itemData;

  set message(String? value) {
    _message = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_itemData != null) {
      map['item_data'] = _itemData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  set itemData(List<ItemData>? value) {
    _itemData = value;
  }
}