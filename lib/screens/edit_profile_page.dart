import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/designation_response_model.dart';
import 'package:salesapp/Model/order_list_response_model.dart';
import 'package:salesapp/model/profile_detail_response_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/common_response_model.dart';
import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends BaseState<EditProfilePage> {
  bool _isLoading = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  FocusNode inputNode = FocusNode();

  List<DesignationList> listDesignation = List<DesignationList>.empty();
  List<DesignationList> listFilterDesignation = [];
  List<Designation> listSelectedDesignation = [];

  String _designationFilteredId = "";
  String _designationFilteredSelectedName = "";

  DesignationResponseModel designationResponseModel = DesignationResponseModel();
  late EmployeeDetails userDataGetSet;
  // var strSelectedId = '';
  // var strSelectedDesignationId = '';

  var pickImgPath = "";
  var passPickImgPath = "";

  ProfileDetailResponseModel profileDetailsResponseModel = ProfileDetailResponseModel();

  @override
  void initState() {

    if (isInternetConnected) {
      _profileDetailRequest();
    } else {
      noInterNet(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 55,
        automaticallyImplyLeading: false,
        title: const Text("Personal Detail",
            style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.w600)),
        leading: GestureDetector(
            onTap:() {
              Navigator.pop(context);
            },
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                  color: kBlue
              ),
              alignment: Alignment.center,
              child: Image.asset('assets/images/ic_back_arrow.png', color: white, height: 22, width: 22),
            )
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: kBlue,
      ),
      body: _isLoading ? const LoadingWidget()
          : LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                    /*  Container(
                        color: kBlue,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 22, top: 10, bottom: 15),
                        child: const Text("Personal Detail",
                            style: TextStyle(fontWeight: FontWeight.w700, color: white, fontSize: 20)),
                      ),*/
                      cardProfileImage(),
                      Container(
                        margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              prefixText: '+91 ',
                              counterText: '',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _designationController,
                          readOnly: true,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Select Designation',
                              prefixStyle: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16)
                          ),
                          onTap: () {
                            showDesignationActionDialog();
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 10, left: 20, right: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kLightGradient, kDarkGradient],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            String name = _nameController.text.toString();
                            String phone = _phoneController.text.toString();
                            String email = _emailController.text.toString();
                            String designation = _designationController.text.toString();

                            if (name.trim().isEmpty) {
                              showSnackBar("Please enter a name", context);
                            } else if (phone.trim().isEmpty) {
                              showSnackBar("Please enter a phone", context);
                            } else if (phone.length != 10) {
                              showSnackBar("Please enter valid phone", context);
                            } else if(email.isEmpty) {
                              showSnackBar('Please enter email',context);
                            } else if(!isValidEmail(email)) {
                              showSnackBar('Please enter valid email',context);
                            } else if (designation.trim().isEmpty) {
                              showToast("Please enter designation");
                            } else {
                              if(isInternetConnected) {
                                _makeSaveProfileRequest();
                              }else{
                                noInterNet(context);
                              }
                            }
                          },
                          child: const Text("Submit",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  @override
  void castStatefulWidget() {
    // TODO: implement castStatefulWidget
    widget is EditProfilePage;
  }

  void showDesignationActionDialog() {

    for(var i= 0; i < listDesignation.length; i++) {
      listDesignation[i].isSelected = false;
    }

    for (var i=0; i < listSelectedDesignation.length; i++) {
      for (var n=0; n < listDesignation.length; n++) {
        if(listSelectedDesignation[i].designationId == listDesignation[n].designationId) {
          // print(listSelectedDesignation[i].designationId.toString() + "==" +listDesignation[n].designationId.toString());
          listDesignation[n].isSelected = true;
        }
      }
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        padding: const EdgeInsets.only(top: 10),
                        child: const Divider(color: kBlue, height: 2, thickness: 1.5,),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 14, left: 16),
                    child: const Text("Designation",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: listDesignation.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // strSelectedDesignationId = listDesignation[index].designationId.toString();

                                if (listDesignation[index].isSelected ?? false) {
                                  listDesignation[index].isSelected = false;
                                }else {
                                  listDesignation[index].isSelected = true;
                                }
                              });
                            },
                            child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                height: 40,
                                child:CheckboxListTile(
                                  title: Text(listDesignation[index].designationName.toString(),
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: black),
                                  ),
                                  checkColor: white,
                                  activeColor: kBlue,
                                  contentPadding: EdgeInsets.zero,
                                  value: listDesignation[index].isSelected,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      listDesignation[index].isSelected = value;
                                    });
                                  },
                                ),
                                /*Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(left: 12, right: 10, top: 8, bottom: 8),
                                        child: strSelectedDesignationId == listDesignation[index].designationId
                                            ? const Icon(Icons.radio_button_checked, color: kBlue, size: 22)
                                            : const Icon(Icons.radio_button_off, color: kBlue, size: 22)
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                                      alignment: Alignment.topLeft,
                                      child: Text(checkValidString(listDesignation[index].designationName),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                        style: TextStyle(fontWeight: FontWeight.w600,
                                            color:strSelectedDesignationId == listDesignation[index].designationId ? kBlue : black,
                                            fontSize: 15.0),),
                                    ),
                                  ],
                                )
*/
                            ),
                          );
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kBlue,
                          onPrimary: kBlue,
                          elevation: 0.0,
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          side: const BorderSide(color: kBlue, width: 1.0, style: BorderStyle.solid),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kButtonCornerRadius)),
                          tapTargetSize: MaterialTapTargetSize.padded,
                          animationDuration: const Duration(milliseconds: 100),
                          enableFeedback: true,
                          alignment: Alignment.center,
                        ),
                        onPressed:() async {
                            _designationFilteredId = "";
                            _designationFilteredSelectedName = "";

                          for (var i = 0; i < listDesignation.length; i++) {
                            if (listDesignation[i].isSelected ?? false) {
                              if (_designationFilteredId.isEmpty) {
                                _designationFilteredId = listDesignation[i].designationId ?? "";
                                _designationFilteredSelectedName = listDesignation[i].designationName ?? "";

                              }else {
                                _designationFilteredId = ("$_designationFilteredId,${listDesignation[i].designationId}");
                                _designationFilteredSelectedName = ("$_designationFilteredSelectedName,${listDesignation[i].designationName}");

                              }
                            }
                          }
                          _designationController.text = _designationFilteredSelectedName;

                          Navigator.pop(context);
                       /*   for(var i = 0; i < listDesignation.length; i++) {
                            if(listDesignation[i].businessTypeId == strSelectedBusinessId) {
                              _businessTypeController.text = listDesignation[i].businessType.toString();
                            }
                          }*/

                        },
                        onLongPress: () => {},
                        child: const Text("Apply", textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w600),
                        )
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget cardProfileImage() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              showFilePickerActionDialog();
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape:const CircleBorder(
                side: BorderSide(
                  color: kBlue,//Colors.grey.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Container(
                color: Colors.white,
                width: 120,
                height: 120,
                child: pickImgPath.isNotEmpty ? Image.file(File(pickImgPath), fit: BoxFit.cover,) : sessionManager.getProfilePic().toString().isNotEmpty ?
                FadeInImage.assetNetwork(
                  image: sessionManager.getProfilePic().toString(),
                  fit: BoxFit.cover,
                  placeholder: 'assets/images/img_user_placeholder.png',
                ) :
                Image.asset('assets/images/img_user_placeholder.png', fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: kLightestPurple),
              height: 30.0,
              width: 30.0,
              child:Center(
                child: IconButton(
                  icon: Image.asset("assets/images/ic_add_photo.png", width: 30, height: 30,),
                  onPressed: () {
                    showFilePickerActionDialog();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showFilePickerActionDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      elevation: 5,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(height: 2, width : 40, color: kBlue, margin: const EdgeInsets.only(bottom:12)),
                    const Text("Select Image From?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: black, fontWeight: FontWeight.bold, fontSize: 16),),
                    Container(height: 12),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        pickImageFromCamera();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18,right: 18,top: 15,bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset('assets/images/ic_camera.png', height: 26, width: 26),
                            Container(width: 15),
                            const Text("Camera",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      color: kLightestGray,
                      height: 1,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        pickImageFromGallery();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 18,right: 18,top: 15,bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset('assets/images/ic_gallery.png', height: 26, width: 26),
                            Container(width: 15),
                            const Text("Gallery", textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 12)
                  ],
                )
            )
          ],
        );
      },
    );
  }

  Future<void> _cropImage(filePath) async {
    print("filePath====>$filePath");
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath
    );
    if (croppedImage != null) {
      pickImgPath = croppedImage.path;
      print("_pickImage picImgPath ====>$pickImgPath");

      setState(() {
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      var pickedfiles = await ImagePicker().pickImage(source: ImageSource.camera);
      if(pickedfiles != null){
        final filePath = pickedfiles.path;
        _cropImage(filePath);
        setState(() {

        });
      }else{
        print("No image is selected.");
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      var pickedfiles = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality:50);
      if(pickedfiles != null){
        final filePath = pickedfiles.path;
        _cropImage(filePath);
        setState(() {
        });
      }else{
        print("No image is selected.");
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  //API call function...
  _makeDesignationListRequest() async {
    // setState(() {
    //   _isLoading = true;
    // });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + designationList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = DesignationResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      designationResponseModel = dataResponse;

      listDesignation = [];
      listDesignation.addAll(dataResponse.designationList ?? []);

      for(var i= 0; i < listDesignation.length; i++) {
        listDesignation[i].isSelected = false;
      }

      setState(() {
        _isLoading = false;
      });

    }else {
      setState(() {
        _isLoading = false;
      });
    }

  }

  _profileDetailRequest() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + profileDetail);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
      'emp_id' : sessionManager.getEmpId().toString().trim()
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = ProfileDetailResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      setState(() {
        _isLoading = false;

        sessionManager.setEmpId(checkValidString(dataResponse.employeeDetails?.empId));
        sessionManager.setEmpName(checkValidString(dataResponse.employeeDetails?.empName));
        sessionManager.setEmpPhone(checkValidString(dataResponse.employeeDetails?.empPhone));
        sessionManager.setEmail(checkValidString(dataResponse.employeeDetails?.empEmail));
        sessionManager.setProfilePic(checkValidString(dataResponse.employeeDetails?.profile));

        _nameController.text = checkValidString(dataResponse.employeeDetails?.empName);
        _phoneController.text = checkValidString(dataResponse.employeeDetails?.empPhone);
        _emailController.text = checkValidString(dataResponse.employeeDetails?.empEmail);

        listSelectedDesignation = dataResponse.employeeDetails!.designation ?? [];

        for (var i = 0; i < dataResponse.employeeDetails!.designation!.length; i++) {
          if (_designationFilteredId.isNotEmpty) {
            _designationFilteredId = "$_designationFilteredId,${dataResponse.employeeDetails!.designation![i].designationId}";
            _designationFilteredSelectedName = "$_designationFilteredSelectedName,${dataResponse.employeeDetails!.designation![i].designationName}";
          }else {
            _designationFilteredId = checkValidString(dataResponse.employeeDetails?.designation![i].designationId);
            _designationFilteredSelectedName = checkValidString(dataResponse.employeeDetails?.designation![i].designationName);
          }
        }
        _designationController.text = _designationFilteredSelectedName;
      });

      setState(() {
        _isLoading = false;
      });

    }else {
      setState(() {
        _isLoading = false;
      });
    }

    _makeDesignationListRequest();

  }

  _makeSaveProfileRequest() async {
    if(isInternetConnected) {
      setState(() {
        _isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(BASE_URL + editProfile);
      var request = MultipartRequest("POST", url);

      request.fields['from_app'] = FROM_APP;
      request.fields['emp_id'] = sessionManager.getEmpId().toString().trim();
      request.fields['emp_name'] = _nameController.value.text.toString();
      request.fields['emp_phone'] = _phoneController.value.text.trim();
      request.fields['emp_email'] = _emailController.value.text.trim();
      request.fields['designation_id'] = _designationFilteredId;//strSelectedDesignationId;
      request.fields['parent_id'] = sessionManager.getParentId().toString().trim();

      if (pickImgPath != "") {
        request.files.add(await MultipartFile.fromPath('profile', pickImgPath));
      }

      var response = await request.send();

      final statusCode = response.statusCode;
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      Map<String, dynamic> user = jsonDecode(responseString);
      var apiData = CommonResponseModel.fromJson(user);

      if (statusCode == 200 && apiData.success == 1) {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(apiData.message, context);

        Navigator.pop(context, "success");

      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(apiData.message, context);
      }
    }else {
      noInterNet(context);
    }
  }

}