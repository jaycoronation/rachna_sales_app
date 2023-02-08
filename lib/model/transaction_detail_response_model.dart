import 'dart:convert';
/// success : 1
/// message : "transection details found"
/// transection_details : {"id":"19","transection_amount":"200","transection_mode":"Debit Card","transection_type":"Credit","transection_id":"11111111","transection_status":"success","order_details":{"order_id":"12","order_number":"SALE-0000000012","sub_total":"3800","discount":"10","adjustments":"10","grand_total":"3800","order_status":""},"employee_details":{"emp_id":"1","emp_name":"Raj","emp_phone":"9725059007","emp_email":"raj@coronation.in","profile":"","incentive":"0","outstanding":"0","total_sales":"0","total_customers":"0"},"customer_details":{"customer_id":"3268","customer_name":"J P CORPORATION"}}

TransactionDetailResponseModel transactionDetailResponseModelFromJson(String str) => TransactionDetailResponseModel.fromJson(json.decode(str));
String transactionDetailResponseModelToJson(TransactionDetailResponseModel data) => json.encode(data.toJson());
class TransactionDetailResponseModel {
  TransactionDetailResponseModel({
      num? success, 
      String? message, 
      TransectionDetails? transectionDetails,}){
    _success = success;
    _message = message;
    _transectionDetails = transectionDetails;
}

  TransactionDetailResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _transectionDetails = json['transection_details'] != null ? TransectionDetails.fromJson(json['transection_details']) : null;
  }
  num? _success;
  String? _message;
  TransectionDetails? _transectionDetails;
TransactionDetailResponseModel copyWith({  num? success,
  String? message,
  TransectionDetails? transectionDetails,
}) => TransactionDetailResponseModel(  success: success ?? _success,
  message: message ?? _message,
  transectionDetails: transectionDetails ?? _transectionDetails,
);
  num? get success => _success;
  String? get message => _message;
  TransectionDetails? get transectionDetails => _transectionDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_transectionDetails != null) {
      map['transection_details'] = _transectionDetails?.toJson();
    }
    return map;
  }

}

/// id : "19"
/// transection_amount : "200"
/// transection_mode : "Debit Card"
/// transection_type : "Credit"
/// transection_id : "11111111"
/// transection_status : "success"
/// order_details : {"order_id":"12","order_number":"SALE-0000000012","sub_total":"3800","discount":"10","adjustments":"10","grand_total":"3800","order_status":""}
/// employee_details : {"emp_id":"1","emp_name":"Raj","emp_phone":"9725059007","emp_email":"raj@coronation.in","profile":"","incentive":"0","outstanding":"0","total_sales":"0","total_customers":"0"}
/// customer_details : {"customer_id":"3268","customer_name":"J P CORPORATION"}

TransectionDetails transectionDetailsFromJson(String str) => TransectionDetails.fromJson(json.decode(str));
String transectionDetailsToJson(TransectionDetails data) => json.encode(data.toJson());
class TransectionDetails {
  TransectionDetails({
      String? id, 
      String? transectionAmount, 
      String? transectionMode, 
      String? transectionType, 
      String? transectionId, 
      String? transectionStatus, 
      OrderDetails? orderDetails, 
      EmployeeDetails? employeeDetails, 
      CustomerDetails? customerDetails,}){
    _id = id;
    _transectionAmount = transectionAmount;
    _transectionMode = transectionMode;
    _transectionType = transectionType;
    _transectionId = transectionId;
    _transectionStatus = transectionStatus;
    _orderDetails = orderDetails;
    _employeeDetails = employeeDetails;
    _customerDetails = customerDetails;
}

