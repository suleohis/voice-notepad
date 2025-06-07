import 'dart:async';
import 'dart:math';

import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:translator/translator.dart';
import 'package:voice_notepad/db/notes_database.dart';
import 'package:voice_notepad/db/sharedpref.dart';
import 'package:voice_notepad/model/note.dart';
import 'package:voice_notepad/widget/note_form_widget.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  int? maxWaitTime;
  int? maxTime;
  TextEditingController controller = TextEditingController();

  bool _hasSpeech = false;
  final bool _logEvents = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String? _currentLocaleId = '';
  String? _translationLocaleId = '';
  final SpeechToText speech = SpeechToText();
  FlutterSound flutterSound = FlutterSound();
  late final CustomTimerController _controller = CustomTimerController(
      vsync: this,
      begin: const Duration(hours: 24),
      end: const Duration(),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds
  );

  refresh() async {
    maxWaitTime = await HelperFunction.getMaxWaitTimeSharedPreference();
    maxTime = await HelperFunction.getMaxTimeSharedPreference();
    _currentLocaleId = await HelperFunction.getUserLangSharedPreference();
    _translationLocaleId =
        await HelperFunction.getUserTransLangSharedPreference();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSpeechState();
    refresh();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    controller.text = description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButton()],
      ),
      floatingActionButton: FloatingActionButton(
        child:
            speech.isListening ? const Icon(Icons.stop) : const Icon(Icons.mic),
        onPressed: _listen,
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          isListening: speech.isListening,
          lastWords: lastWords,
          level: level,
          controller: controller,
          isImportant: isImportant,
          currentLocaleId: _currentLocaleId,
          translationLocaleId: _translationLocaleId,
          number: number,
          title: title,
          description: description,
          onChangedImportant: (isImportant) =>
              setState(() => this.isImportant = isImportant),
          onChangedNumber: (number) => setState(() => this.number = number),
          onChangedTitle: (title) => setState(() => this.title = title),
          onChangedDescription: (description) =>
              setState(() => this.description = description),
          lastText: lastText,
        ),
      ),
    );
  }

  void _listen() {
    if (_hasSpeech || !speech.isListening) {
      setState(() {
        controller.text = controller.text == '' ? '' : controller.text + '. ';
        startListening();
      });
    }

    if (speech.isListening) {
      setState(() {
        stopListening();
      });
    }
  }

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    var hasSpeech = await speech.initialize(
      onError: errorListener,
      onStatus: statusListener,
      debugLogging: true,
    );
    // if (hasSpeech) {
    //   // Get the list of languages installed on the supporting platform so they
    //   // can be displayed in the UI for selection by the user.
    //   _localeNames = await speech.locales();
    //   var systemLocale = await speech.systemLocale();
    //   _currentLocaleId = systemLocale?.localeId ?? '';
    // }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  String lastText = '';
  void startListening() {

    finished = true;
    if(mounted) {
      setState(() {});
    }
    _logEvent('start listening');
    lastWords = '';
    lastText = controller.text;
    lastError = '';

    speech.listen(
        onResult: resultListener,
        pauseFor: const Duration(seconds: 60),
        listenFor: const Duration(minutes: 1),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,);

  }

  bool finished = false;
  void stopListening() {
    _logEvent('stop');
    speech.stop();
    _controller.reset();
    setState(() {
      finished = false;
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    _controller.reset();
    setState(() {
      finished = false;
      level = 0.0;
    });
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) async {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    if (!speech.isListening) {
      if (_currentLocaleId == 'en_NG' ) {
        if(!controller.text.contains(result.recognizedWords)) {

          controller.text = lastText + result.recognizedWords;
        }
      } else {
        String text = await translate(result.recognizedWords);
        if (!controller.text.contains(text)) {
          controller.text = lastText + text;
        }
      }
    }
    if (mounted) {
      setState(() {
        lastWords = result.recognizedWords;
      });
    } else {
        lastWords = result.recognizedWords;
    }
  }

  ///This is used to convert lang to another one
  Future<String> translate(String lastWords) async {
    GoogleTranslator translator = GoogleTranslator();
    Translation text = await translator.translate(lastWords,
        from: _currentLocaleId!.substring(0, 2), to: _translationLocaleId!);

    return text.text;
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) async {
    if ((error.errorMsg == "error_no_match" ||
            error.errorMsg == "error_network_timeout" ||
            error.errorMsg == "error_speech_timeout")  && finished == true) {
      // controller.text = controller.text + lastWords;
      speech.stop();
      await Future.delayed(const Duration(milliseconds: 100));
      initSpeechState();
      await Future.delayed(const Duration(milliseconds: 100));
      startListening();
    }
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');

    lastError = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status) async {
    // controller.text = '$status \n';
    if ((status == 'notListening' || status == 'done') && finished == true) {
      // controller.text = controller.text + lastWords;
      speech.stop();
      await Future.delayed(const Duration(milliseconds: 100));
      initSpeechState();
      await Future.delayed(const Duration(milliseconds: 100));
      startListening();
    }
    if (mounted) {
      setState(() {
        lastStatus = status;
      });
    }
    // if (status == "done" && finished) {
    //   setState(() {
    //     finished = false;
    //   });
    //   startListening();
    // }
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      // var eventTime = DateTime.now().toIso8601String();
    }
  }

  ///This is used to create save button
  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: const Text('Save'),
      ),
    );
  }

  ///This is used to create and update notes
  void addOrUpdateNote() async {
    description = controller.text;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
        Navigator.of(context).pop();
      } else {
        await addNote();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, 'home');
      }
    }
  }

  ///This is the function for updating note
  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      uploaded: 'Yes',
      updated: 'No',
    );

    await NotesDatabase.instance.update(note);
  }

  ///This is the function for add notte
  Future addNote() async {
    final note = Note(
        title: title,
        isImportant: isImportant,
        number: number,
        description: description,
        createdTime: DateTime.now(),
        uploaded: 'No',
        updated: 'Yes',
        deleted: 'No',
        docId: generateRandomString(25));

    await NotesDatabase.instance.create(note);
  }

  ///This is used to make unique key
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
