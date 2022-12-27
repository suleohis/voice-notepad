import 'dart:io';

import 'package:flutter/material.dart';

import '../db/sharedpref.dart';
import '../service/authentication.dart';

class ProfilePage extends StatefulWidget {
  final bool signIn;
  const ProfilePage(this.signIn, {Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState(signIn);
}

class _ProfilePageState extends State<ProfilePage> {
  final bool signIn;
  _ProfilePageState(this.signIn);
  bool loading = false;
  int? maxWaitTime = 0;
  int? maxTime = 0;
  String? lang = '';
  String? transLang = '';

  getTime() async {
    maxWaitTime = await HelperFunction.getMaxWaitTimeSharedPreference();
    maxTime = await HelperFunction.getMaxTimeSharedPreference();
    lang = await HelperFunction.getUserLangSharedPreference();
    transLang = await HelperFunction.getUserTransLangSharedPreference();
    setState(() {});
  }

  @override
  void initState() {
    // tests();
    getTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        automaticallyImplyLeading: false,
        leading: const BackButton(),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.topCenter, child: googleButton()),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                chooseSpeechToTextTime(),
                const SizedBox(
                  height: 20,
                ),
                // Text('Colors',style: TextStyle(fontSize: 20,color: Colors.white),)
              ],
            ),
          ),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
  //  tests()async{
  //   test = await HelperFunction.getUserLoggedInSharedPreference();
  //   print(test);
  //    setState(() {});
  // }

  chooseSpeechToTextTime() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        // Wrap(
        //   crossAxisAlignment: WrapCrossAlignment.center,
        //   children: [
        //     const Text(
        //       'How long before Speech-To-Text stop.',
        //       style: TextStyle(fontSize: 16, color: Colors.white),
        //     ),
        //     const SizedBox(
        //       width: 2,
        //     ),
        //     Container(
        //       color: Colors.white,
        //       padding: const EdgeInsets.all(5),
        //       child: Text(maxWaitTime.toString() + ' sec'),
        //     ),
        //     PopupMenuButton(
        //       color: Colors.white,
        //       padding: EdgeInsets.zero,
        //       icon: const Icon(
        //         Icons.arrow_drop_down_sharp,
        //         color: Colors.white,
        //       ),
        //       initialValue: maxWaitTime,
        //       onSelected: (int value) async {
        //         setState(() {
        //           maxWaitTime = value;
        //         });
        //         await HelperFunction.saveMaxWaitTimeSharedPreference(
        //             maxWaitTime);
        //       },
        //       itemBuilder: (context) {
        //         return [
        //           const PopupMenuItem(value: 5, child: Text('5 sec')),
        //           const PopupMenuItem(value: 15, child: Text('15 sec')),
        //           const PopupMenuItem(value: 30, child: Text('30 sec')),
        //         ];
        //       },
        //     )
        //   ],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // Wrap(
        //   crossAxisAlignment: WrapCrossAlignment.center,
        //   children: [
        //     const Text(
        //       'How long will Speech-To-Text late',
        //       style: TextStyle(fontSize: 16, color: Colors.white),
        //     ),
        //     const SizedBox(
        //       width: 2,
        //     ),
        //     Container(
        //       color: Colors.white,
        //       padding: const EdgeInsets.all(5),
        //       child: Text(maxTime.toString() + ' min'),
        //     ),
        //     PopupMenuButton(
        //       color: Colors.white,
        //       padding: EdgeInsets.zero,
        //       icon: const Icon(
        //         Icons.arrow_drop_down_sharp,
        //         color: Colors.white,
        //       ),
        //       initialValue: maxTime,
        //       onSelected: (int value) async {
        //         setState(() {
        //           maxTime = value;
        //         });
        //         await HelperFunction.saveMaxTimeSharedPreference(maxTime);
        //       },
        //       itemBuilder: (context) {
        //         return [
        //           const PopupMenuItem(value: 1, child: Text('1 min')),
        //           const PopupMenuItem(value: 5, child: Text('5 min')),
        //           const PopupMenuItem(value: 10, child: Text('10 min')),
        //           const PopupMenuItem(value: 20, child: Text('20 min')),
        //           const PopupMenuItem(value: 30, child: Text('30 min')),
        //         ];
        //       },
        //     )
        //   ],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Choose The Speaking Language. ',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(
              width: 2,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(5),
              child: Text(chooseLang()),
            ),
            PopupMenuButton(
              color: Colors.white,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_drop_down_sharp,
                color: Colors.white,
              ),
              initialValue: lang,
              onSelected: (String value) async {
                setState(() {
                  lang = value;
                });
                await HelperFunction.saveUserLangSharedPreference(lang);
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(value: 'en_US', child: Text('English')),
                  // const PopupMenuItem(
                  //     value:'en_NG',child: Text('English (Nigeria)')),
                  const PopupMenuItem(value: 'fr_FR', child: Text('French')),
                  const PopupMenuItem(
                      value: 'pt_PT', child: Text('Portuguese')),
                  const PopupMenuItem(value: 'ar_SA', child: Text('Arabic')),
                  const PopupMenuItem(value: 'de_DE', child: Text('German')),
                  const PopupMenuItem(value: 'zh_HK', child: Text('Chinese')),
                ];
              },
            )
          ],
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Choose The Translation Language . ',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(
              width: 2,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(5),
              child: Text(chooseTransLang()),
            ),
            PopupMenuButton(
              color: Colors.white,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_drop_down_sharp,
                color: Colors.white,
              ),
              initialValue: transLang,
              onSelected: (String value) async {
                setState(() {
                  transLang = value;
                });
                await HelperFunction.saveUserTransLangSharedPreference(
                    transLang);
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(value: 'en', child: Text('English')),
                  const PopupMenuItem(value: 'yo', child: Text('Yoruba')),
                  const PopupMenuItem(value: 'ig', child: Text('Igbo')),
                  const PopupMenuItem(value: 'ha', child: Text('Hausa')),
                  const PopupMenuItem(value: 'fr', child: Text('French')),
                  const PopupMenuItem(value: 'pt', child: Text('Portuguese')),
                  const PopupMenuItem(value: 'ar', child: Text('Arabic')),
                  const PopupMenuItem(value: 'de', child: Text('German')),
                  const PopupMenuItem(value: 'zh', child: Text('Chinese')),
                ];
              },
            )
          ],
        )
      ],
    );
  }

  String chooseLang() {
    switch (lang) {
      case 'en_US':
        return 'English';
      case 'en_NG':
        return "English (Nigeria)";
      case 'fr_FR':
        return 'French';
      case 'pt_PT':
        return 'Portuguese';
      case 'ar_SA':
        return 'Arabic';
      case 'de_DE':
        return 'German';
      case 'zh_HK':
        return 'Chinese';
      default:
        return 'Choose ';
    }
  }

  String chooseTransLang() {
    switch (transLang) {
      case 'en':
        return 'English';
      case 'yo':
        return 'Yoruba';
      case 'ig':
        return 'Igbo';
      case 'ha':
        return 'Hausa';
      case 'fr':
        return 'French';
      case 'pt':
        return 'Portuguese';
      case 'ar':
        return 'Arabic';
      case 'de':
        return 'German';
      case 'zh':
        return 'Chinese';
      case null:
        return "Problem";
      default:
        return 'Choose ';
    }
  }

  checkInternetConnection(String string) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (string == 'signIn') {
          loading = true;
          setState(() {});
          Authentication.signWithGoogle(context: context);
        } else {
          loading = true;
          setState(() {});
          Authentication.signOUt(context: context);
        }

        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  Widget googleButton() {
    if (signIn) {
      return GestureDetector(
        onTap: () {
          checkInternetConnection('signOut');
        },
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width - 70,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Image.asset('assets/googleIcon.png'),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Sign Out',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          checkInternetConnection('signIn');
        },
        child: SizedBox(
          height: 50,
          width: 170,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Center(
                child: Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Image.asset('assets/googleIcon.png'),
                const SizedBox(
                  width: 15,
                ),
                const Text(
                  'Google',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
          ),
        ),
      );
    }
  }
}
//
// Center(
// child: Container(
// color: Colors.grey,
// height: 300,
// child: Stack(
// children: [
// Center(
// child: Container(
// padding: EdgeInsets.all(20),
// decoration: BoxDecoration(
// border: Border.all(width: 6),
// borderRadius: BorderRadius.circular(80)
// ),
// child: Container(
// padding: EdgeInsets.zero,
// decoration: BoxDecoration(
// color: Colors.grey,
// borderRadius: BorderRadius.circular(80)
// ),
// child: Icon(Icons.person_outline,size: 100,)),
// ),
// ),Positioned(
// top:-200,
// right: 0,
// left: -320,
// bottom: 0,
// child:Container(
// child: BackButton())
// // GestureDetector(
// //   onTap: () => Navigator.pushNamed(context, 'home'),
// //   child: Icon(Icons.arrow_back_ios,size: 30,),
// // )
// )
// ],
// ),
// ),
// ),