  TransectionDetails.fromJson(dynamic json) {
    _id = json['id'];
    _transectionAmount = json['transection_amount'];
    _transectionMode = json['transection_mode'];
    _transectionType = json['transection_type'];
    _transectionId = json['transection_id'];
    _transectionStatus = json['transection_status'];
    _orderDetails = json['order_details'] != null ? OrderDetails.fromJson(json['order_details']) : null;
    _employeeDetails = json['employee_details'] != null ? EmployeeDetails.fromJson(json['employee_details']) : null;
    _customerDetails = json['customer_details'] != null ? CustomerDetails.fromJson(json['customer_details']) : null;
  }
  String? _id;
  String? _transectionAmount;
  String? _transectionMode;
  String? _transectionType;
  String? _transectionId;
  String? _transectionStatus;
  OrderDetails? _orderDetails;
  EmployeeDetails? _employeeDetails;
  CustomerDetails? _customerDetails;
TransectionDetails copyWith({  String? id,
  String? transectionAmount,
  String? transectionMode,
  String? transectionType,
  String? transectionId,
  String? transectionStatus,
  OrderDetails? orderDetails,
  EmployeeDetails? employeeDetails,
  CustomerDetails? customerDetails,
}) => TransectionDetails(  id: id ?? _id,
  transectionAmount: transectionAmount ?? _transectionAmount,
  transectionMode: transectionMode ?? _transectionMode,
  transectionType: transectionType ?? _transectionType,
  transectionId: transectionId ?? _transectionId,
  transectionStatus: transectionStatus ?? _transectionStatus,
  orderDetails: orderDetails ?? _orderDetails,
  employeeDetails: employeeDetails ?? _employeeDetails,
  customerDetails: customerDetails ?? _customerDetails,
);
  String? get id => _id;
  String? get transectionAmount => _transectionAmount;
  String? get transectionMode => _transectionMode;
  String? get transectionType => _transectionType;
  String? get transectionId => _transectionId;
  String? get transectionStatus => _transectionStatus;
  OrderDetails? get orderDetails => _orderDetails;
  EmployeeDetails? get employeeDetails => _employeeDetails;
  CustomerDetails? get customerDetails => _customerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['transection_amount'] = _transectionAmount;
    map['transection_mode'] = _transectionMode;
    map['transection_type'] = _transectionType;
    map['transection_id'] = _transectionId;
    map['transection_status'] = _transectionStatus;
    if (_orderDetails != null) {
      map['order_details'] = _orderDetails?.toJson();
    }
    if (_employeeDetails != null) {
      map['employee_details'] = _employeeDetails?.toJson();
    }
    if (_customerDetails != null) {
      map['customer_details'] = _customerDetails?.toJson();
    }
    return map;
  }

}

/// customer_id : "3268"
/// customer_name : "J P CORPORATION"

CustomerDetails customerDetailsFromJson(String str) => CustomerDetails.fromJson(json.decode(str));
String customerDetailsToJson(CustomerDetails data) => json.encode(data.toJson());
class CustomerDetails {
  CustomerDetails({
      String? customerId, 
      String? customerName,}){
    _customerId = customerId;
    _customerName = customerName;
}

