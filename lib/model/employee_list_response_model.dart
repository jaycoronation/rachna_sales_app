import 'dart:convert';
/// success : 1
/// totalSale : 76500
/// totalCount : 48
/// employeeList : [{"emp_id":"49","emp_name":"Yash Patel","emp_phone":"9987933034","emp_email":"jayesh@coronation.teerrdd","emp_password":"e10adc3949ba59abbe56e057f20f883e","created_at":"1670929129","updated_at":"","status":"Y","parent":"12","path":"4","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[{"designations_id":"5","designation_name":"HR and Admin Head"}]},{"emp_id":"42","emp_name":"Jayesh Ladva","emp_phone":"99879330011","emp_email":"jayesh1@coronation.in","emp_password":"827ccb0eea8a706c4c34a16891f84e7b","created_at":"1660644602","updated_at":"","status":"Y","parent":"23","path":"3","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[{"designations_id":"23","designation_name":"Drivers"},{"designations_id":"5","designation_name":"HR and Admin Head"},{"designations_id":"5","designation_name":"HR and Admin Head"}]},{"emp_id":"41","emp_name":"Jayesh Ladva","emp_phone":"99879330011","emp_email":"jayesh1@coronation.in","emp_password":"827ccb0eea8a706c4c34a16891f84e7b","created_at":"1660644555","updated_at":"","status":"Y","parent":"6","path":"5,3","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[{"designations_id":"22","designation_name":"Wearhouse Asst 3"},{"designations_id":"5","designation_name":"HR and Admin Head"}]},{"emp_id":"40","emp_name":"Jayesh Ladva","emp_phone":"99879330011","emp_email":"jayesh1@coronation.in","emp_password":"827ccb0eea8a706c4c34a16891f84e7b","created_at":"1660640355","updated_at":"","status":"Y","parent":"5","path":"","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[{"designations_id":"20","designation_name":"Wearhouse Asst 1"},{"designations_id":"5","designation_name":"HR and Admin Head"}]},{"emp_id":"39","emp_name":"Pankaj","emp_phone":"9725059007","emp_email":"raj@coronation.in","emp_password":"827ccb0eea8a706c4c34a16891f84e7b","created_at":"1660544694","updated_at":"1660544694","status":"Y","parent":"3","path":"3,36","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[{"designations_id":"19","designation_name":"Wearhouse Manager"}]},{"emp_id":"38","emp_name":"Roshan","emp_phone":"9725059007","emp_email":"raj@coronation.in","emp_password":"827ccb0eea8a706c4c34a16891f84e7b","created_at":"1660544694","updated_at":"1660544694","status":"Y","parent":"37","path":"3,4,37","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[{"designations_id":"12","designation_name":"Billing Executive"}]},{"emp_id":"37","emp_name":"Mehul","emp_phone":"9725059007","emp_email":"raj@coronation.in","emp_password":"827ccb0eea8a706c4c34a16891f84e7b","created_at":"1660544694","updated_at":"1660544694","status":"Y","parent":"3","path":"3,4","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[]},{"emp_id":"36","emp_name":"Dhey","emp_phone":"9725059007","emp_email":"raj@coronation.in","emp_password":"827ccb0eea8a706c4c34a16891f84e7b","created_at":"1660544694","updated_at":"1660544694","status":"Y","parent":"0","path":"0","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[{"designations_id":"23","designation_name":"Drivers"}]},{"emp_id":"35","emp_name":"Babar","emp_phone":"9725059007","emp_email":"raj@coronation.in","emp_password":"827ccb0eea8a706c4c34a16891f84e7b","created_at":"1660544694","updated_at":"1660544694","status":"Y","parent":"3","path":"3,4","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[{"designations_id":"23","designation_name":"Drivers"}]},{"emp_id":"34","emp_name":"Hitesh","emp_phone":"9725059007","emp_email":"raj@coronation.in","emp_password":"827ccb0eea8a706c4c34a16891f84e7b","created_at":"1660544694","updated_at":"1660544694","status":"Y","parent":"32","path":"3,4,16","last_login":"","last_active":"","authorization_token":"","otp_token":"","login_pin":"","access_token":"","emp_total_sale":0,"designations":[{"designations_id":"23","designation_name":"Drivers"}]}]

