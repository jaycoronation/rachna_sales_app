import 'dart:convert';
/// success : 1
/// message : "Daily Plan details found"
/// daily_plan_details : {"id":"5","description":"to meet trt","other":"erter tert","plan_date":"15-02-2023","status":"1","save_timestamp":"15-02-2023","updated_at":"","customer":{"customer_id":"","customer_name":""}}

DailyPlanDetailResponseModel dailyPlanDetailResponseModelFromJson(String str) => DailyPlanDetailResponseModel.fromJson(json.decode(str));
String dailyPlanDetailResponseModelToJson(DailyPlanDetailResponseModel data) => json.encode(data.toJson());
class DailyPlanDetailResponseModel {
  DailyPlanDetailResponseModel({
      num? success, 
      String? message, 
      DailyPlanDetails? dailyPlanDetails,}){
    _success = success;
    _message = message;
    _dailyPlanDetails = dailyPlanDetails;
}

  DailyPlanDetailResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _dailyPlanDetails = json['daily_plan_details'] != null ? DailyPlanDetails.fromJson(json['daily_plan_details']) : null;
  }
  num? _success;
  String? _message;
  DailyPlanDetails? _dailyPlanDetails;
DailyPlanDetailResponseModel copyWith({  num? success,
  String? message,
  DailyPlanDetails? dailyPlanDetails,
}) => DailyPlanDetailResponseModel(  success: success ?? _success,
  message: message ?? _message,
  dailyPlanDetails: dailyPlanDetails ?? _dailyPlanDetails,
);
  num? get success => _success;
  String? get message => _message;
  DailyPlanDetails? get dailyPlanDetails => _dailyPlanDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_dailyPlanDetails != null) {
      map['daily_plan_details'] = _dailyPlanDetails?.toJson();
    }
    return map;
  }

}

/// id : "5"
/// description : "to meet trt"
/// other : "erter tert"
/// plan_date : "15-02-2023"
/// status : "1"
/// save_timestamp : "15-02-2023"
/// updated_at : ""
/// customer : {"customer_id":"","customer_name":""}

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

/// customer_id : ""
/// customer_name : ""

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