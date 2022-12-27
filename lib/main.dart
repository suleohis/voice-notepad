import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:voice_notepad/page/introducton_screen.dart';
import 'package:voice_notepad/page/notes_page.dart';
import 'package:voice_notepad/page/profilePage.dart';
import 'db/sharedpref.dart';
import 'function/uploadFuntion.dart';

Future main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(ChangeNotifierProvider.value(
      value:UploadNote(context: null, notes: []),
      child: const MyApp()));
}


class MyApp extends StatefulWidget{
  static const String title = 'Notes SQLite';

  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool test;
  bool? firstTime;
  checkFirstTime()async{
    if(await HelperFunction.getFirstTimeSharedPreference() ==null){
      HelperFunction.saveFirstTimeSharedPreference(true);
      firstTime = false;
      setState(() {});
    }else{
      firstTime =  await HelperFunction.getFirstTimeSharedPreference();
      setState(() {});
    }
    if(await HelperFunction.getUserLoggedInSharedPreference() == null){
      print(await HelperFunction.getUserLoggedInSharedPreference());
      HelperFunction.saveUserLoggedInSharedPreference(false);
      test = (await HelperFunction.getUserLoggedInSharedPreference())!;
    }else{
      test = (await HelperFunction.getUserLoggedInSharedPreference())!;
    }
    if(await HelperFunction.getMaxWaitTimeSharedPreference() == null){
      HelperFunction.saveMaxWaitTimeSharedPreference(5);
    }
    if(await HelperFunction.getListTypeSharedPreference() == null){
      HelperFunction.saveListTypeSharedPreference(true);
    }
    if(await HelperFunction.getMaxTimeSharedPreference() ==null){
      print(await HelperFunction.getMaxTimeSharedPreference());
      HelperFunction.saveMaxTimeSharedPreference(1);
    }
    if(await HelperFunction.getUserLangSharedPreference() ==null){
      final String defaultLocale = Platform.localeName;
      HelperFunction.saveUserLangSharedPreference(defaultLocale);
    }
    if(await HelperFunction.getUserTransLangSharedPreference() ==null){
      HelperFunction.saveUserTransLangSharedPreference('en');
    }
  }
  @override
  void initState() {
    checkFirstTime();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) =>MaterialApp(
    debugShowCheckedModeBanner: false,
    title: MyApp.title,
    themeMode: ThemeMode.system,
    theme: ThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.blueGrey.shade900,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0
      )
    ),
    // home: NotesPage(false),
    home:firstTime !=null ? firstTime! ? const NotesPage(false):const OnBoardPage(): Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    ),
    routes: {
      'profile':(context) => ProfilePage(test),
      'home':(context) => const NotesPage(false),
      'homes':(context) => const NotesPage(true)
    },
  );
}


