import 'dart:convert';
/// success : 1
/// message : ""
/// data : {"pdf_name":"1676626977_Transaction_Report_17_02_23.pdf","pdf_link":"https://salesapp.coronation.in/assets/transaction_pdf/1676626977_Transaction_Report_17_02_23.pdf"}

PdfDownloadResponseModel pdfDownloadResponseModelFromJson(String str) => PdfDownloadResponseModel.fromJson(json.decode(str));
String pdfDownloadResponseModelToJson(PdfDownloadResponseModel data) => json.encode(data.toJson());
class PdfDownloadResponseModel {
  PdfDownloadResponseModel({
      num? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  PdfDownloadResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  num? _success;
  String? _message;
  Data? _data;
PdfDownloadResponseModel copyWith({  num? success,
  String? message,
  Data? data,
}) => PdfDownloadResponseModel(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  num? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// pdf_name : "1676626977_Transaction_Report_17_02_23.pdf"
/// pdf_link : "https://salesapp.coronation.in/assets/transaction_pdf/1676626977_Transaction_Report_17_02_23.pdf"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? pdfName, 
      String? pdfLink,}){
    _pdfName = pdfName;
    _pdfLink = pdfLink;
}

  Data.fromJson(dynamic json) {
    _pdfName = json['pdf_name'];
    _pdfLink = json['pdf_link'];
  }
  String? _pdfName;
  String? _pdfLink;
Data copyWith({  String? pdfName,
  String? pdfLink,
}) => Data(  pdfName: pdfName ?? _pdfName,
  pdfLink: pdfLink ?? _pdfLink,
);
  String? get pdfName => _pdfName;
  String? get pdfLink => _pdfLink;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pdf_name'] = _pdfName;
    map['pdf_link'] = _pdfLink;
    return map;
  }

}