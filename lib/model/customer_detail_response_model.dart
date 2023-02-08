import 'dart:convert';
/// success : 1
/// message : ""
/// customerListCount : "1"
/// total_sale : "12070"
/// total_overdue : "0"
/// customerDetails : {"customer_id":"3255","tally_id":"1","customer_name":"salt","address_line1":"ahm","address_line2":"ahm","pincode":"380015","country_name":"india","gst_registration_type":"Regular","state_name":"Gujarat","parent":"","gst_applicable":"Yes","bill_credit_period":"90","bank_details":"","email_cc":"","ledger_phone":"","ledger_contact":"","ledger_mobile":"","led_bank_name":"","led_bank_ac_no":"","led_bank_ifsc_code":"","led_bank_swift_code":"","gst_type":"Regular","customer_gst":"","credit_limit":"100000","created_at":"1675399059","updated_at":"1675399059","deleted_at":"","is_deleted":"0","status":"Y","company_id":"1","address_line3":"ahm","address_line4":"ahm","address_line5":"ahm","area_name":"ahm","city_name":"ahm","contact_person":"raj","customer_total_sale":"12070","customer_transection":[{"id":"1","transection_amount":"3000","transection_mode":"cc","transection_type":"2","transection_status":"success","transection_date":"31-01-2023"},{"id":"2","transection_amount":"2000","transection_mode":"cc","transection_type":"2","transection_status":"success","transection_date":"31-01-2023"}],"sales_history":[{"order_id":"43","order_number":"SALE-0000000001","grand_total":"1470","total_item":"3","created_at":"03-02-2023"},{"order_id":"45","order_number":"SALE-0000000045","grand_total":"9600","total_item":"2","created_at":"03-02-2023"},{"order_id":"47","order_number":"SALE-0000000047","grand_total":"1000","total_item":"1","created_at":"03-02-2023"}]}

CustomerDetailResponseModel customerDetailResponseModelFromJson(String str) => CustomerDetailResponseModel.fromJson(json.decode(str));
String customerDetailResponseModelToJson(CustomerDetailResponseModel data) => json.encode(data.toJson());
class CustomerDetailResponseModel {
  CustomerDetailResponseModel({
      num? success, 
      String? message, 
      String? customerListCount, 
      String? totalSale, 
      String? totalOverdue, 
      CustomerDetails? customerDetails,}){
    _success = success;
    _message = message;
    _customerListCount = customerListCount;
    _totalSale = totalSale;
    _totalOverdue = totalOverdue;
    _customerDetails = customerDetails;
}

  CustomerDetailResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _customerListCount = json['customerListCount'];
    _totalSale = json['total_sale'];
    _totalOverdue = json['total_overdue'];
    _customerDetails = json['customerDetails'] != null ? CustomerDetails.fromJson(json['customerDetails']) : null;
  }
  num? _success;
  String? _message;
  String? _customerListCount;
  String? _totalSale;
  String? _totalOverdue;
  CustomerDetails? _customerDetails;
CustomerDetailResponseModel copyWith({  num? success,
  String? message,
  String? customerListCount,
  String? totalSale,
  String? totalOverdue,
  CustomerDetails? customerDetails,
}) => CustomerDetailResponseModel(  success: success ?? _success,
  message: message ?? _message,
  customerListCount: customerListCount ?? _customerListCount,
  totalSale: totalSale ?? _totalSale,
  totalOverdue: totalOverdue ?? _totalOverdue,
  customerDetails: customerDetails ?? _customerDetails,
);
  num? get success => _success;
  String? get message => _message;
  String? get customerListCount => _customerListCount;
  String? get totalSale => _totalSale;
  String? get totalOverdue => _totalOverdue;
  CustomerDetails? get customerDetails => _customerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['customerListCount'] = _customerListCount;
    map['total_sale'] = _totalSale;
    map['total_overdue'] = _totalOverdue;
    if (_customerDetails != null) {
      map['customerDetails'] = _customerDetails?.toJson();
    }
    return map;
  }

}

