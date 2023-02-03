import 'package:salesapp/utils/session_manager_methods.dart';

class SessionManager {
/*
      "emp_id": "58",
        "emp_name": "Jignesh",
        "emp_phone": "8529638522",
        "emp_email": "jignesh1@coronation.in",
        "profile": "https://salesapp.coronation.in/assets/upload/profile/1675170997-circle.png",
        "designation": [
            {
                "designation_id": "2",
                "designation_name": ""
            },
        ],
        "parent": "10",
        "incentive": "0",
        "outstanding": "0",
        "total_sales": "0",
        "total_customers": "0"
*/

  final String isLoggedIn = "isLoggedIn";
  final String empId = "emp_id";
  final String empName = "emp_name";
  final String empPhone = "emp_phone";
  final String empEmail = "emp_email";
  final String profile = "profile";
  final String parent = "parent";


  //set data into shared preferences...
  Future createLoginSession(String apiEmpId, String apiEmpName, String apiEmpPhone, String apiEmail, String apiProfile) async {
    await SessionManagerMethods.setBool(isLoggedIn, true);
    await SessionManagerMethods.setString(empId, apiEmpId);
    await SessionManagerMethods.setString(empName, apiEmpName);
    await SessionManagerMethods.setString(empPhone, apiEmpPhone);
    await SessionManagerMethods.setString(empEmail, apiEmail);
    await SessionManagerMethods.setString(profile, apiProfile);
  }

  Future<void> setIsLoggedIn(bool apiIsLoggedIn)
  async {
    await SessionManagerMethods.setBool(isLoggedIn, apiIsLoggedIn);
  }

  bool? checkIsLoggedIn() {
    return SessionManagerMethods.getBool(isLoggedIn);
  }

  Future<void> setEmpId(String apiEmpId)
  async {
    // print("setUserId --->$empId");
    await SessionManagerMethods.setString(empId, apiEmpId);
  }

  String? getEmpId() {
    return SessionManagerMethods.getString(empId);
  }

  Future<void> setEmpName(String apiEmpName)
  async {
    await SessionManagerMethods.setString(empName, apiEmpName);
  }

  String? getName() {
    return SessionManagerMethods.getString(empName);
  }

  Future<void> setEmail(String apiEmail)
  async {
    await SessionManagerMethods.setString(empEmail, apiEmail);
  }

  String? getEmail() {
    return SessionManagerMethods.getString(empEmail);
  }

  Future<void> setEmpPhone(String apiEmpPhone)
  async {
    await SessionManagerMethods.setString(empPhone, apiEmpPhone);
  }

  String? getEmpPhone() {
    return SessionManagerMethods.getString(empPhone);
  }

  Future<void> setProfilePic(String apiProfilePic)
  async {
    await SessionManagerMethods.setString(profile, apiProfilePic);
  }

  String? getProfilePic() {
    return SessionManagerMethods.getString(profile);
  }

  Future<void> setParentId(String apiParentId)
  async {
    await SessionManagerMethods.setString(parent, apiParentId);
  }

  String? getParentId() {
    return SessionManagerMethods.getString(parent);
  }

}