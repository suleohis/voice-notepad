import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key? key}) : super(key: key);

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.blueGrey[900],
      onDone: () {
        Navigator.pushReplacementNamed(context, 'home');
      },
      onSkip: () {
        Navigator.pushReplacementNamed(context, 'home');
      },
      done: const Text(
        'Done',
        style: TextStyle(color: Colors.white),
      ),
      showDoneButton: true,
      showNextButton: true,
      showSkipButton: true,
      next: const Text(
        'Next',
        style: TextStyle(color: Colors.white),
      ),
      skip: const Text(
        'Skip',
        style: TextStyle(color: Colors.white),
      ),
      pages: [
        PageViewModel(
            title: 'Ohis Notepad',
            image: Image.asset('assets/logo.png'),
            body: 'Welcome To Speech-To-text Notepad',
            decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                bodyTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 18))),
        PageViewModel(
            title: 'Speech-To-Text',
            image: Image.asset('assets/speech-to-text-apps.jpg'),
            body:
                'This app have Speech-To-Text Functionality, so you can make your '
                'note without having to write. The app allow you convert Speech-To-Text from one language to other language ',
            decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                bodyTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 18))),
        PageViewModel(
            title: 'Back Up',
            image: Image.asset(
              'assets/googleIcon.png',
            ),
            body:
                'All note are being back up to a database. So do well to go to '
                'the Profile page to Sign Up',
            decoration: const PageDecoration(
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                bodyTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 18))),
      ],
    );
  }
}