/// customer_id : "3255"
/// tally_id : "1"
/// customer_name : "salt"
/// address_line1 : "ahm"
/// address_line2 : "ahm"
/// pincode : "380015"
/// country_name : "india"
/// gst_registration_type : "Regular"
/// state_name : "Gujarat"
/// parent : ""
/// gst_applicable : "Yes"
/// bill_credit_period : "90"
/// bank_details : ""
/// email_cc : ""
/// ledger_phone : ""
/// ledger_contact : ""
/// ledger_mobile : ""
/// led_bank_name : ""
/// led_bank_ac_no : ""
/// led_bank_ifsc_code : ""
/// led_bank_swift_code : ""
/// gst_type : "Regular"
/// customer_gst : ""
/// credit_limit : "100000"
/// created_at : "1675399059"
/// updated_at : "1675399059"
/// deleted_at : ""
/// is_deleted : "0"
/// status : "Y"
/// company_id : "1"
/// address_line3 : "ahm"
/// address_line4 : "ahm"
/// address_line5 : "ahm"
/// area_name : "ahm"
/// city_name : "ahm"
/// contact_person : "raj"
/// customer_total_sale : "12070"
/// customer_transection : [{"id":"1","transection_amount":"3000","transection_mode":"cc","transection_type":"2","transection_status":"success","transection_date":"31-01-2023"},{"id":"2","transection_amount":"2000","transection_mode":"cc","transection_type":"2","transection_status":"success","transection_date":"31-01-2023"}]
/// sales_history : [{"order_id":"43","order_number":"SALE-0000000001","grand_total":"1470","total_item":"3","created_at":"03-02-2023"},{"order_id":"45","order_number":"SALE-0000000045","grand_total":"9600","total_item":"2","created_at":"03-02-2023"},{"order_id":"47","order_number":"SALE-0000000047","grand_total":"1000","total_item":"1","created_at":"03-02-2023"}]

CustomerDetails customerDetailsFromJson(String str) => CustomerDetails.fromJson(json.decode(str));
String customerDetailsToJson(CustomerDetails data) => json.encode(data.toJson());
class CustomerDetails {
  CustomerDetails({
      String? customerId, 
      String? tallyId, 
      String? customerName, 
      String? addressLine1, 
      String? addressLine2, 
      String? pincode, 
      String? countryName, 
      String? gstRegistrationType, 
      String? stateName, 
      String? parent, 
      String? gstApplicable, 
      String? billCreditPeriod, 
      String? bankDetails, 
      String? emailCc, 
      String? ledgerPhone, 
      String? ledgerContact, 
      String? ledgerMobile, 
      String? ledBankName, 
      String? ledBankAcNo, 
      String? ledBankIfscCode, 
      String? ledBankSwiftCode, 
      String? gstType, 
      String? customerGst, 
      String? creditLimit, 
      String? createdAt, 
      String? updatedAt, 
      String? deletedAt, 
      String? isDeleted, 
      String? status, 
      String? companyId, 
      String? addressLine3, 
      String? addressLine4, 
      String? addressLine5, 
      String? areaName, 
      String? cityName, 
      String? contactPerson, 
      String? customerTotalSale,
    String? customerTotalOverdue,

    List<CustomerTransection>? customerTransection,
      List<SalesHistory>? salesHistory,}){
    _customerId = customerId;
    _tallyId = tallyId;
    _customerName = customerName;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _pincode = pincode;
    _countryName = countryName;
    _gstRegistrationType = gstRegistrationType;
    _stateName = stateName;
    _parent = parent;
    _gstApplicable = gstApplicable;
    _billCreditPeriod = billCreditPeriod;
    _bankDetails = bankDetails;
    _emailCc = emailCc;
    _ledgerPhone = ledgerPhone;
    _ledgerContact = ledgerContact;
    _ledgerMobile = ledgerMobile;
    _ledBankName = ledBankName;
    _ledBankAcNo = ledBankAcNo;
    _ledBankIfscCode = ledBankIfscCode;
    _ledBankSwiftCode = ledBankSwiftCode;
    _gstType = gstType;
    _customerGst = customerGst;
    _creditLimit = creditLimit;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _isDeleted = isDeleted;
    _status = status;
    _companyId = companyId;
    _addressLine3 = addressLine3;
    _addressLine4 = addressLine4;
    _addressLine5 = addressLine5;
    _areaName = areaName;
    _cityName = cityName;
    _contactPerson = contactPerson;
    _customerTotalSale = customerTotalSale;
    _customerTotalOverdue = customerTotalOverdue;
    _customerTransection = customerTransection;
    _salesHistory = salesHistory;
}

