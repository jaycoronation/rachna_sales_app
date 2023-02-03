import 'dart:convert';
/// success : 1
/// data : {"total_amount":0,"total_overdue":16000,"total_employee":42,"total_customer":9}

DashBoardDataResponseModel dashBoardDataResponseModelFromJson(String str) => DashBoardDataResponseModel.fromJson(json.decode(str));
String dashBoardDataResponseModelToJson(DashBoardDataResponseModel data) => json.encode(data.toJson());
class DashBoardDataResponseModel {
  DashBoardDataResponseModel({
      num? success, 
      Data? data,}){
    _success = success;
    _data = data;
}

  DashBoardDataResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? _success;
  Data? _data;
DashBoardDataResponseModel copyWith({  num? success,
  Data? data,
}) => DashBoardDataResponseModel(  success: success ?? _success,
  data: data ?? _data,
);
  num? get success => _success;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// total_amount : 0
/// total_overdue : 16000
/// total_employee : 42
/// total_customer : 9

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? totalAmount, 
      num? totalOverdue, 
      num? totalEmployee, 
      num? totalCustomer,}){
    _totalAmount = totalAmount;
    _totalOverdue = totalOverdue;
    _totalEmployee = totalEmployee;
    _totalCustomer = totalCustomer;
}

  Data.fromJson(dynamic json) {
    _totalAmount = json['total_amount'];
    _totalOverdue = json['total_overdue'];
    _totalEmployee = json['total_employee'];
    _totalCustomer = json['total_customer'];
  }
  num? _totalAmount;
  num? _totalOverdue;
  num? _totalEmployee;
  num? _totalCustomer;
Data copyWith({  num? totalAmount,
  num? totalOverdue,
  num? totalEmployee,
  num? totalCustomer,
}) => Data(  totalAmount: totalAmount ?? _totalAmount,
  totalOverdue: totalOverdue ?? _totalOverdue,
  totalEmployee: totalEmployee ?? _totalEmployee,
  totalCustomer: totalCustomer ?? _totalCustomer,
);
  num? get totalAmount => _totalAmount;
  num? get totalOverdue => _totalOverdue;
  num? get totalEmployee => _totalEmployee;
  num? get totalCustomer => _totalCustomer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_amount'] = _totalAmount;
    map['total_overdue'] = _totalOverdue;
    map['total_employee'] = _totalEmployee;
    map['total_customer'] = _totalCustomer;
    return map;
  }

}