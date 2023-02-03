import 'dart:convert';
/// success : 1
/// designationList : [{"designation_id":"26","designation_name":"hrhr","status":"Y","timestamp":"1660645907","parent":"5","path":"4,5"},{"designation_id":"25","designation_name":"Chef Hot Section","status":"Y","timestamp":"1652879197","parent":"","path":""}]

DesignationsResponseModel designationsResponseModelFromJson(String str) => DesignationsResponseModel.fromJson(json.decode(str));
String designationsResponseModelToJson(DesignationsResponseModel data) => json.encode(data.toJson());
class DesignationsResponseModel {
  DesignationsResponseModel({
      num? success, 
      List<DesignationList>? designationList,}){
    _success = success;
    _designationList = designationList;
}

  DesignationsResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['designationList'] != null) {
      _designationList = [];
      json['designationList'].forEach((v) {
        _designationList?.add(DesignationList.fromJson(v));
      });
    }
  }
  num? _success;
  List<DesignationList>? _designationList;
DesignationsResponseModel copyWith({  num? success,
  List<DesignationList>? designationList,
}) => DesignationsResponseModel(  success: success ?? _success,
  designationList: designationList ?? _designationList,
);
  num? get success => _success;
  List<DesignationList>? get designationList => _designationList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_designationList != null) {
      map['designationList'] = _designationList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// designation_id : "26"
/// designation_name : "hrhr"
/// status : "Y"
/// timestamp : "1660645907"
/// parent : "5"
/// path : "4,5"

DesignationList designationListFromJson(String str) => DesignationList.fromJson(json.decode(str));
String designationListToJson(DesignationList data) => json.encode(data.toJson());
class DesignationList {
  DesignationList({
      String? designationId, 
      String? designationName, 
      String? status, 
      String? timestamp, 
      String? parent, 
      String? path,}){
    _designationId = designationId;
    _designationName = designationName;
    _status = status;
    _timestamp = timestamp;
    _parent = parent;
    _path = path;
}

  DesignationList.fromJson(dynamic json) {
    _designationId = json['designation_id'];
    _designationName = json['designation_name'];
    _status = json['status'];
    _timestamp = json['timestamp'];
    _parent = json['parent'];
    _path = json['path'];
  }
  String? _designationId;
  String? _designationName;
  String? _status;
  String? _timestamp;
  String? _parent;
  String? _path;
DesignationList copyWith({  String? designationId,
  String? designationName,
  String? status,
  String? timestamp,
  String? parent,
  String? path,
}) => DesignationList(  designationId: designationId ?? _designationId,
  designationName: designationName ?? _designationName,
  status: status ?? _status,
  timestamp: timestamp ?? _timestamp,
  parent: parent ?? _parent,
  path: path ?? _path,
);
  String? get designationId => _designationId;
  String? get designationName => _designationName;
  String? get status => _status;
  String? get timestamp => _timestamp;
  String? get parent => _parent;
  String? get path => _path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['designation_id'] = _designationId;
    map['designation_name'] = _designationName;
    map['status'] = _status;
    map['timestamp'] = _timestamp;
    map['parent'] = _parent;
    map['path'] = _path;
    return map;
  }

}