EmployeeListResponseModel employeeListResponseModelFromJson(String str) => EmployeeListResponseModel.fromJson(json.decode(str));
String employeeListResponseModelToJson(EmployeeListResponseModel data) => json.encode(data.toJson());
class EmployeeListResponseModel {
  EmployeeListResponseModel({
      num? success, 
      num? totalSale, 
      num? totalCount, 
      List<EmployeeList>? employeeList,}){
    _success = success;
    _totalSale = totalSale;
    _totalCount = totalCount;
    _employeeList = employeeList;
}

  EmployeeListResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _totalSale = json['totalSale'];
    _totalCount = json['totalCount'];
    if (json['employeeList'] != null) {
      _employeeList = [];
      json['employeeList'].forEach((v) {
        _employeeList?.add(EmployeeList.fromJson(v));
      });
    }
  }
  num? _success;
  num? _totalSale;
  num? _totalCount;
  List<EmployeeList>? _employeeList;
EmployeeListResponseModel copyWith({  num? success,
  num? totalSale,
  num? totalCount,
  List<EmployeeList>? employeeList,
}) => EmployeeListResponseModel(  success: success ?? _success,
  totalSale: totalSale ?? _totalSale,
  totalCount: totalCount ?? _totalCount,
  employeeList: employeeList ?? _employeeList,
);
  num? get success => _success;
  num? get totalSale => _totalSale;
  num? get totalCount => _totalCount;
  List<EmployeeList>? get employeeList => _employeeList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['totalSale'] = _totalSale;
    map['totalCount'] = _totalCount;
    if (_employeeList != null) {
      map['employeeList'] = _employeeList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// emp_id : "49"
/// emp_name : "Yash Patel"
/// emp_phone : "9987933034"
/// emp_email : "jayesh@coronation.teerrdd"
/// emp_password : "e10adc3949ba59abbe56e057f20f883e"
/// created_at : "1670929129"
/// updated_at : ""
/// status : "Y"
/// parent : "12"
/// path : "4"
/// last_login : ""
/// last_active : ""
/// authorization_token : ""
/// otp_token : ""
/// login_pin : ""
/// access_token : ""
/// emp_total_sale : 0
/// designations : [{"designations_id":"5","designation_name":"HR and Admin Head"}]

EmployeeList employeeListFromJson(String str) => EmployeeList.fromJson(json.decode(str));
String employeeListToJson(EmployeeList data) => json.encode(data.toJson());
class EmployeeList {
  EmployeeList({
      String? empId, 
      String? empName, 
      String? empPhone, 
      String? empEmail, 
      String? empPassword, 
      String? createdAt, 
      String? updatedAt, 
      String? status, 
      String? parent, 
      String? path, 
      String? lastLogin, 
      String? lastActive, 
      String? authorizationToken, 
      String? otpToken, 
      String? loginPin, 
      String? accessToken, 
      num? empTotalSale, 
      List<Designations>? designations,}){
    _empId = empId;
    _empName = empName;
    _empPhone = empPhone;
    _empEmail = empEmail;
    _empPassword = empPassword;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
    _parent = parent;
    _path = path;
    _lastLogin = lastLogin;
    _lastActive = lastActive;
    _authorizationToken = authorizationToken;
    _otpToken = otpToken;
    _loginPin = loginPin;
    _accessToken = accessToken;
    _empTotalSale = empTotalSale;
    _designations = designations;
}

  EmployeeList.fromJson(dynamic json) {
    _empId = json['emp_id'];
    _empName = json['emp_name'];
    _empPhone = json['emp_phone'];
    _empEmail = json['emp_email'];
    _empPassword = json['emp_password'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _status = json['status'];
    _parent = json['parent'];
    _path = json['path'];
    _lastLogin = json['last_login'];
    _lastActive = json['last_active'];
    _authorizationToken = json['authorization_token'];
    _otpToken = json['otp_token'];
    _loginPin = json['login_pin'];
    _accessToken = json['access_token'];
    _empTotalSale = json['emp_total_sale'];
    if (json['designations'] != null) {
      _designations = [];
      json['designations'].forEach((v) {
        _designations?.add(Designations.fromJson(v));
      });
    }
  }
  String? _empId;
  String? _empName;
  String? _empPhone;
  String? _empEmail;
  String? _empPassword;
  String? _createdAt;
  String? _updatedAt;
  String? _status;
  String? _parent;
  String? _path;
  String? _lastLogin;
  String? _lastActive;
  String? _authorizationToken;
  String? _otpToken;
  String? _loginPin;
  String? _accessToken;
  num? _empTotalSale;
  List<Designations>? _designations;
EmployeeList copyWith({  String? empId,
  String? empName,
  String? empPhone,
  String? empEmail,
  String? empPassword,
  String? createdAt,
  String? updatedAt,
  String? status,
  String? parent,
  String? path,
  String? lastLogin,
  String? lastActive,
  String? authorizationToken,
  String? otpToken,
  String? loginPin,
  String? accessToken,
  num? empTotalSale,
  List<Designations>? designations,
}) => EmployeeList(  empId: empId ?? _empId,
  empName: empName ?? _empName,
  empPhone: empPhone ?? _empPhone,
  empEmail: empEmail ?? _empEmail,
  empPassword: empPassword ?? _empPassword,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  status: status ?? _status,
  parent: parent ?? _parent,
  path: path ?? _path,
  lastLogin: lastLogin ?? _lastLogin,
  lastActive: lastActive ?? _lastActive,
  authorizationToken: authorizationToken ?? _authorizationToken,
  otpToken: otpToken ?? _otpToken,
  loginPin: loginPin ?? _loginPin,
  accessToken: accessToken ?? _accessToken,
  empTotalSale: empTotalSale ?? _empTotalSale,
  designations: designations ?? _designations,
);
  String? get empId => _empId;
  String? get empName => _empName;
  String? get empPhone => _empPhone;
  String? get empEmail => _empEmail;
  String? get empPassword => _empPassword;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get status => _status;
  String? get parent => _parent;
  String? get path => _path;
  String? get lastLogin => _lastLogin;
  String? get lastActive => _lastActive;
  String? get authorizationToken => _authorizationToken;
  String? get otpToken => _otpToken;
  String? get loginPin => _loginPin;
  String? get accessToken => _accessToken;
  num? get empTotalSale => _empTotalSale;
  List<Designations>? get designations => _designations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['emp_id'] = _empId;
    map['emp_name'] = _empName;
    map['emp_phone'] = _empPhone;
    map['emp_email'] = _empEmail;
    map['emp_password'] = _empPassword;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['status'] = _status;
    map['parent'] = _parent;
    map['path'] = _path;
    map['last_login'] = _lastLogin;
    map['last_active'] = _lastActive;
    map['authorization_token'] = _authorizationToken;
    map['otp_token'] = _otpToken;
    map['login_pin'] = _loginPin;
    map['access_token'] = _accessToken;
    map['emp_total_sale'] = _empTotalSale;
    if (_designations != null) {
      map['designations'] = _designations?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// designations_id : "5"
/// designation_name : "HR and Admin Head"

Designations designationsFromJson(String str) => Designations.fromJson(json.decode(str));
String designationsToJson(Designations data) => json.encode(data.toJson());
class Designations {
  Designations({
      String? designationsId, 
      String? designationName,}){
    _designationsId = designationsId;
    _designationName = designationName;
}

  Designations.fromJson(dynamic json) {
    _designationsId = json['designations_id'];
    _designationName = json['designation_name'];
  }
  String? _designationsId;
  String? _designationName;
Designations copyWith({  String? designationsId,
  String? designationName,
}) => Designations(  designationsId: designationsId ?? _designationsId,
  designationName: designationName ?? _designationName,
);
  String? get designationsId => _designationsId;
  String? get designationName => _designationName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['designations_id'] = _designationsId;
    map['designation_name'] = _designationName;
    return map;
  }

}