  CustomerDetails.fromJson(dynamic json) {
    _customerId = json['customer_id'];
    _tallyId = json['tally_id'];
    _customerName = json['customer_name'];
    _addressLine1 = json['address_line1'];
    _addressLine2 = json['address_line2'];
    _pincode = json['pincode'];
    _countryName = json['country_name'];
    _gstRegistrationType = json['gst_registration_type'];
    _stateName = json['state_name'];
    _parent = json['parent'];
    _gstApplicable = json['gst_applicable'];
    _billCreditPeriod = json['bill_credit_period'];
    _bankDetails = json['bank_details'];
    _emailCc = json['email_cc'];
    _ledgerPhone = json['ledger_phone'];
    _ledgerContact = json['ledger_contact'];
    _ledgerMobile = json['ledger_mobile'];
    _ledBankName = json['led_bank_name'];
    _ledBankAcNo = json['led_bank_ac_no'];
    _ledBankIfscCode = json['led_bank_ifsc_code'];
    _ledBankSwiftCode = json['led_bank_swift_code'];
    _gstType = json['gst_type'];
    _customerGst = json['customer_gst'];
    _creditLimit = json['credit_limit'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _isDeleted = json['is_deleted'];
    _status = json['status'];
    _companyId = json['company_id'];
    _addressLine3 = json['address_line3'];
    _addressLine4 = json['address_line4'];
    _addressLine5 = json['address_line5'];
    _areaName = json['area_name'];
    _cityName = json['city_name'];
    _contactPerson = json['contact_person'];
    _customerTotalSale = json['customer_total_sale'];
    _customerTotalOverdue = json['customer_total_overdue'];
    if (json['customer_transection'] != null) {
      _customerTransection = [];
      json['customer_transection'].forEach((v) {
        _customerTransection?.add(CustomerTransection.fromJson(v));
      });
    }
    if (json['sales_history'] != null) {
      _salesHistory = [];
      json['sales_history'].forEach((v) {
        _salesHistory?.add(SalesHistory.fromJson(v));
      });
    }
  }
  String? _customerId;
  String? _tallyId;
  String? _customerName;
  String? _addressLine1;
  String? _addressLine2;
  String? _pincode;
  String? _countryName;
  String? _gstRegistrationType;
  String? _stateName;
  String? _parent;
  String? _gstApplicable;
  String? _billCreditPeriod;
  String? _bankDetails;
  String? _emailCc;
  String? _ledgerPhone;
  String? _ledgerContact;
  String? _ledgerMobile;
  String? _ledBankName;
  String? _ledBankAcNo;
  String? _ledBankIfscCode;
  String? _ledBankSwiftCode;
  String? _gstType;
  String? _customerGst;
  String? _creditLimit;
  String? _createdAt;
  String? _updatedAt;
  String? _deletedAt;
  String? _isDeleted;
  String? _status;
  String? _companyId;
  String? _addressLine3;
  String? _addressLine4;
  String? _addressLine5;
  String? _areaName;
  String? _cityName;
  String? _contactPerson;
  String? _customerTotalSale;
  String? _customerTotalOverdue;
  List<CustomerTransection>? _customerTransection;
  List<SalesHistory>? _salesHistory;
CustomerDetails copyWith({  String? customerId,
  String? tallyId,
  String? customerName,
  String? addressLine1,
  String? addressLine2,
  String? pincode,
  String? countryName,
  String? gstRegistrationType,
  String? stateName,
  String? parent,
  String? gstApplicable,
  String? billCreditPeriod,
  String? bankDetails,
  String? emailCc,
  String? ledgerPhone,
  String? ledgerContact,
  String? ledgerMobile,
  String? ledBankName,
  String? ledBankAcNo,
  String? ledBankIfscCode,
  String? ledBankSwiftCode,
  String? gstType,
  String? customerGst,
  String? creditLimit,
  String? createdAt,
  String? updatedAt,
  String? deletedAt,
  String? isDeleted,
  String? status,
  String? companyId,
  String? addressLine3,
  String? addressLine4,
  String? addressLine5,
  String? areaName,
  String? cityName,
  String? contactPerson,
  String? customerTotalSale,
  String? customerTotalOverdue,
  List<CustomerTransection>? customerTransection,
  List<SalesHistory>? salesHistory,
}) => CustomerDetails(  customerId: customerId ?? _customerId,
  tallyId: tallyId ?? _tallyId,
  customerName: customerName ?? _customerName,
  addressLine1: addressLine1 ?? _addressLine1,
  addressLine2: addressLine2 ?? _addressLine2,
  pincode: pincode ?? _pincode,
  countryName: countryName ?? _countryName,
  gstRegistrationType: gstRegistrationType ?? _gstRegistrationType,
  stateName: stateName ?? _stateName,
  parent: parent ?? _parent,
  gstApplicable: gstApplicable ?? _gstApplicable,
  billCreditPeriod: billCreditPeriod ?? _billCreditPeriod,
  bankDetails: bankDetails ?? _bankDetails,
  emailCc: emailCc ?? _emailCc,
  ledgerPhone: ledgerPhone ?? _ledgerPhone,
  ledgerContact: ledgerContact ?? _ledgerContact,
  ledgerMobile: ledgerMobile ?? _ledgerMobile,
  ledBankName: ledBankName ?? _ledBankName,
  ledBankAcNo: ledBankAcNo ?? _ledBankAcNo,
  ledBankIfscCode: ledBankIfscCode ?? _ledBankIfscCode,
  ledBankSwiftCode: ledBankSwiftCode ?? _ledBankSwiftCode,
  gstType: gstType ?? _gstType,
  customerGst: customerGst ?? _customerGst,
  creditLimit: creditLimit ?? _creditLimit,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  deletedAt: deletedAt ?? _deletedAt,
  isDeleted: isDeleted ?? _isDeleted,
  status: status ?? _status,
  companyId: companyId ?? _companyId,
  addressLine3: addressLine3 ?? _addressLine3,
  addressLine4: addressLine4 ?? _addressLine4,
  addressLine5: addressLine5 ?? _addressLine5,
  areaName: areaName ?? _areaName,
  cityName: cityName ?? _cityName,
  contactPerson: contactPerson ?? _contactPerson,
  customerTotalSale: customerTotalSale ?? _customerTotalSale,
  customerTotalOverdue : customerTotalOverdue ?? _customerTotalOverdue,
  customerTransection: customerTransection ?? _customerTransection,
  salesHistory: salesHistory ?? _salesHistory,
);
  String? get customerId => _customerId;
  String? get tallyId => _tallyId;
  String? get customerName => _customerName;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  String? get pincode => _pincode;
  String? get countryName => _countryName;
  String? get gstRegistrationType => _gstRegistrationType;
  String? get stateName => _stateName;
  String? get parent => _parent;
  String? get gstApplicable => _gstApplicable;
  String? get billCreditPeriod => _billCreditPeriod;
  String? get bankDetails => _bankDetails;
  String? get emailCc => _emailCc;
  String? get ledgerPhone => _ledgerPhone;
  String? get ledgerContact => _ledgerContact;
  String? get ledgerMobile => _ledgerMobile;
  String? get ledBankName => _ledBankName;
  String? get ledBankAcNo => _ledBankAcNo;
  String? get ledBankIfscCode => _ledBankIfscCode;
  String? get ledBankSwiftCode => _ledBankSwiftCode;
  String? get gstType => _gstType;
  String? get customerGst => _customerGst;
  String? get creditLimit => _creditLimit;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get deletedAt => _deletedAt;
  String? get isDeleted => _isDeleted;
  String? get status => _status;
  String? get companyId => _companyId;
  String? get addressLine3 => _addressLine3;
  String? get addressLine4 => _addressLine4;
  String? get addressLine5 => _addressLine5;
  String? get areaName => _areaName;
  String? get cityName => _cityName;
  String? get contactPerson => _contactPerson;
  String? get customerTotalSale => _customerTotalSale;
  String? get customerTotalOverdue => _customerTotalOverdue;


  List<CustomerTransection>? get customerTransection => _customerTransection;
  List<SalesHistory>? get salesHistory => _salesHistory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['customer_id'] = _customerId;
    map['tally_id'] = _tallyId;
    map['customer_name'] = _customerName;
    map['address_line1'] = _addressLine1;
    map['address_line2'] = _addressLine2;
    map['pincode'] = _pincode;
    map['country_name'] = _countryName;
    map['gst_registration_type'] = _gstRegistrationType;
    map['state_name'] = _stateName;
    map['parent'] = _parent;
    map['gst_applicable'] = _gstApplicable;
    map['bill_credit_period'] = _billCreditPeriod;
    map['bank_details'] = _bankDetails;
    map['email_cc'] = _emailCc;
    map['ledger_phone'] = _ledgerPhone;
    map['ledger_contact'] = _ledgerContact;
    map['ledger_mobile'] = _ledgerMobile;
    map['led_bank_name'] = _ledBankName;
    map['led_bank_ac_no'] = _ledBankAcNo;
    map['led_bank_ifsc_code'] = _ledBankIfscCode;
    map['led_bank_swift_code'] = _ledBankSwiftCode;
    map['gst_type'] = _gstType;
    map['customer_gst'] = _customerGst;
    map['credit_limit'] = _creditLimit;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    map['is_deleted'] = _isDeleted;
    map['status'] = _status;
    map['company_id'] = _companyId;
    map['address_line3'] = _addressLine3;
    map['address_line4'] = _addressLine4;
    map['address_line5'] = _addressLine5;
    map['area_name'] = _areaName;
    map['city_name'] = _cityName;
    map['contact_person'] = _contactPerson;
    map['customer_total_sale'] = _customerTotalSale;
    map['customer_total_overdue'] = _customerTotalOverdue;

    if (_customerTransection != null) {
      map['customer_transection'] = _customerTransection?.map((v) => v.toJson()).toList();
    }
    if (_salesHistory != null) {
      map['sales_history'] = _salesHistory?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// order_id : "43"
/// order_number : "SALE-0000000001"
/// grand_total : "1470"
/// total_item : "3"
/// created_at : "03-02-2023"

SalesHistory salesHistoryFromJson(String str) => SalesHistory.fromJson(json.decode(str));
String salesHistoryToJson(SalesHistory data) => json.encode(data.toJson());
class SalesHistory {
  SalesHistory({
      String? orderId, 
      String? orderNumber, 
      String? grandTotal, 
      String? totalItem, 
      String? createdAt,}){
    _orderId = orderId;
    _orderNumber = orderNumber;
    _grandTotal = grandTotal;
    _totalItem = totalItem;
    _createdAt = createdAt;
}

  SalesHistory.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _orderNumber = json['order_number'];
    _grandTotal = json['grand_total'];
    _totalItem = json['total_item'];
    _createdAt = json['created_at'];
  }
  String? _orderId;
  String? _orderNumber;
  String? _grandTotal;
  String? _totalItem;
  String? _createdAt;
SalesHistory copyWith({  String? orderId,
  String? orderNumber,
  String? grandTotal,
  String? totalItem,
  String? createdAt,
}) => SalesHistory(  orderId: orderId ?? _orderId,
  orderNumber: orderNumber ?? _orderNumber,
  grandTotal: grandTotal ?? _grandTotal,
  totalItem: totalItem ?? _totalItem,
  createdAt: createdAt ?? _createdAt,
);
  String? get orderId => _orderId;
  String? get orderNumber => _orderNumber;
  String? get grandTotal => _grandTotal;
  String? get totalItem => _totalItem;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['order_number'] = _orderNumber;
    map['grand_total'] = _grandTotal;
    map['total_item'] = _totalItem;
    map['created_at'] = _createdAt;
    return map;
  }

}

/// id : "1"
/// transection_amount : "3000"
/// transection_mode : "cc"
/// transection_type : "2"
/// transection_status : "success"
/// transection_date : "31-01-2023"

CustomerTransection customerTransectionFromJson(String str) => CustomerTransection.fromJson(json.decode(str));
String customerTransectionToJson(CustomerTransection data) => json.encode(data.toJson());
class CustomerTransection {
  CustomerTransection({
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

  CustomerTransection.fromJson(dynamic json) {
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
CustomerTransection copyWith({  String? id,
  String? transectionAmount,
  String? transectionMode,
  String? transectionType,
  String? transectionStatus,
  String? transectionDate,
}) => CustomerTransection(  id: id ?? _id,
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