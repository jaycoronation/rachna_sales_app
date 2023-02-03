import 'dart:convert';
/// success : 1
/// message : "Employee details found"
/// employee_details : {"emp_id":"58","emp_name":"Jignesh","emp_phone":"8529638522","emp_email":"jignesh1@coronation.in","profile":"https://salesapp.coronation.in/assets/upload/profile/1675170997-circle.png","designation":[{"designation_id":"2","designation_name":""},{"designation_id":"5","designation_name":"HR and Admin Head"},{"designation_id":"6","designation_name":"Sales Head"}],"parent":"10","incentive":"0","outstanding":"0","total_sales":"0","total_customers":"0"}

ProfileDetailResponseModel profileDetailResponseModelFromJson(String str) => ProfileDetailResponseModel.fromJson(json.decode(str));
String profileDetailResponseModelToJson(ProfileDetailResponseModel data) => json.encode(data.toJson());
class ProfileDetailResponseModel {
  ProfileDetailResponseModel({
      num? success, 
      String? message, 
      EmployeeDetails? employeeDetails,}){
    _success = success;
    _message = message;
    _employeeDetails = employeeDetails;
}

  ProfileDetailResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _employeeDetails = json['employee_details'] != null ? EmployeeDetails.fromJson(json['employee_details']) : null;
  }
  num? _success;
  String? _message;
  EmployeeDetails? _employeeDetails;
ProfileDetailResponseModel copyWith({  num? success,
  String? message,
  EmployeeDetails? employeeDetails,
}) => ProfileDetailResponseModel(  success: success ?? _success,
  message: message ?? _message,
  employeeDetails: employeeDetails ?? _employeeDetails,
);
  num? get success => _success;
  String? get message => _message;
  EmployeeDetails? get employeeDetails => _employeeDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_employeeDetails != null) {
      map['employee_details'] = _employeeDetails?.toJson();
    }
    return map;
  }

}

/// emp_id : "58"
/// emp_name : "Jignesh"
/// emp_phone : "8529638522"
/// emp_email : "jignesh1@coronation.in"
/// profile : "https://salesapp.coronation.in/assets/upload/profile/1675170997-circle.png"
/// designation : [{"designation_id":"2","designation_name":""},{"designation_id":"5","designation_name":"HR and Admin Head"},{"designation_id":"6","designation_name":"Sales Head"}]
/// parent : "10"
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
      List<Designation>? designation, 
      String? parent, 
      String? incentive, 
      String? outstanding, 
      String? totalSales, 
      String? totalCustomers,}){
    _empId = empId;
    _empName = empName;
    _empPhone = empPhone;
    _empEmail = empEmail;
    _profile = profile;
    _designation = designation;
    _parent = parent;
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
    if (json['designation'] != null) {
      _designation = [];
      json['designation'].forEach((v) {
        _designation?.add(Designation.fromJson(v));
      });
    }
    _parent = json['parent'];
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
  List<Designation>? _designation;
  String? _parent;
  String? _incentive;
  String? _outstanding;
  String? _totalSales;
  String? _totalCustomers;
EmployeeDetails copyWith({  String? empId,
  String? empName,
  String? empPhone,
  String? empEmail,
  String? profile,
  List<Designation>? designation,
  String? parent,
  String? incentive,
  String? outstanding,
  String? totalSales,
  String? totalCustomers,
}) => EmployeeDetails(  empId: empId ?? _empId,
  empName: empName ?? _empName,
  empPhone: empPhone ?? _empPhone,
  empEmail: empEmail ?? _empEmail,
  profile: profile ?? _profile,
  designation: designation ?? _designation,
  parent: parent ?? _parent,
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
  List<Designation>? get designation => _designation;
  String? get parent => _parent;
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
    if (_designation != null) {
      map['designation'] = _designation?.map((v) => v.toJson()).toList();
    }
    map['parent'] = _parent;
    map['incentive'] = _incentive;
    map['outstanding'] = _outstanding;
    map['total_sales'] = _totalSales;
    map['total_customers'] = _totalCustomers;
    return map;
  }

}

/// designation_id : "2"
/// designation_name : ""

Designation designationFromJson(String str) => Designation.fromJson(json.decode(str));
String designationToJson(Designation data) => json.encode(data.toJson());
class Designation {
  Designation({
      String? designationId, 
      String? designationName,}){
    _designationId = designationId;
    _designationName = designationName;
}

  Designation.fromJson(dynamic json) {
    _designationId = json['designation_id'];
    _designationName = json['designation_name'];
  }
  String? _designationId;
  String? _designationName;
Designation copyWith({  String? designationId,
  String? designationName,
}) => Designation(  designationId: designationId ?? _designationId,
  designationName: designationName ?? _designationName,
);
  String? get designationId => _designationId;
  String? get designationName => _designationName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['designation_id'] = _designationId;
    map['designation_name'] = _designationName;
    return map;
  }

}