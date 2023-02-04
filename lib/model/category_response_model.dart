import 'dart:convert';
/// success : 1
/// message : "Category details found"
/// totalCount : 3
/// category_details : [{"category_id":"1","category_name":"Dairy & Bakery","status":"1","created_at":"15-11-2022"},{"category_id":"2","category_name":"Fruits & Vegitables","status":"1","created_at":"15-11-2022"},{"category_id":"3","category_name":"Other","status":"1","created_at":"15-11-2022"}]

CategoryResponseModel categoryResponseModelFromJson(String str) => CategoryResponseModel.fromJson(json.decode(str));
String categoryResponseModelToJson(CategoryResponseModel data) => json.encode(data.toJson());
class CategoryResponseModel {
  CategoryResponseModel({
      num? success, 
      String? message, 
      num? totalCount, 
      List<CategoryDetails>? categoryDetails,}){
    _success = success;
    _message = message;
    _totalCount = totalCount;
    _categoryDetails = categoryDetails;
}

  CategoryResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _totalCount = json['totalCount'];
    if (json['category_details'] != null) {
      _categoryDetails = [];
      json['category_details'].forEach((v) {
        _categoryDetails?.add(CategoryDetails.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  num? _totalCount;
  List<CategoryDetails>? _categoryDetails;
CategoryResponseModel copyWith({  num? success,
  String? message,
  num? totalCount,
  List<CategoryDetails>? categoryDetails,
}) => CategoryResponseModel(  success: success ?? _success,
  message: message ?? _message,
  totalCount: totalCount ?? _totalCount,
  categoryDetails: categoryDetails ?? _categoryDetails,
);
  num? get success => _success;
  String? get message => _message;
  num? get totalCount => _totalCount;
  List<CategoryDetails>? get categoryDetails => _categoryDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['totalCount'] = _totalCount;
    if (_categoryDetails != null) {
      map['category_details'] = _categoryDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// category_id : "1"
/// category_name : "Dairy & Bakery"
/// status : "1"
/// created_at : "15-11-2022"

CategoryDetails categoryDetailsFromJson(String str) => CategoryDetails.fromJson(json.decode(str));
String categoryDetailsToJson(CategoryDetails data) => json.encode(data.toJson());
class CategoryDetails {
  CategoryDetails({
      String? categoryId, 
      String? categoryName, 
      String? status, 
      String? createdAt,
    bool? isSelected = false,}){
    _categoryId = categoryId;
    _categoryName = categoryName;
    _status = status;
    _createdAt = createdAt;
    _isSelected = isSelected;
}

  set isSelected(bool? value) {
    _isSelected = value;
  }

  CategoryDetails.fromJson(dynamic json) {
    _categoryId = json['category_id'];
    _categoryName = json['category_name'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _isSelected = json['isSelected'];

  }
  String? _categoryId;
  String? _categoryName;
  String? _status;
  String? _createdAt;
  bool? _isSelected;

  CategoryDetails copyWith({  String? categoryId,
  String? categoryName,
  String? status,
  String? createdAt,
    bool? isSelected,

  }) => CategoryDetails(  categoryId: categoryId ?? _categoryId,
  categoryName: categoryName ?? _categoryName,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
    isSelected: isSelected ?? _isSelected,

  );
  String? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  String? get status => _status;
  String? get createdAt => _createdAt;
  bool? get isSelected => _isSelected;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category_id'] = _categoryId;
    map['category_name'] = _categoryName;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['isSelected'] = _isSelected;

    return map;
  }

}