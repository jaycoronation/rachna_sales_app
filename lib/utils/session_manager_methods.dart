import 'package:shared_preferences/shared_preferences.dart';

class SessionManagerMethods {

  static SharedPreferences? _prefsOneTime;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsOneTime = await SharedPreferences.getInstance();
    return _prefsOneTime;
  }

  //sets
  static Future<bool?> setBool(String key, bool value) async =>
      await _prefsOneTime?.setBool(key, value);

  static Future<bool?> setDouble(String key, double value) async =>
      await _prefsOneTime?.setDouble(key, value);

  static Future<bool?> setInt(String key, int value) async =>
      await _prefsOneTime?.setInt(key, value);

  static Future<bool?> setString(String key, String value) async =>
      await _prefsOneTime?.setString(key, value);

  static Future<bool?> setStringList(String key, List<String> value) async =>
      await _prefsOneTime?.setStringList(key, value);

  //gets
  static bool? getBool(String key) => _prefsOneTime?.getBool(key) ?? false;

  static double? getDouble(String key) => _prefsOneTime?.getDouble(key) ?? 0.0;

  static int? getInt(String key) => _prefsOneTime?.getInt(key) ?? 0;

  static String? getString(String key) => _prefsOneTime?.getString(key) ?? "" ;

  static List<String>? getStringList(String key) => _prefsOneTime?.getStringList(key) ?? [];

  //deletes..
  static Future<bool?> remove(String key) async => await _prefsOneTime?.remove(key);

  static Future<bool?> clear() async => await _prefsOneTime?.clear();

  // Total Orders....
  late final String totalOrders = "total_order";

  Future<void> setTotalOrders(String apiTotalOrders)
  async {
    await SessionManagerMethods.setString(totalOrders, apiTotalOrders);
  }

  String? getTotalOrders() {
    return SessionManagerMethods.getString(totalOrders);
  }


  // Total Overdues....
  late final String overdues = "overdues";

  Future<void> setOverdues(String apiOverdues)
  async {
    await SessionManagerMethods.setString(overdues, apiOverdues);
  }

  String? getOverdues() {
    return SessionManagerMethods.getString(overdues);
  }

  //======================
  final String isIntro = "is_intro";

  Future<void> setIsIntro(bool apiIsIntro)
  async {
    await SessionManagerMethods.setBool(isIntro, apiIsIntro);
  }

  bool? checkIsIntro() {
    return SessionManagerMethods.getBool(isIntro);
  }

}