import 'dart:convert';
/// success : 1
/// designationList : [{"designation_id":"26","designation_name":"hrhr","status":"Y","timestamp":"1660645907","parent":"5","path":"4,5"}]

DesignationResponseModel designationResponseModelFromJson(String str) => DesignationResponseModel.fromJson(json.decode(str));
String designationResponseModelToJson(DesignationResponseModel data) => json.encode(data.toJson());
class DesignationResponseModel {
  DesignationResponseModel({
      num? success, 
      List<DesignationList>? designationList,}){
    _success = success;
    _designationList = designationList;
}

  DesignationResponseModel.fromJson(dynamic json) {
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
DesignationResponseModel copyWith({  num? success,
  List<DesignationList>? designationList,
}) => DesignationResponseModel(  success: success ?? _success,
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
      String? path,
    bool? isSelected,

  }){
    _designationId = designationId;
    _designationName = designationName;
    _status = status;
    _timestamp = timestamp;
    _parent = parent;
    _path = path;
    _isSelected = isSelected;

  }
  set isSelected(bool? value) {
    _isSelected = value;
  }

  DesignationList.fromJson(dynamic json) {
    _designationId = json['designation_id'];
    _designationName = json['designation_name'];
    _status = json['status'];
    _timestamp = json['timestamp'];
    _parent = json['parent'];
    _path = json['path'];
    _isSelected = json['isSelected'];

  }
  String? _designationId;
  String? _designationName;
  String? _status;
  String? _timestamp;
  String? _parent;
  String? _path;
  bool? _isSelected;

  DesignationList copyWith({  String? designationId,
  String? designationName,
  String? status,
  String? timestamp,
  String? parent,
  String? path,
    bool? isSelected,

  }) => DesignationList(  designationId: designationId ?? _designationId,
  designationName: designationName ?? _designationName,
  status: status ?? _status,
  timestamp: timestamp ?? _timestamp,
  parent: parent ?? _parent,
  path: path ?? _path,
      isSelected: isSelected ?? _isSelected

  );
  String? get designationId => _designationId;
  String? get designationName => _designationName;
  String? get status => _status;
  String? get timestamp => _timestamp;
  String? get parent => _parent;
  String? get path => _path;
  bool? get isSelected => _isSelected;

  set setDesignationId(String value)
  {
    _designationId = value;
  }

  set setDesignationName(String value)
  {
    _designationName = value;
  }

  set setSelected(bool value)
  {
    _isSelected = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['designation_id'] = _designationId;
    map['designation_name'] = _designationName;
    map['status'] = _status;
    map['timestamp'] = _timestamp;
    map['parent'] = _parent;
    map['path'] = _path;
    map['isSelected'] = _isSelected;
    return map;
  }

}