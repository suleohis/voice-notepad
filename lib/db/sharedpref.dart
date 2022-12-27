import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{

  static String sharedPreferenceFirstTime='FIRSTTIME';
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';
  static String sharedPreferenceMaxWaitTime = 'MAXWAITTIME';
  static String sharedPreferenceMaxTime = 'MAXTIME';
  static String sharedPreferenceListType = 'ListType';
  static String sharedPreferenceLang = 'Language';
  static String sharedPreferenceTransLang = 'TransLanguage';

  //saving data to SharedPreference
  static Future<bool> saveFirstTimeSharedPreference(bool firstTime)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceFirstTime, firstTime);
  }

  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String? userName)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName!);
  }

  static Future<bool> saveUserEmailSharedPreference(String? userEmail)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey,userEmail!);
  }
  static Future<bool> saveUserLangSharedPreference(String? lang)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceLang,lang!);
  }

  static Future<bool> saveUserTransLangSharedPreference(String? transLang)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceTransLang,transLang!);
  }
  static Future<bool> saveMaxWaitTimeSharedPreference(int? maxWaitTime)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(sharedPreferenceMaxWaitTime,maxWaitTime!);
  }
  static Future<bool> saveMaxTimeSharedPreference(int? maxTime)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(sharedPreferenceMaxTime,maxTime!);
  }
  static Future<bool> saveListTypeSharedPreference(bool listType)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceListType, listType);
  }
  //getting data from SharedPreference
  static Future<bool?> getFirstTimeSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getBool(sharedPreferenceFirstTime);
  }
  static Future<bool?> getUserLoggedInSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getBool(sharedPreferenceUserLoggedInKey);
  }
  static Future<String?> getUserNameSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserNameKey);
  }
  static Future<String?> getUserLangSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceLang);
  }
  static Future<String?> getUserTransLangSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceTransLang);
  }
  static Future<String?> getUserEmailSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<int?> getMaxWaitTimeSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getInt(sharedPreferenceMaxWaitTime);
  }
  static Future<int?> getMaxTimeSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getInt(sharedPreferenceMaxTime);
  }
  static Future<bool?> getListTypeSharedPreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getBool(sharedPreferenceListType);
  }
}