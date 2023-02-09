import 'dart:convert';
/// success : 1
/// message : "Order List"
/// total_amount : "27840"
/// todays_sale : "8000"
/// orderList : [{"order_number":"SALE-0000000017","order_id":"17","customer_id":"3268","customer_name":"J P CORPORATION","sub_total":"1000","discount":"0","adjustments":"0","grand_total":"1000","order_status":"","created_at":"12:22pm 09 Feb 2023 ","pending_amount":"0","transection_details":[{"id":"25","transection_amount":"1000.0","transection_mode":"","transection_type":"2","transection_status":"success","transection_date":"09-02-2023"},{"id":"26","transection_amount":"1000","transection_mode":"Cash","transection_type":"1","transection_status":"success","transection_date":"09-02-2023"}]},{"order_number":"SALE-0000000016","order_id":"16","customer_id":"3268","customer_name":"J P CORPORATION","sub_total":"7000","discount":"1000","adjustments":"600","grand_total":"7000","order_status":"","created_at":"12:01pm 09 Feb 2023 ","pending_amount":"7000","transection_details":[{"id":"24","transection_amount":"7000.0","transection_mode":"","transection_type":"2","transection_status":"success","transection_date":"09-02-2023"}]},{"order_number":"SALE-0000000015","order_id":"15","customer_id":"3255","customer_name":"salt","sub_total":"5600","discount":"600","adjustments":"0","grand_total":"5600","order_status":"","created_at":"18:38pm 08 Feb 2023 ","pending_amount":"600","transection_details":[{"id":"22","transection_amount":"5600.0","transection_mode":"Cash","transection_type":"2","transection_status":"success","transection_date":"08-02-2023"},{"id":"23","transection_amount":"5000","transection_mode":"Cash","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"}]},{"order_number":"SALE-0000000014","order_id":"14","customer_id":"3265","customer_name":"HRPL Restaurants Private Limited","sub_total":"3800","discount":"0","adjustments":"0","grand_total":"3800","order_status":"","created_at":"16:12pm 08 Feb 2023 ","pending_amount":"3800","transection_details":[{"id":"16","transection_amount":"3800.0","transection_mode":"Cash","transection_type":"2","transection_status":"success","transection_date":"08-02-2023"}]},{"order_number":"SALE-0000000013","order_id":"13","customer_id":"3266","customer_name":"Enthrall Foods PVT.LTD.","sub_total":"1000","discount":"0","adjustments":"0","grand_total":"1000","order_status":"","created_at":"16:11pm 08 Feb 2023 ","pending_amount":"1000","transection_details":[{"id":"15","transection_amount":"1000.0","transection_mode":"Cash","transection_type":"2","transection_status":"success","transection_date":"08-02-2023"}]},{"order_number":"SALE-0000000012","order_id":"12","customer_id":"3268","customer_name":"J P CORPORATION","sub_total":"3800","discount":"10","adjustments":"10","grand_total":"3800","order_status":"","created_at":"16:08pm 08 Feb 2023 ","pending_amount":"400","transection_details":[{"id":"14","transection_amount":"3800.0","transection_mode":"","transection_type":"2","transection_status":"success","transection_date":"08-02-2023"},{"id":"17","transection_amount":"1000","transection_mode":"Cash","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"},{"id":"19","transection_amount":"200","transection_mode":"Debit Card","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"},{"id":"20","transection_amount":"200","transection_mode":"Cash","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"},{"id":"21","transection_amount":"2000","transection_mode":"Cash","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"}]},{"order_number":"SALE-0000000011","order_id":"11","customer_id":"3267","customer_name":"Shree Laxminarayan Food Industries","sub_total":"3720","discount":"0","adjustments":"0","grand_total":"3720","order_status":" ","created_at":"15:06pm 08 Feb 2023 ","pending_amount":"3020","transection_details":[{"id":"11","transection_amount":"3720","transection_mode":"","transection_type":"2","transection_status":"success","transection_date":"08-02-2023"},{"id":"12","transection_amount":"500","transection_mode":"Cash","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"},{"id":"13","transection_amount":"200","transection_mode":"Cash","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"}]},{"order_number":"SALE-0000000001","order_id":"10","customer_id":"3267","customer_name":"Shree Laxminarayan Food Industries","sub_total":"1920","discount":"0","adjustments":"0","grand_total":"1920","order_status":" ","created_at":"12:55pm 08 Feb 2023 ","pending_amount":"120","transection_details":[{"id":"8","transection_amount":"1920","transection_mode":"","transection_type":"2","transection_status":"success","transection_date":"08-02-2023"},{"id":"9","transection_amount":"700","transection_mode":"cash","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"},{"id":"10","transection_amount":"100","transection_mode":"cash","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"},{"id":"18","transection_amount":"1000","transection_mode":"UPI","transection_type":"1","transection_status":"success","transection_date":"08-02-2023"}]}]

