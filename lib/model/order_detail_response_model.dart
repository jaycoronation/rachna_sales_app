import 'dart:convert';
/// success : 1
/// message : "Order details found"
/// order : {"order_id":"34","customer_id":"3250","customer_name":"Cheda store","customer_mobile":"","address_line1":"52/B","address_line2":"opp matunga station","pincode":"400019","country_name":"india","state_name":"maharashtra","city":"","sub_total":"1000","discount":"10","adjustments":"","order_status":"","order_date":"Thu, 2 February 2023","delivery_date":"Tue, 7 February 2023","shipping_charge":"150","payment_mode":"CASH","grand_total":"1050","orderItems":[{"order_id":"34","item_id":"25","item_qty":"1","item_price":"1000","item_total":"1000","stock_id":"3","stock_name":"Item21","parent":"","description":"description","valuation_method":"Avg. Cost","hsn_code":"","integrated_tax":"0","central_tax":"","state_tax":"","cess":"","created_at":"09:54am 02 Feb 2023 "}]}

OrderDetailResponseModel orderDetailResponseModelFromJson(String str) => OrderDetailResponseModel.fromJson(json.decode(str));
String orderDetailResponseModelToJson(OrderDetailResponseModel data) => json.encode(data.toJson());
class OrderDetailResponseModel {
  OrderDetailResponseModel({
      num? success, 
      String? message, 
      Order? order,}){
    _success = success;
    _message = message;
    _order = order;
}

  OrderDetailResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
  num? _success;
  String? _message;
  Order? _order;
OrderDetailResponseModel copyWith({  num? success,
  String? message,
  Order? order,
}) => OrderDetailResponseModel(  success: success ?? _success,
  message: message ?? _message,
  order: order ?? _order,
);
  num? get success => _success;
  String? get message => _message;
  Order? get order => _order;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_order != null) {
      map['order'] = _order?.toJson();
    }
    return map;
  }

}

/// order_id : "34"
/// customer_id : "3250"
/// customer_name : "Cheda store"
/// customer_mobile : ""
/// address_line1 : "52/B"
/// address_line2 : "opp matunga station"
/// pincode : "400019"
/// country_name : "india"
/// state_name : "maharashtra"
/// city : ""
/// sub_total : "1000"
/// discount : "10"
/// adjustments : ""
/// order_status : ""
/// order_date : "Thu, 2 February 2023"
/// delivery_date : "Tue, 7 February 2023"
/// shipping_charge : "150"
/// payment_mode : "CASH"
/// grand_total : "1050"
/// orderItems : [{"order_id":"34","item_id":"25","item_qty":"1","item_price":"1000","item_total":"1000","stock_id":"3","stock_name":"Item21","parent":"","description":"description","valuation_method":"Avg. Cost","hsn_code":"","integrated_tax":"0","central_tax":"","state_tax":"","cess":"","created_at":"09:54am 02 Feb 2023 "}]

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
String orderToJson(Order data) => json.encode(data.toJson());
class Order {
  Order({
      String? orderId, 
      String? customerId, 
      String? customerName, 
      String? customerMobile, 
      String? addressLine1, 
      String? addressLine2, 
      String? pincode, 
      String? countryName, 
      String? stateName, 
      String? city, 
      String? subTotal, 
      String? discount, 
      String? adjustments, 
      String? orderStatus, 
      String? orderDate, 
      String? deliveryDate, 
      String? shippingCharge, 
      String? paymentMode, 
      String? grandTotal, 
      List<OrderItems>? orderItems,}){
    _orderId = orderId;
    _customerId = customerId;
    _customerName = customerName;
    _customerMobile = customerMobile;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _pincode = pincode;
    _countryName = countryName;
    _stateName = stateName;
    _city = city;
    _subTotal = subTotal;
    _discount = discount;
    _adjustments = adjustments;
    _orderStatus = orderStatus;
    _orderDate = orderDate;
    _deliveryDate = deliveryDate;
    _shippingCharge = shippingCharge;
    _paymentMode = paymentMode;
    _grandTotal = grandTotal;
    _orderItems = orderItems;
}