  CustomerDetails.fromJson(dynamic json) {
    _customerId = json['customer_id'];
    _customerName = json['customer_name'];
  }
  String? _customerId;
  String? _customerName;
CustomerDetails copyWith({  String? customerId,
  String? customerName,
}) => CustomerDetails(  customerId: customerId ?? _customerId,
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

/// emp_id : "1"
/// emp_name : "Raj"
/// emp_phone : "9725059007"
/// emp_email : "raj@coronation.in"
/// profile : ""
/// incentive : "0"
/// outstanding : "0"
/// total_sales : "0"
/// total_customers : "0"

EmployeeDetails employeeDetailsFromJson(String str) => EmployeeDetails.fromJson(json.decode(str));
String employeeDetailsToJson(EmployeeDetails data) => json.encode(data.toJson());
class EmployeeDetails {
  EmployeeDetails({
      String? empId, 
      String? empName, 
      String? empPhone, 
      String? empEmail, 
      String? profile, 
      String? incentive, 
      String? outstanding, 
      String? totalSales, 
      String? totalCustomers,}){
    _empId = empId;
    _empName = empName;
    _empPhone = empPhone;
    _empEmail = empEmail;
    _profile = profile;
    _incentive = incentive;
    _outstanding = outstanding;
    _totalSales = totalSales;
    _totalCustomers = totalCustomers;
}

  EmployeeDetails.fromJson(dynamic json) {
    _empId = json['emp_id'];
    _empName = json['emp_name'];
    _empPhone = json['emp_phone'];
    _empEmail = json['emp_email'];
    _profile = json['profile'];
    _incentive = json['incentive'];
    _outstanding = json['outstanding'];
    _totalSales = json['total_sales'];
    _totalCustomers = json['total_customers'];
  }
  String? _empId;
  String? _empName;
  String? _empPhone;
  String? _empEmail;
  String? _profile;
  String? _incentive;
  String? _outstanding;
  String? _totalSales;
  String? _totalCustomers;
EmployeeDetails copyWith({  String? empId,
  String? empName,
  String? empPhone,
  String? empEmail,
  String? profile,
  String? incentive,
  String? outstanding,
  String? totalSales,
  String? totalCustomers,
}) => EmployeeDetails(  empId: empId ?? _empId,
  empName: empName ?? _empName,
  empPhone: empPhone ?? _empPhone,
  empEmail: empEmail ?? _empEmail,
  profile: profile ?? _profile,
  incentive: incentive ?? _incentive,
  outstanding: outstanding ?? _outstanding,
  totalSales: totalSales ?? _totalSales,
  totalCustomers: totalCustomers ?? _totalCustomers,
);
  String? get empId => _empId;
  String? get empName => _empName;
  String? get empPhone => _empPhone;
  String? get empEmail => _empEmail;
  String? get profile => _profile;
  String? get incentive => _incentive;
  String? get outstanding => _outstanding;
  String? get totalSales => _totalSales;
  String? get totalCustomers => _totalCustomers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['emp_id'] = _empId;
    map['emp_name'] = _empName;
    map['emp_phone'] = _empPhone;
    map['emp_email'] = _empEmail;
    map['profile'] = _profile;
    map['incentive'] = _incentive;
    map['outstanding'] = _outstanding;
    map['total_sales'] = _totalSales;
    map['total_customers'] = _totalCustomers;
    return map;
  }

}

/// order_id : "12"
/// order_number : "SALE-0000000012"
/// sub_total : "3800"
/// discount : "10"
/// adjustments : "10"
/// grand_total : "3800"
/// order_status : ""

OrderDetails orderDetailsFromJson(String str) => OrderDetails.fromJson(json.decode(str));
String orderDetailsToJson(OrderDetails data) => json.encode(data.toJson());
class OrderDetails {
  OrderDetails({
      String? orderId, 
      String? orderNumber, 
      String? subTotal, 
      String? discount, 
      String? adjustments, 
      String? grandTotal, 
      String? orderStatus,}){
    _orderId = orderId;
    _orderNumber = orderNumber;
    _subTotal = subTotal;
    _discount = discount;
    _adjustments = adjustments;
    _grandTotal = grandTotal;
    _orderStatus = orderStatus;
}

  OrderDetails.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _orderNumber = json['order_number'];
    _subTotal = json['sub_total'];
    _discount = json['discount'];
    _adjustments = json['adjustments'];
    _grandTotal = json['grand_total'];
    _orderStatus = json['order_status'];
  }
  String? _orderId;
  String? _orderNumber;
  String? _subTotal;
  String? _discount;
  String? _adjustments;
  String? _grandTotal;
  String? _orderStatus;
OrderDetails copyWith({  String? orderId,
  String? orderNumber,
  String? subTotal,
  String? discount,
  String? adjustments,
  String? grandTotal,
  String? orderStatus,
}) => OrderDetails(  orderId: orderId ?? _orderId,
  orderNumber: orderNumber ?? _orderNumber,
  subTotal: subTotal ?? _subTotal,
  discount: discount ?? _discount,
  adjustments: adjustments ?? _adjustments,
  grandTotal: grandTotal ?? _grandTotal,
  orderStatus: orderStatus ?? _orderStatus,
);
  String? get orderId => _orderId;
  String? get orderNumber => _orderNumber;
  String? get subTotal => _subTotal;
  String? get discount => _discount;
  String? get adjustments => _adjustments;
  String? get grandTotal => _grandTotal;
  String? get orderStatus => _orderStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['order_number'] = _orderNumber;
    map['sub_total'] = _subTotal;
    map['discount'] = _discount;
    map['adjustments'] = _adjustments;
    map['grand_total'] = _grandTotal;
    map['order_status'] = _orderStatus;
    return map;
  }

}