OrderListResponseModel orderListResponseModelFromJson(String str) => OrderListResponseModel.fromJson(json.decode(str));
String orderListResponseModelToJson(OrderListResponseModel data) => json.encode(data.toJson());
class OrderListResponseModel {
  OrderListResponseModel({
      num? success, 
      String? message, 
      String? totalAmount, 
      String? todaysSale, 
      List<OrderList>? orderList,}){
    _success = success;
    _message = message;
    _totalAmount = totalAmount;
    _todaysSale = todaysSale;
    _orderList = orderList;
}

  OrderListResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _totalAmount = json['total_amount'];
    _todaysSale = json['todays_sale'];
    if (json['orderList'] != null) {
      _orderList = [];
      json['orderList'].forEach((v) {
        _orderList?.add(OrderList.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  String? _totalAmount;
  String? _todaysSale;
  List<OrderList>? _orderList;
OrderListResponseModel copyWith({  num? success,
  String? message,
  String? totalAmount,
  String? todaysSale,
  List<OrderList>? orderList,
}) => OrderListResponseModel(  success: success ?? _success,
  message: message ?? _message,
  totalAmount: totalAmount ?? _totalAmount,
  todaysSale: todaysSale ?? _todaysSale,
  orderList: orderList ?? _orderList,
);
  num? get success => _success;
  String? get message => _message;
  String? get totalAmount => _totalAmount;
  String? get todaysSale => _todaysSale;
  List<OrderList>? get orderList => _orderList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['total_amount'] = _totalAmount;
    map['todays_sale'] = _todaysSale;
    if (_orderList != null) {
      map['orderList'] = _orderList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// order_number : "SALE-0000000017"
/// order_id : "17"
/// customer_id : "3268"
/// customer_name : "J P CORPORATION"
/// sub_total : "1000"
/// discount : "0"
/// adjustments : "0"
/// grand_total : "1000"
/// order_status : ""
/// created_at : "12:22pm 09 Feb 2023 "
/// pending_amount : "0"
/// transection_details : [{"id":"25","transection_amount":"1000.0","transection_mode":"","transection_type":"2","transection_status":"success","transection_date":"09-02-2023"},{"id":"26","transection_amount":"1000","transection_mode":"Cash","transection_type":"1","transection_status":"success","transection_date":"09-02-2023"}]

OrderList orderListFromJson(String str) => OrderList.fromJson(json.decode(str));
String orderListToJson(OrderList data) => json.encode(data.toJson());
class OrderList {
  OrderList({
      String? orderNumber, 
      String? orderId, 
      String? customerId, 
      String? customerName, 
      String? subTotal, 
      String? discount, 
      String? adjustments, 
      String? grandTotal, 
      String? orderStatus, 
      String? createdAt, 
      String? pendingAmount, 
      List<TransectionDetails>? transectionDetails,}){
    _orderNumber = orderNumber;
    _orderId = orderId;
    _customerId = customerId;
    _customerName = customerName;
    _subTotal = subTotal;
    _discount = discount;
    _adjustments = adjustments;
    _grandTotal = grandTotal;
    _orderStatus = orderStatus;
    _createdAt = createdAt;
    _pendingAmount = pendingAmount;
    _transectionDetails = transectionDetails;
}

  OrderList.fromJson(dynamic json) {
    _orderNumber = json['order_number'];
    _orderId = json['order_id'];
    _customerId = json['customer_id'];
    _customerName = json['customer_name'];
    _subTotal = json['sub_total'];
    _discount = json['discount'];
    _adjustments = json['adjustments'];
    _grandTotal = json['grand_total'];
    _orderStatus = json['order_status'];
    _createdAt = json['created_at'];
    _pendingAmount = json['pending_amount'];
    if (json['transection_details'] != null) {
      _transectionDetails = [];
      json['transection_details'].forEach((v) {
        _transectionDetails?.add(TransectionDetails.fromJson(v));
      });
    }
  }
  String? _orderNumber;
  String? _orderId;
  String? _customerId;
  String? _customerName;
  String? _subTotal;
  String? _discount;
  String? _adjustments;
  String? _grandTotal;
  String? _orderStatus;
  String? _createdAt;
  String? _pendingAmount;
  List<TransectionDetails>? _transectionDetails;
OrderList copyWith({  String? orderNumber,
  String? orderId,
  String? customerId,
  String? customerName,
  String? subTotal,
  String? discount,
  String? adjustments,
  String? grandTotal,
  String? orderStatus,
  String? createdAt,
  String? pendingAmount,
  List<TransectionDetails>? transectionDetails,
}) => OrderList(  orderNumber: orderNumber ?? _orderNumber,
  orderId: orderId ?? _orderId,
  customerId: customerId ?? _customerId,
  customerName: customerName ?? _customerName,
  subTotal: subTotal ?? _subTotal,
  discount: discount ?? _discount,
  adjustments: adjustments ?? _adjustments,
  grandTotal: grandTotal ?? _grandTotal,
  orderStatus: orderStatus ?? _orderStatus,
  createdAt: createdAt ?? _createdAt,
  pendingAmount: pendingAmount ?? _pendingAmount,
  transectionDetails: transectionDetails ?? _transectionDetails,
);
  String? get orderNumber => _orderNumber;
  String? get orderId => _orderId;
  String? get customerId => _customerId;
  String? get customerName => _customerName;
  String? get subTotal => _subTotal;
  String? get discount => _discount;
  String? get adjustments => _adjustments;
  String? get grandTotal => _grandTotal;
  String? get orderStatus => _orderStatus;
  String? get createdAt => _createdAt;
  String? get pendingAmount => _pendingAmount;
  List<TransectionDetails>? get transectionDetails => _transectionDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_number'] = _orderNumber;
    map['order_id'] = _orderId;
    map['customer_id'] = _customerId;
    map['customer_name'] = _customerName;
    map['sub_total'] = _subTotal;
    map['discount'] = _discount;
    map['adjustments'] = _adjustments;
    map['grand_total'] = _grandTotal;
    map['order_status'] = _orderStatus;
    map['created_at'] = _createdAt;
    map['pending_amount'] = _pendingAmount;
    if (_transectionDetails != null) {
      map['transection_details'] = _transectionDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "25"
/// transection_amount : "1000.0"
/// transection_mode : ""
/// transection_type : "2"
/// transection_status : "success"
/// transection_date : "09-02-2023"

TransectionDetails transectionDetailsFromJson(String str) => TransectionDetails.fromJson(json.decode(str));
String transectionDetailsToJson(TransectionDetails data) => json.encode(data.toJson());
class TransectionDetails {
  TransectionDetails({
      String? id, 
      String? transectionAmount, 
      String? transectionMode, 
      String? transectionType, 
      String? transectionStatus, 
      String? transectionDate,}){
    _id = id;
    _transectionAmount = transectionAmount;
    _transectionMode = transectionMode;
    _transectionType = transectionType;
    _transectionStatus = transectionStatus;
    _transectionDate = transectionDate;
}

  TransectionDetails.fromJson(dynamic json) {
    _id = json['id'];
    _transectionAmount = json['transection_amount'];
    _transectionMode = json['transection_mode'];
    _transectionType = json['transection_type'];
    _transectionStatus = json['transection_status'];
    _transectionDate = json['transection_date'];
  }
  String? _id;
  String? _transectionAmount;
  String? _transectionMode;
  String? _transectionType;
  String? _transectionStatus;
  String? _transectionDate;
TransectionDetails copyWith({  String? id,
  String? transectionAmount,
  String? transectionMode,
  String? transectionType,
  String? transectionStatus,
  String? transectionDate,
}) => TransectionDetails(  id: id ?? _id,
  transectionAmount: transectionAmount ?? _transectionAmount,
  transectionMode: transectionMode ?? _transectionMode,
  transectionType: transectionType ?? _transectionType,
  transectionStatus: transectionStatus ?? _transectionStatus,
  transectionDate: transectionDate ?? _transectionDate,
);
  String? get id => _id;
  String? get transectionAmount => _transectionAmount;
  String? get transectionMode => _transectionMode;
  String? get transectionType => _transectionType;
  String? get transectionStatus => _transectionStatus;
  String? get transectionDate => _transectionDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['transection_amount'] = _transectionAmount;
    map['transection_mode'] = _transectionMode;
    map['transection_type'] = _transectionType;
    map['transection_status'] = _transectionStatus;
    map['transection_date'] = _transectionDate;
    return map;
  }

}