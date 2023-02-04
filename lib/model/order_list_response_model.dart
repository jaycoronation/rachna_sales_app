import 'dart:convert';
/// success : 1
/// message : "Order List"
/// total_amount : "8370"
/// todays_sale : "8370"
/// orderList : [{"order_number":"SALE-0000000001","order_id":"43","customer_id":"3255","customer_name":"salt","sub_total":"1470","discount":"10","adjustments":"-500","grand_total":"1470","order_status":"","created_at":"10:09am 03 Feb 2023 ","transection_details":[{"id":"1","transection_amount":"3000","transection_mode":"cc","transection_type":"2","transection_status":"success","transection_date":"31-01-2023"}]}]

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

/// order_number : "SALE-0000000001"
/// order_id : "43"
/// customer_id : "3255"
/// customer_name : "salt"
/// sub_total : "1470"
/// discount : "10"
/// adjustments : "-500"
/// grand_total : "1470"
/// order_status : ""
/// created_at : "10:09am 03 Feb 2023 "
/// transection_details : [{"id":"1","transection_amount":"3000","transection_mode":"cc","transection_type":"2","transection_status":"success","transection_date":"31-01-2023"}]

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
    if (_transectionDetails != null) {
      map['transection_details'] = _transectionDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// transection_amount : "3000"
/// transection_mode : "cc"
/// transection_type : "2"
/// transection_status : "success"
/// transection_date : "31-01-2023"

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