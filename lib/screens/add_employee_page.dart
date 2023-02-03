import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salesapp/Model/common_response_model.dart';

import '../Model/designation_response_model.dart';
import '../Model/employee_list_response_model.dart';
import '../constant/color.dart';
import '../network/api_end_point.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';

class AddEmployeePage extends StatefulWidget {
  final EmployeeList getSet;
  final  bool isFromList;
  const AddEmployeePage(this.getSet, this.isFromList, {Key? key}) : super(key: key);

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends BaseState<AddEmployeePage> {
  bool _isLoading = false;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  TextEditingController _parentController = TextEditingController();
  var listDesignation = List<DesignationList>.empty(growable: true);
  List<Designations> selectedDesignationList = [];
  String _designationFilteredId = "";
  String _designationSelectedName = "";

  var listEmployee = List<EmployeeList>.empty(growable: true);
  var strSelectedEmployeeId = '';
  String strSelectedEmployeeName = "";

  FocusNode inputNode = FocusNode();
  bool _passwordVisible = true;
  final TextEditingController textControllerForEmployee = TextEditingController();
  List<EmployeeList> _tempListOfEmployee = [];

  @override
  void initState() {
    super.initState();

    if (isInternetConnected) {
      _makeCallDesignationData();
    }else {
      noInterNet(context);
    }

    if ((widget as AddEmployeePage).isFromList == true) {
      _nameController.text = checkValidString((widget as AddEmployeePage).getSet.empName).toString();
      _emailController.text = checkValidString((widget as AddEmployeePage).getSet.empEmail).toString();
      _phoneNumController.text = checkValidString((widget as AddEmployeePage).getSet.empPhone).toString();
      _pwController.text = checkValidString((widget as AddEmployeePage).getSet.empPassword).toString();

      strSelectedEmployeeId = checkValidString((widget as AddEmployeePage).getSet.empId).toString();
      strSelectedEmployeeName = checkValidString((widget as AddEmployeePage).getSet.empName).toString();
      _parentController.text = strSelectedEmployeeName;

      selectedDesignationList = (widget as AddEmployeePage).getSet.designations!;

      for (var j=0; j < selectedDesignationList.length; j++) {
        _designationFilteredId = ("$_designationFilteredId,${selectedDesignationList[j].designationsId}");
        _designationSelectedName = ("$_designationSelectedName,${selectedDesignationList[j].designationName}");
        _designationController.text = _designationSelectedName;
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      resizeToAvoidBottomInset: true,
      appBar:AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 55,
        automaticallyImplyLeading: false,
        title: const Text(""),
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
                      Container(
                        color: kBlue,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 22, top: 10, bottom: 15),
                        child: Text((widget as AddEmployeePage).isFromList ? "Update Employee" : "Add Employee",
                            style: const TextStyle(fontWeight: FontWeight.w700, color: white, fontSize: 20)),
                      ),
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
                          controller: _phoneNumController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Phone',
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
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: TextField(
                          onTap: () {
                            showDesignationActionDialog();
                          },
                          controller: _designationController,
                          readOnly: true,
                          cursorColor: black,
                          decoration: const InputDecoration(
                            labelText: 'Designation',
                            suffixIcon: Icon(Icons.keyboard_arrow_down_sharp, color: kGray, ),
                          ),
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top:20, left: 20, right: 20),
                        child: TextField(
                          onTap: () {
                            setState(() {
                              textControllerForEmployee.clear();
                              _tempListOfEmployee.clear();
                            });
                            showEmployeeListActionDialog();
                          },
                          cursorColor: black,
                          controller: _parentController,
                          readOnly: true,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: const InputDecoration(
                              labelText: 'Parent Id',
                              suffixIcon: Icon(Icons.keyboard_arrow_down_sharp, color: kGray,),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: TextField(
                          cursorColor: black,
                          controller: _pwController,
                          obscureText: _passwordVisible,
                          keyboardType: TextInputType.visiblePassword,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                          decoration: InputDecoration(
                              labelText: 'Password',
                              counterText: '',
                              prefixStyle: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 16),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                child: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: kGray,),
                              )),
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
                            String email = _emailController.text.toString();
                            String phone = _phoneNumController.text.toString();
                            String designation = _designationController.text.toString();
                            String parent = _parentController.text.toString();
                            String password = _pwController.text.toString();

                            if(name.trim().isEmpty) {
                              showSnackBar("Please enter a name", context);
                            }else if (email.trim().isEmpty) {
                              showSnackBar("Please enter a email", context);
                            }else if (!isValidEmail(email)) {
                              showSnackBar("Please enter valid email", context);
                            }else if(phone.isEmpty) {
                              showSnackBar('Please enter phone number',context);
                            }else if (phone.length != 10) {
                              showSnackBar('Please enter valid phone number',context);
                            }else if (designation.trim().isEmpty) {
                              showToast("Please select designation");
                            }else if (parent.trim().isEmpty) {
                              showToast("Please enter parent id");
                            }else if (password.trim().isEmpty) {
                              showToast("Please enter password");
                            }else if (password.length < 6) {
                              showToast("Please enter minimum 6 length password");
                            }else {
                              if ((widget as AddEmployeePage).isFromList == true) {
                                if(isInternetConnected) {
                                  _makeCallUpdateEmployee();
                                }else{
                                  noInterNet(context);
                                }
                              }else {
                                if(isInternetConnected) {
                                  _makeCallAddEmployee();
                                }else{
                                  noInterNet(context);
                                }
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
    widget is AddEmployeePage;
  }

  void showDesignationActionDialog() {
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
              height: MediaQuery.of(context).size.height * 0.6,
              child: (
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 50,
                            margin: const EdgeInsets.only(top: 10),
                            child: const Divider(color: kBlue, height: 2, thickness: 1.5,),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        child: const Text("Designations",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),
                        ),
                      ),
                      Expanded(child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: listDesignation.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if(listDesignation[index].isSelected ?? false) {
                                    listDesignation[index].isSelected = false;
                                  }else {
                                    listDesignation[index].isSelected = true;
                                  }
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                height: 40,
                                child: Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(left: 12, right: 10, top: 8, bottom: 8),
                                        child: listDesignation[index].isSelected ?? false == checkValidString(listDesignation[index].designationId)
                                            ? Image.asset("assets/images/check-box.png", height: 24, width: 24,)
                                            : Image.asset("assets/images/ic_checkbox_blue.png", height: 24, width: 24,)
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                                      alignment: Alignment.topLeft,
                                      child: Text(checkValidString(listDesignation[index].designationName),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                        style: TextStyle(fontWeight: FontWeight.w600,
                                            color: listDesignation[index].isSelected ?? false == checkValidString(listDesignation[index].designationId) ? kBlue : black,
                                            fontSize: 15.0),),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
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
                            onPressed: () async {
                              _designationFilteredId = "";
                              _designationSelectedName = "";

                              for (var i = 0; i < listDesignation.length; i++) {
                                if (listDesignation[i].isSelected ?? false) {
                                  if (_designationFilteredId.isEmpty) {
                                    _designationFilteredId = listDesignation[i].designationId ?? "";
                                    _designationSelectedName = listDesignation[i].designationName ?? "";
                                  } else {
                                    _designationFilteredId = ("$_designationFilteredId,${listDesignation[i].designationId}");
                                    _designationSelectedName = ("$_designationSelectedName,${listDesignation[i].designationName}");
                                  }
                                }
                              }
                              _designationController.text = _designationSelectedName;
                              Navigator.pop(context);
                            } ,
                            onLongPress: () => {}, //set both onPressed and onLongPressed to null to see the disabled properties
                            child: const Text("Apply", textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w600),
                            )
                        ),
                      ),
                    ],
                  )
              ),
            );
          },
        );
      },
    );
  }

  void showEmployeeListActionDialog() {

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
              height:  MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        margin: const EdgeInsets.only(top: 10),
                        child: const Divider(color: kBlue, height: 2, thickness: 1.5,),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    child: const Text("Employee",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),
                    ),
                  ),
                  Card(
                      margin: const EdgeInsets.only(left: 15, right: 15, top: 6, bottom: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kTextFieldCornerRadius), // if you need this
                      ),
                      elevation: 0,
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          textAlign: TextAlign.start,
                          controller: textControllerForEmployee,
                          cursorColor: black,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search...",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: kTextColor, width: 0),
                              borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: kTextColor, width: 0),
                              borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                            ),
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300,
                              color: black,
                            ),
                          ),
                          enabled: true,
                          onChanged: (text) {
                            if(text.isNotEmpty) {
                              setState(() {
                                _tempListOfEmployee = _buildSearchListForEmployee(text);
                              });
                            } else {
                              setState(() {
                                textControllerForEmployee.clear();
                                _tempListOfEmployee.clear();
                              });
                            }
                          },
                        ),
                      )
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount:(_tempListOfEmployee.isNotEmpty) ? _tempListOfEmployee.length : listEmployee.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if(_tempListOfEmployee != null && _tempListOfEmployee.length > 0) {
                                setState(() {
                                  _parentController.text = _tempListOfEmployee[index].empName.toString();
                                  strSelectedEmployeeId = _tempListOfEmployee[index].empId.toString();
                                });
                              } else {
                                setState(() {
                                  _parentController.text = listEmployee[index].empName.toString();
                                  strSelectedEmployeeId = listEmployee[index].empId.toString();
                                });
                              }
                            },
                            child: (_tempListOfEmployee.isNotEmpty)
                                ? _showBottomSheetForEmployeeList(
                                index, _tempListOfEmployee)
                                : _showBottomSheetForEmployeeList(
                                index, listEmployee),
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
                          Navigator.pop(context);
                          for(var i = 0; i < listEmployee.length; i++) {
                            if(listEmployee[i].empId == strSelectedEmployeeId) {
                              _parentController.text = listEmployee[i].empName.toString();
                            }
                          }
                        } , //set both onPressed and onLongPressed to null to see the disabled properties
                        onLongPress: () => {}, //set both onPressed and onLongPressed to null to see the disabled properties
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

  List<EmployeeList> _buildSearchListForEmployee(String userSearchTerm) {
    List<EmployeeList> _searchList = [];
    for (int i = 0; i < listEmployee.length; i++) {
      String name = listEmployee[i].empName.toString().trim();
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(listEmployee[i]);
      }
    }
    return _searchList;
  }

  Widget _showBottomSheetForEmployeeList(int index, List<EmployeeList> listData) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(left: 8),
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            height: 40,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 12, right: 10, top: 8, bottom: 8),
                    child: strSelectedEmployeeId == checkValidString(listData[index].empId)
                        ? const Icon(Icons.radio_button_checked, color: kBlue, size: 22)
                        : const Icon(Icons.radio_button_off, color: kBlue, size: 22)
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                  alignment: Alignment.centerLeft,
                  child: Text(checkValidString(listData[index].empName),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.w600,
                        color: strSelectedEmployeeId == checkValidString(listData[index].empId.toString()) ? kBlue : black,
                        fontSize: 15.0),),
                ),
              ],
            )
        ),

       /* Container(
          padding: const EdgeInsets.only(left: 20.0,right: 20,top: 8,bottom: 8),
          alignment: Alignment.centerLeft,
          child: listData[index].empName == _parentController.text.toString() ? Text(listData[index].empName.toString(),
            style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: kBlue),)
              : Text(listData[index].empName.toString(),
            style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black),),
        ),
        const Divider(thickness: 0.5,color: kLightestGray,endIndent: 16,indent: 16,)*/
      ],
    );
  }

  void _makeCallDesignationData() async {

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + manageDesignation);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> designationData = jsonDecode(body);
    var dataResponse = DesignationResponseModel.fromJson(designationData);

    if (statusCode == 200 && dataResponse.success == 1) {
      setState(() {
        _isLoading = false;
      });

      var designationListResponse = DesignationResponseModel.fromJson(designationData);
      listDesignation = designationListResponse.designationList!;

      for (var i = 0; i < listDesignation.length; i++) {
        for (var j=0; j < selectedDesignationList.length; j++) {
            if (listDesignation[i].designationId == selectedDesignationList[j].designationsId) {
              setState(() {
                listDesignation[i].isSelected = true;
              });
            }
        }
      }

    }else {
      setState(() {
        _isLoading = false;
      });

    }
    _getEmployeeListData();
  }

  void _getEmployeeListData() async {

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + employeeList);
    Map<String, String> jsonBody = {
      'from_app': FROM_APP,
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> order = jsonDecode(body);
    var dataResponse = EmployeeListResponseModel.fromJson(order);

    if (statusCode == 200 && dataResponse.success == 1) {
      var employeeListResponse = EmployeeListResponseModel.fromJson(order);
      if (employeeListResponse.employeeList != null) {
        listEmployee = employeeListResponse.employeeList!;
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

  _makeCallAddEmployee() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + addEmployee);

    Map<String, String> jsonBody = {
      'emp_name': _nameController.value.text.trim(),
      'emp_email': _emailController.value.text.trim(),
      'emp_phone': _phoneNumController.value.text.trim(),
      'emp_password': _pwController.value.text.trim(),
      'designation_id': _designationFilteredId,
      'parent_id': strSelectedEmployeeId,
      'from_app' : FROM_APP,
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, "success");
      tabNavigationReload();

    }else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _makeCallUpdateEmployee() async {
    setState(() {
      _isLoading = true;
    });
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(BASE_URL + addEmployee);

    Map<String, String> jsonBody = {
      'emp_name': _nameController.value.text.trim(),
      'emp_email': _emailController.value.text.trim(),
      'emp_phone': _phoneNumController.value.text.trim(),
      'emp_password': _pwController.value.text.trim(),
      'designation_id': _designationFilteredId,
      'parent_id': strSelectedEmployeeId,
      'from_app' : FROM_APP,
      'emp_id' : (widget as AddEmployeePage).getSet.empId.toString()
    };

    final response = await http.post(url, body: jsonBody);
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      showSnackBar(dataResponse.message, context);

      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context, "success");
      tabNavigationReload();

    }else {
      showSnackBar(dataResponse.message, context);
      setState(() {
        _isLoading = false;
      });
    }

  }
}