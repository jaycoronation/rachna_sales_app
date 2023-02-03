import 'dart:convert';
/// success : 1
/// message : "OTP Verified successfully!"
/// user : {"user_id":2,"name":"Jayes","email":"raj@coronation.i","emp_phone":"9987933004","has_login_pin":false,"access_token":"OTY2MjFhNDQ0ZDU1NDBlNmIyMjY1NzY3MzMwN2NlMTA="}

VerifyOtpResponseModel verifyOtpResponseModelFromJson(String str) => VerifyOtpResponseModel.fromJson(json.decode(str));
String verifyOtpResponseModelToJson(VerifyOtpResponseModel data) => json.encode(data.toJson());
class VerifyOtpResponseModel {
  VerifyOtpResponseModel({
      num? success, 
      String? message, 
      User? user,}){
    _success = success;
    _message = message;
    _user = user;
}

  VerifyOtpResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  num? _success;
  String? _message;
  User? _user;
VerifyOtpResponseModel copyWith({  num? success,
  String? message,
  User? user,
}) => VerifyOtpResponseModel(  success: success ?? _success,
  message: message ?? _message,
  user: user ?? _user,
);
  num? get success => _success;
  String? get message => _message;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}

/// user_id : 2
/// name : "Jayes"
/// email : "raj@coronation.i"
/// emp_phone : "9987933004"
/// has_login_pin : false
/// access_token : "OTY2MjFhNDQ0ZDU1NDBlNmIyMjY1NzY3MzMwN2NlMTA="

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      num? userId, 
      String? name, 
      String? email, 
      String? empPhone, 
      bool? hasLoginPin, 
      String? accessToken,}){
    _userId = userId;
    _name = name;
    _email = email;
    _empPhone = empPhone;
    _hasLoginPin = hasLoginPin;
    _accessToken = accessToken;
}

  User.fromJson(dynamic json) {
    _userId = json['user_id'];
    _name = json['name'];
    _email = json['email'];
    _empPhone = json['emp_phone'];
    _hasLoginPin = json['has_login_pin'];
    _accessToken = json['access_token'];
  }
  num? _userId;
  String? _name;
  String? _email;
  String? _empPhone;
  bool? _hasLoginPin;
  String? _accessToken;
User copyWith({  num? userId,
  String? name,
  String? email,
  String? empPhone,
  bool? hasLoginPin,
  String? accessToken,
}) => User(  userId: userId ?? _userId,
  name: name ?? _name,
  email: email ?? _email,
  empPhone: empPhone ?? _empPhone,
  hasLoginPin: hasLoginPin ?? _hasLoginPin,
  accessToken: accessToken ?? _accessToken,
);
  num? get userId => _userId;
  String? get name => _name;
  String? get email => _email;
  String? get empPhone => _empPhone;
  bool? get hasLoginPin => _hasLoginPin;
  String? get accessToken => _accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['name'] = _name;
    map['email'] = _email;
    map['emp_phone'] = _empPhone;
    map['has_login_pin'] = _hasLoginPin;
    map['access_token'] = _accessToken;
    return map;
  }

}