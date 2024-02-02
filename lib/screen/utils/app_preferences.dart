import 'dart:async';

import 'package:doct_app/screen/utils/global.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  //------------------------------------------------------------- Preference Constants ------------------------------------------------------------

  // Constants for Preference-Value's data-type
  static const String PREF_TYPE_BOOL = "BOOL";
  static const String PREF_TYPE_INTEGER = "INTEGER";
  static const String PREF_TYPE_DOUBLE = "DOUBLE";
  static const String PREF_TYPE_STRING = "STRING";

  // Constants for Preference-Name
  static const String PREF_USER_EMAIL = "USER_EMAIL";
  static const String PREF_USER_ID = "USER_ID";
  static const String PREF_USER_PHONE = "USER_PHONE";
  static const String PREF_USER_LOGIN = "USER_LOGIN";
  static const String PREF_USER_NAME = "USER_NAME";
  static const String PREF_USER_IMAGE = "USER_IMAGE";

  //-------------------------------------------------------------------- Variables -------------------------------------------------------------------
  // Future variable to check SharedPreference Instance is ready
  // This is actually a hack. As constructor is not allowed to have 'async' we cant 'await' for future value
  // SharedPreference.getInstance() returns Future<SharedPreference> object and we want to assign its value to our private _preference variable
  // In case if we don't 'await' for SharedPreference.getInstance() method, and in mean time if we access preferences using _preference variable we will get
  // NullPointerException for _preference variable, as it isn't yet initialized.
  // We need to 'await' _isPreferenceReady value for only once when preferences are first time requested in application lifecycle because in further
  // future requests, preference instance is already ready as we are using Singleton-Instance.
  Future? _isPreferenceInstanceReady;

  // Private variable for SharedPreferences
  late SharedPreferences _preferences;

  //-------------------------------------------------------------------- Singleton ----------------------------------------------------------------------
  // Final static instance of class initialized by private constructor
  static final AppPreferences _instance = AppPreferences._internal();

  // Factory Constructor
  factory AppPreferences() => _instance;

  /// AppPreference Private Internal Constructor -> AppPreference
  /// @param->_
  /// @usage-> Initialize SharedPreference object and notify when operation is complete to future variable.
  AppPreferences._internal() {
    _isPreferenceInstanceReady = SharedPreferences.getInstance()
        .then((preferences) => _preferences = preferences);
  }

  //------------------------------------------------------- Getter Methods -----------------------------------------------------------
  // GETTER for isPreferenceReady future
  Future? get isPreferenceReady => _isPreferenceInstanceReady;

  //--------------------------------------------------- Public Preference Methods -------------------------------------------------------------
  //
  void setUserEmail({required String email}) => _setPreference(
      prefName: PREF_USER_EMAIL, prefType: PREF_TYPE_STRING, prefValue: email);

  void setUserPhone({required String phone}) => _setPreference(
      prefName: PREF_USER_PHONE, prefType: PREF_TYPE_STRING, prefValue: phone);

  void setUserId({required String userid}) => _setPreference(
      prefName: PREF_USER_ID, prefType: PREF_TYPE_STRING, prefValue: userid);

  void setUserLogin({required bool isLogin}) => _setPreference(
      prefName: PREF_USER_LOGIN, prefType: PREF_TYPE_BOOL, prefValue: isLogin);

  void setUserName({required String name}) => _setPreference(
      prefName: PREF_USER_NAME, prefType: PREF_TYPE_STRING, prefValue: name);

  void setUserImage({required String url}) => _setPreference(
      prefName: PREF_USER_IMAGE, prefType: PREF_TYPE_STRING, prefValue: url);

  //Example for get preference value

  Future<String> getUserId() async =>
      await _getPreference(prefName: PREF_USER_ID) ?? '';

  Future<String> getUserEmail() async =>
      await _getPreference(prefName: PREF_USER_EMAIL) ?? '';

  Future<String> getUserPhone() async =>
      await _getPreference(prefName: PREF_USER_PHONE) ?? '';

  Future<String> getUserImage() async =>
      await _getPreference(prefName: PREF_USER_IMAGE) ?? '';

  Future<bool> getUserLogin() async =>
      await _getPreference(prefName: PREF_USER_LOGIN) ?? false;

  Future<String> getUserName() async =>
      await _getPreference(prefName: PREF_USER_NAME) ?? 'Guest !';

  // Check value for NULL. If NULL provide default value as FALSE.

  //--------------------------------------------------- Private Preference Methods ----------------------------------------------------
  /// Set Preference Method -> void
  /// @param -> @required prefName -> String
  ///        -> @required prefValue -> dynamic
  ///        -> @required prefType -> String
  /// @usage -> This is a generalized method to set preferences with required Preference-Name(Key) with Preference-Value(Value) and Preference-Value's data-type.
  void _setPreference(
      {required String prefName,
      required dynamic prefValue,
      required String prefType}) {
    // Make switch for Preference Type i.e. Preference-Value's data-type
    switch (prefType) {
      // prefType is bool
      case PREF_TYPE_BOOL:
        {
          _preferences!.setBool(prefName, prefValue);
          break;
        }
      // prefType is int
      case PREF_TYPE_INTEGER:
        {
          _preferences!.setInt(prefName, prefValue);
          break;
        }
      // prefType is double
      case PREF_TYPE_DOUBLE:
        {
          _preferences!.setDouble(prefName, prefValue);
          break;
        }
      // prefType is String
      case PREF_TYPE_STRING:
        {
          _preferences!.setString(prefName, prefValue.toString());
          break;
        }
    }
  }

  /// Get Preference Method -> Future<dynamic>
  /// @param -> @required prefName -> String
  /// @usage -> Returns Preference-Value for given Preference-Name
  Future<dynamic> _getPreference({@required prefName}) async =>
      _preferences!.get(prefName);

  Future<dynamic> clearPreference() async => _preferences!.clear();
}
