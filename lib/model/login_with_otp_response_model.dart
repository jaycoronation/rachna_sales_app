import 'dart:convert';
/// success : 1
/// response_code : "005"
/// message : "OTP sent successfully to your Phone number."
/// user : {"user_id":2,"name":"Jayes","email":"raj@coronation.i","phone":"9987933004","has_login_pin":false}

LoginWithOtpResponseModel loginWithOtpResponseModelFromJson(String str) => LoginWithOtpResponseModel.fromJson(json.decode(str));
String loginWithOtpResponseModelToJson(LoginWithOtpResponseModel data) => json.encode(data.toJson());
class LoginWithOtpResponseModel {
  LoginWithOtpResponseModel({
      num? success, 
      String? responseCode, 
      String? message, 
      User? user,}){
    _success = success;
    _responseCode = responseCode;
    _message = message;
    _user = user;
}

  LoginWithOtpResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _responseCode = json['response_code'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  num? _success;
  String? _responseCode;
  String? _message;
  User? _user;
LoginWithOtpResponseModel copyWith({  num? success,
  String? responseCode,
  String? message,
  User? user,
}) => LoginWithOtpResponseModel(  success: success ?? _success,
  responseCode: responseCode ?? _responseCode,
  message: message ?? _message,
  user: user ?? _user,
);
  num? get success => _success;
  String? get responseCode => _responseCode;
  String? get message => _message;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['response_code'] = _responseCode;
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
/// phone : "9987933004"
/// has_login_pin : false

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      num? userId, 
      String? name, 
      String? email, 
      String? phone, 
      bool? hasLoginPin,}){
    _userId = userId;
    _name = name;
    _email = email;
    _phone = phone;
    _hasLoginPin = hasLoginPin;
}

  User.fromJson(dynamic json) {
    _userId = json['user_id'];
    _name = json['name'];
    _email = json['email'];
    _phone = json['phone'];
    _hasLoginPin = json['has_login_pin'];
  }
  num? _userId;
  String? _name;
  String? _email;
  String? _phone;
  bool? _hasLoginPin;
User copyWith({  num? userId,
  String? name,
  String? email,
  String? phone,
  bool? hasLoginPin,
}) => User(  userId: userId ?? _userId,
  name: name ?? _name,
  email: email ?? _email,
  phone: phone ?? _phone,
  hasLoginPin: hasLoginPin ?? _hasLoginPin,
);
  num? get userId => _userId;
  String? get name => _name;
  String? get email => _email;
  String? get phone => _phone;
  bool? get hasLoginPin => _hasLoginPin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['name'] = _name;
    map['email'] = _email;
    map['phone'] = _phone;
    map['has_login_pin'] = _hasLoginPin;
    return map;
  }

}