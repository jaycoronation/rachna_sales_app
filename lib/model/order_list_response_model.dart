import 'dart:convert';
/// success : 1
/// message : "Order List"
/// total_amount : 50000
/// todays_sale : 0
/// orderList : [{"order_number":"SALE-0000000032","order_id":"32","customer_id":"1","customer_name":"Aabad Food Pvt. Ltd. 1","sub_total":"5000","discount":"10","adjustments":"100","grand_total":"5000","order_status":"success","created_at":"12:56pm 22 Nov 2022 "},null]

OrderListResponseModel orderListResponseModelFromJson(String str) => OrderListResponseModel.fromJson(json.decode(str));
String orderListResponseModelToJson(OrderListResponseModel data) => json.encode(data.toJson());
class OrderListResponseModel {
  OrderListResponseModel({
      num? success, 
      String? message, 
      num? totalAmount, 
      num? todaysSale, 
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
  num? _totalAmount;
  num? _todaysSale;
  List<OrderList>? _orderList;
OrderListResponseModel copyWith({  num? success,
  String? message,
  num? totalAmount,
  num? todaysSale,
  List<OrderList>? orderList,
}) => OrderListResponseModel(  success: success ?? _success,
  message: message ?? _message,
  totalAmount: totalAmount ?? _totalAmount,
  todaysSale: todaysSale ?? _todaysSale,
  orderList: orderList ?? _orderList,
);
  num? get success => _success;
  String? get message => _message;
  num? get totalAmount => _totalAmount;
  num? get todaysSale => _todaysSale;
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

/// order_number : "SALE-0000000032"
/// order_id : "32"
/// customer_id : "1"
/// customer_name : "Aabad Food Pvt. Ltd. 1"
/// sub_total : "5000"
/// discount : "10"
/// adjustments : "100"
/// grand_total : "5000"
/// order_status : "success"
/// created_at : "12:56pm 22 Nov 2022 "

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
      String? createdAt,}){
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
    return map;
  }

}