  Order.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _customerId = json['customer_id'];
    _customerName = json['customer_name'];
    _customerMobile = json['customer_mobile'];
    _addressLine1 = json['address_line1'];
    _addressLine2 = json['address_line2'];
    _pincode = json['pincode'];
    _countryName = json['country_name'];
    _stateName = json['state_name'];
    _city = json['city'];
    _subTotal = json['sub_total'];
    _discount = json['discount'];
    _adjustments = json['adjustments'];
    _orderStatus = json['order_status'];
    _orderDate = json['order_date'];
    _deliveryDate = json['delivery_date'];
    _shippingCharge = json['shipping_charge'];
    _paymentMode = json['payment_mode'];
    _grandTotal = json['grand_total'];
    if (json['orderItems'] != null) {
      _orderItems = [];
      json['orderItems'].forEach((v) {
        _orderItems?.add(OrderItems.fromJson(v));
      });
    }
  }
  String? _orderId;
  String? _customerId;
  String? _customerName;
  String? _customerMobile;
  String? _addressLine1;
  String? _addressLine2;
  String? _pincode;
  String? _countryName;
  String? _stateName;
  String? _city;
  String? _subTotal;
  String? _discount;
  String? _adjustments;
  String? _orderStatus;
  String? _orderDate;
  String? _deliveryDate;
  String? _shippingCharge;
  String? _paymentMode;
  String? _grandTotal;
  List<OrderItems>? _orderItems;
