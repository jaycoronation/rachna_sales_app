import 'dart:convert';
/// success : 1
/// message : "Daily Plan details found"
/// totalCount : "2"
/// daily_plan_details : [{"id":"2","description":"to meet trt","other":"erter tert","plan_date":"14-02-2023","status":"1","save_timestamp":"14-02-2023","updated_at":"","customer":{"customer_id":"1","customer_name":"Aabad Food Pvt. Ltd. 1"}},{"id":"3","description":"test","other":"tetsffe","plan_date":"14-02-2023","status":"1","save_timestamp":"14-02-2023","updated_at":"","customer":{"customer_id":"3292","customer_name":"A.M.HOSPITALITY"}}]

DailyPlanResponseModel dailyPlanResponseModelFromJson(String str) => DailyPlanResponseModel.fromJson(json.decode(str));
String dailyPlanResponseModelToJson(DailyPlanResponseModel data) => json.encode(data.toJson());
class DailyPlanResponseModel {
  DailyPlanResponseModel({
      num? success, 
      String? message, 
      String? totalCount, 
      List<DailyPlanDetails>? dailyPlanDetails,}){
    _success = success;
    _message = message;
    _totalCount = totalCount;
    _dailyPlanDetails = dailyPlanDetails;
}

  DailyPlanResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _totalCount = json['totalCount'];
    if (json['daily_plan_details'] != null) {
      _dailyPlanDetails = [];
      json['daily_plan_details'].forEach((v) {
        _dailyPlanDetails?.add(DailyPlanDetails.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  String? _totalCount;
  List<DailyPlanDetails>? _dailyPlanDetails;
DailyPlanResponseModel copyWith({  num? success,
  String? message,
  String? totalCount,
  List<DailyPlanDetails>? dailyPlanDetails,
}) => DailyPlanResponseModel(  success: success ?? _success,
  message: message ?? _message,
  totalCount: totalCount ?? _totalCount,
  dailyPlanDetails: dailyPlanDetails ?? _dailyPlanDetails,
);
  num? get success => _success;
  String? get message => _message;
  String? get totalCount => _totalCount;
  List<DailyPlanDetails>? get dailyPlanDetails => _dailyPlanDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['totalCount'] = _totalCount;
    if (_dailyPlanDetails != null) {
      map['daily_plan_details'] = _dailyPlanDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "2"
/// description : "to meet trt"
/// other : "erter tert"
/// plan_date : "14-02-2023"
/// status : "1"
/// save_timestamp : "14-02-2023"
/// updated_at : ""
/// customer : {"customer_id":"1","customer_name":"Aabad Food Pvt. Ltd. 1"}

DailyPlanDetails dailyPlanDetailsFromJson(String str) => DailyPlanDetails.fromJson(json.decode(str));
String dailyPlanDetailsToJson(DailyPlanDetails data) => json.encode(data.toJson());
class DailyPlanDetails {
  DailyPlanDetails({
      String? id, 
      String? description, 
      String? other, 
      String? planDate, 
      String? status, 
      String? saveTimestamp, 
      String? updatedAt, 
      Customer? customer,}){
    _id = id;
    _description = description;
    _other = other;
    _planDate = planDate;
    _status = status;
    _saveTimestamp = saveTimestamp;
    _updatedAt = updatedAt;
    _customer = customer;
}

  DailyPlanDetails.fromJson(dynamic json) {
    _id = json['id'];
    _description = json['description'];
    _other = json['other'];
    _planDate = json['plan_date'];
    _status = json['status'];
    _saveTimestamp = json['save_timestamp'];
    _updatedAt = json['updated_at'];
    _customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }
  String? _id;
  String? _description;
  String? _other;
  String? _planDate;
  String? _status;
  String? _saveTimestamp;
  String? _updatedAt;
  Customer? _customer;
DailyPlanDetails copyWith({  String? id,
  String? description,
  String? other,
  String? planDate,
  String? status,
  String? saveTimestamp,
  String? updatedAt,
  Customer? customer,
}) => DailyPlanDetails(  id: id ?? _id,
  description: description ?? _description,
  other: other ?? _other,
  planDate: planDate ?? _planDate,
  status: status ?? _status,
  saveTimestamp: saveTimestamp ?? _saveTimestamp,
  updatedAt: updatedAt ?? _updatedAt,
  customer: customer ?? _customer,
);
  String? get id => _id;
  String? get description => _description;
  String? get other => _other;
  String? get planDate => _planDate;
  String? get status => _status;
  String? get saveTimestamp => _saveTimestamp;
  String? get updatedAt => _updatedAt;
  Customer? get customer => _customer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['description'] = _description;
    map['other'] = _other;
    map['plan_date'] = _planDate;
    map['status'] = _status;
    map['save_timestamp'] = _saveTimestamp;
    map['updated_at'] = _updatedAt;
    if (_customer != null) {
      map['customer'] = _customer?.toJson();
    }
    return map;
  }

}

/// customer_id : "1"
/// customer_name : "Aabad Food Pvt. Ltd. 1"

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));
String customerToJson(Customer data) => json.encode(data.toJson());
class Customer {
  Customer({
      String? customerId, 
      String? customerName,}){
    _customerId = customerId;
    _customerName = customerName;
}

  Customer.fromJson(dynamic json) {
    _customerId = json['customer_id'];
    _customerName = json['customer_name'];
  }
  String? _customerId;
  String? _customerName;
Customer copyWith({  String? customerId,
  String? customerName,
}) => Customer(  customerId: customerId ?? _customerId,
  customerName: customerName ?? _customerName,
);
  String? get customerId => _customerId;
  String? get customerName => _customerName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['customer_id'] = _customerId;
    map['customer_name'] = _customerName;
    return map;
  }

}