Order copyWith({  String? orderId,
  String? customerId,
  String? customerName,
  String? customerMobile,
  String? addressLine1,
  String? addressLine2,
  String? pincode,
  String? countryName,
  String? stateName,
  String? city,
  String? subTotal,
  String? discount,
  String? adjustments,
  String? orderStatus,
  String? orderDate,
  String? deliveryDate,
  String? shippingCharge,
  String? paymentMode,
  String? grandTotal,
  List<OrderItems>? orderItems,
}) => Order(  orderId: orderId ?? _orderId,
  customerId: customerId ?? _customerId,
  customerName: customerName ?? _customerName,
  customerMobile: customerMobile ?? _customerMobile,
  addressLine1: addressLine1 ?? _addressLine1,
  addressLine2: addressLine2 ?? _addressLine2,
  pincode: pincode ?? _pincode,
  countryName: countryName ?? _countryName,
  stateName: stateName ?? _stateName,
  city: city ?? _city,
  subTotal: subTotal ?? _subTotal,
  discount: discount ?? _discount,
  adjustments: adjustments ?? _adjustments,
  orderStatus: orderStatus ?? _orderStatus,
  orderDate: orderDate ?? _orderDate,
  deliveryDate: deliveryDate ?? _deliveryDate,
  shippingCharge: shippingCharge ?? _shippingCharge,
  paymentMode: paymentMode ?? _paymentMode,
  grandTotal: grandTotal ?? _grandTotal,
  orderItems: orderItems ?? _orderItems,
);
  String? get orderId => _orderId;
  String? get customerId => _customerId;
  String? get customerName => _customerName;
  String? get customerMobile => _customerMobile;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  String? get pincode => _pincode;
  String? get countryName => _countryName;
  String? get stateName => _stateName;
  String? get city => _city;
  String? get subTotal => _subTotal;
  String? get discount => _discount;
  String? get adjustments => _adjustments;
  String? get orderStatus => _orderStatus;
  String? get orderDate => _orderDate;
  String? get deliveryDate => _deliveryDate;
  String? get shippingCharge => _shippingCharge;
  String? get paymentMode => _paymentMode;
  String? get grandTotal => _grandTotal;
  List<OrderItems>? get orderItems => _orderItems;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['customer_id'] = _customerId;
    map['customer_name'] = _customerName;
    map['customer_mobile'] = _customerMobile;
    map['address_line1'] = _addressLine1;
    map['address_line2'] = _addressLine2;
    map['pincode'] = _pincode;
    map['country_name'] = _countryName;
    map['state_name'] = _stateName;
    map['city'] = _city;
    map['sub_total'] = _subTotal;
    map['discount'] = _discount;
    map['adjustments'] = _adjustments;
    map['order_status'] = _orderStatus;
    map['order_date'] = _orderDate;
    map['delivery_date'] = _deliveryDate;
    map['shipping_charge'] = _shippingCharge;
    map['payment_mode'] = _paymentMode;
    map['grand_total'] = _grandTotal;
    if (_orderItems != null) {
      map['orderItems'] = _orderItems?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// order_id : "34"
/// item_id : "25"
/// item_qty : "1"
/// item_price : "1000"
/// item_total : "1000"
/// stock_id : "3"
/// stock_name : "Item21"
/// parent : ""
/// description : "description"
/// valuation_method : "Avg. Cost"
/// hsn_code : ""
/// integrated_tax : "0"
/// central_tax : ""
/// state_tax : ""
/// cess : ""
/// created_at : "09:54am 02 Feb 2023 "

OrderItems orderItemsFromJson(String str) => OrderItems.fromJson(json.decode(str));
String orderItemsToJson(OrderItems data) => json.encode(data.toJson());
class OrderItems {
  OrderItems({
      String? orderId, 
      String? itemId, 
      String? itemQty, 
      String? itemPrice, 
      String? itemTotal, 
      String? stockId, 
      String? stockName, 
      String? parent, 
      String? description, 
      String? valuationMethod, 
      String? hsnCode, 
      String? integratedTax, 
      String? centralTax, 
      String? stateTax, 
      String? cess, 
      String? createdAt,}){
    _orderId = orderId;
    _itemId = itemId;
    _itemQty = itemQty;
    _itemPrice = itemPrice;
    _itemTotal = itemTotal;
    _stockId = stockId;
    _stockName = stockName;
    _parent = parent;
    _description = description;
    _valuationMethod = valuationMethod;
    _hsnCode = hsnCode;
    _integratedTax = integratedTax;
    _centralTax = centralTax;
    _stateTax = stateTax;
    _cess = cess;
    _createdAt = createdAt;
}

  OrderItems.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _itemId = json['item_id'];
    _itemQty = json['item_qty'];
    _itemPrice = json['item_price'];
    _itemTotal = json['item_total'];
    _stockId = json['stock_id'];
    _stockName = json['stock_name'];
    _parent = json['parent'];
    _description = json['description'];
    _valuationMethod = json['valuation_method'];
    _hsnCode = json['hsn_code'];
    _integratedTax = json['integrated_tax'];
    _centralTax = json['central_tax'];
    _stateTax = json['state_tax'];
    _cess = json['cess'];
    _createdAt = json['created_at'];
  }
  String? _orderId;
  String? _itemId;
  String? _itemQty;
  String? _itemPrice;
  String? _itemTotal;
  String? _stockId;
  String? _stockName;
  String? _parent;
  String? _description;
  String? _valuationMethod;
  String? _hsnCode;
  String? _integratedTax;
  String? _centralTax;
  String? _stateTax;
  String? _cess;
  String? _createdAt;
OrderItems copyWith({  String? orderId,
  String? itemId,
  String? itemQty,
  String? itemPrice,
  String? itemTotal,
  String? stockId,
  String? stockName,
  String? parent,
  String? description,
  String? valuationMethod,
  String? hsnCode,
  String? integratedTax,
  String? centralTax,
  String? stateTax,
  String? cess,
  String? createdAt,
}) => OrderItems(  orderId: orderId ?? _orderId,
  itemId: itemId ?? _itemId,
  itemQty: itemQty ?? _itemQty,
  itemPrice: itemPrice ?? _itemPrice,
  itemTotal: itemTotal ?? _itemTotal,
  stockId: stockId ?? _stockId,
  stockName: stockName ?? _stockName,
  parent: parent ?? _parent,
  description: description ?? _description,
  valuationMethod: valuationMethod ?? _valuationMethod,
  hsnCode: hsnCode ?? _hsnCode,
  integratedTax: integratedTax ?? _integratedTax,
  centralTax: centralTax ?? _centralTax,
  stateTax: stateTax ?? _stateTax,
  cess: cess ?? _cess,
  createdAt: createdAt ?? _createdAt,
);
  String? get orderId => _orderId;
  String? get itemId => _itemId;
  String? get itemQty => _itemQty;
  String? get itemPrice => _itemPrice;
  String? get itemTotal => _itemTotal;
  String? get stockId => _stockId;
  String? get stockName => _stockName;
  String? get parent => _parent;
  String? get description => _description;
  String? get valuationMethod => _valuationMethod;
  String? get hsnCode => _hsnCode;
  String? get integratedTax => _integratedTax;
  String? get centralTax => _centralTax;
  String? get stateTax => _stateTax;
  String? get cess => _cess;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['item_id'] = _itemId;
    map['item_qty'] = _itemQty;
    map['item_price'] = _itemPrice;
    map['item_total'] = _itemTotal;
    map['stock_id'] = _stockId;
    map['stock_name'] = _stockName;
    map['parent'] = _parent;
    map['description'] = _description;
    map['valuation_method'] = _valuationMethod;
    map['hsn_code'] = _hsnCode;
    map['integrated_tax'] = _integratedTax;
    map['central_tax'] = _centralTax;
    map['state_tax'] = _stateTax;
    map['cess'] = _cess;
    map['created_at'] = _createdAt;
    return map;
  }

}