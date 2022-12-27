// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:translator/translator.dart';
// import 'package:voice_notepad/db/notes_database.dart';
// import 'package:voice_notepad/db/sharedpref.dart';
// import 'package:voice_notepad/model/note.dart';
// import 'package:voice_notepad/widget/note_form_widget.dart';
// import 'package:speech_to_text/speech_recognition_error.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
//
// class AddEditNotePage extends StatefulWidget {
//   final Note? note;
//   const AddEditNotePage({Key? key,this.note}) : super(key: key);
//
//   @override
//   _AddEditNotePageState createState() => _AddEditNotePageState();
// }
//
// class _AddEditNotePageState extends State<AddEditNotePage> {
//   final _formKey = GlobalKey<FormState>();
//   late bool isImportant;
//   late int number;
//   late String title;
//   late String description;
//   int? maxWaitTime;
//   int? maxTime;
//   TextEditingController controller = TextEditingController();
//
//   bool _hasSpeech = false;
//   bool _logEvents = false;
//   double level = 0.0;
//   double minSoundLevel = 50000;
//   double maxSoundLevel = -50000;
//   String lastWords = '';
//   String lastError = '';
//   String lastStatus = '';
//   String? _currentLocaleId = '';
//   String? _translationLocaleId = '';
//   List<LocaleName> o_localeNames = [];
//   final SpeechToText speech = SpeechToText();
//
//   refresh()async{
//     maxWaitTime = await HelperFunction.getMaxWaitTimeSharedPreference();
//     maxTime = await HelperFunction.getMaxTimeSharedPreference();
//     _currentLocaleId = await HelperFunction.getUserLangSharedPreference();
//     _translationLocaleId = await HelperFunction.getUserTransLangSharedPreference();
//     print(maxWaitTime);
//     print(maxTime);
//     print(_currentLocaleId);
//     setState(() {});
//   }
//   @override
//   void initState() {
//     super.initState();
//     initSpeechState();
//     refresh();
//     isImportant = widget.note?.isImportant ?? false;
//     number = widget.note?.number ?? 0;
//     title = widget.note?.title ?? '';
//     description = widget.note?.description ?? '';
//     controller.text =description;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         actions: [buildButton()],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: speech.isListening ? const Icon(Icons.stop):const Icon(Icons.mic),
//         onPressed: _listen,
//       ),
//       body: Form(
//         key: _formKey,
//         child: NoteFormWidget(
//           isListening: speech.isListening,
//           lastWords: lastWords,
//           level: level,
//           controller: controller,
//           isImportant: isImportant,
//           currentLocaleId: _currentLocaleId,
//           translationLocaleId: _translationLocaleId,
//           number: number,
//           title: title,
//           description:  description,
//           onChangedImportant: (isImportant) =>
//               setState(() => this.isImportant = isImportant),
//           onChangedNumber: (number) => setState(() => this.number = number),
//           onChangedTitle: (title) => setState(() => this.title = title),
//           onChangedDescription: (description) =>
//               setState(() => this.description = description), lastText: lastText,
//         ),
//       ),
//     );
//   }
//   void _listen(){
//     if(_hasSpeech  || !speech.isListening){
//       setState(() {
//         controller.text = controller.text== ''?'':controller.text +'. ';
//         startListening();
//       });
//     }
//
//     if(speech.isListening){
//       setState(() {
//         stopListening();
//       });
//     }
//   }
//   Future<void> initSpeechState() async {
//
//     _logEvent('Initialize');
//     var hasSpeech = await speech.initialize(
//       onError: errorListener,
//       onStatus: statusListener,
//       debugLogging: true,
//     );
//     // if (hasSpeech) {
//     //   // Get the list of languages installed on the supporting platform so they
//     //   // can be displayed in the UI for selection by the user.
//     //   _localeNames = await speech.locales();
//     //   var systemLocale = await speech.systemLocale();
//     //   _currentLocaleId = systemLocale?.localeId ?? '';
//     // }
//
//     if (!mounted) return;
//
//     setState(() {
//       _hasSpeech = hasSpeech;
//     });
//   }
//   String lastText ='';
//   void startListening() {
//     _logEvent('start listening');
//     lastWords = '';
//     lastText =controller.text;
//     lastError = '';
//     // Note that `listenFor` is the maximum, not the minimun, on some
//     // recognition will be stopped before this value is reached.
//     // Similarly `pauseFor` is a maximum not a minimum and may be ignored
//     // on some devices.
//     speech.listen(
//         onResult: resultListener,
//         pauseFor: Duration(seconds: maxWaitTime!),
//         listenFor: Duration(seconds: maxTime!),
//         partialResults: true,
//         localeId: _currentLocaleId,
//         onSoundLevelChange: soundLevelListener,
//         cancelOnError: true,
//         listenMode: ListenMode.confirmation);
//     finished = true;
//     setState(() {});
//     print('here');
//   }
//   bool finished = false;
//   void stopListening() {
//     _logEvent('stop');
//     speech.stop();
//     setState(() {
//       level = 0.0;
//     });
//   }
//
//   void cancelListening() {
//     _logEvent('cancel');
//     speech.cancel();
//     setState(() {
//       level = 0.0;
//     });
//   }
//
//   /// This callback is invoked each time new recognition results are
//   /// available after `listen` is called.
//   void resultListener(SpeechRecognitionResult result)async {
//     _logEvent(
//         'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
//     if(!speech.isListening){
//       String text = await translate(result.recognizedWords);
//       controller.text =lastText + text;
//     }
//     setState(() {
//       print(result.recognizedWords);
//       lastWords =  result.recognizedWords ;
//       // lastWords = '${result.recognizedWords} - ${result.finalResult}';
//
//     });
//   }
//   Future<String> translate(String lastWords)async{
//     GoogleTranslator translator = GoogleTranslator();
//     Translation text = await translator.translate(lastWords, from: _currentLocaleId!.substring(0,2),
//         to: _translationLocaleId!);
//
//     return  text.text;
//   }
//   void soundLevelListener(double level) {
//     minSoundLevel = min(minSoundLevel, level);
//     maxSoundLevel = max(maxSoundLevel, level);
//     // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
//     setState(() {
//       this.level = level;
//     });
//   }
//
//   void errorListener(SpeechRecognitionError error) {
//     _logEvent(
//         'Received error status: $error, listening: ${speech.isListening}');
//
//     lastError = '${error.errorMsg} - ${error.permanent}';
//   }
//
//   void statusListener(String status) {
//     _logEvent(
//         'Received listener status: $status, listening: ${speech.isListening}');
//     setState(() {
//       lastStatus = status;
//     });
//   }
//
//   void _switchLang(selectedVal) {
//     setState(() {
//       _currentLocaleId = selectedVal;
//     });
//     print(selectedVal);
//   }
//
//   void _logEvent(String eventDescription) {
//     if (_logEvents) {
//       var eventTime = DateTime.now().toIso8601String();
//       print('$eventTime $eventDescription');
//     }
//   }
//
//   void _switchLogging(bool? val) {
//     setState(() {
//       _logEvents = val ?? false;
//     });
//   }
//   ///This is used to create save button
//   Widget buildButton() {
//     final isFormValid = title.isNotEmpty && description.isNotEmpty;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           onPrimary: Colors.white,
//           primary: isFormValid ? null : Colors.grey.shade700,
//         ),
//         onPressed: addOrUpdateNote,
//         child: const Text('Save'),
//       ),
//     );
//   }
//
//   ///This is used to create and update notes
//   void addOrUpdateNote() async {
//     description = controller.text;
//     final isValid = _formKey.currentState!.validate();
//
//     if (isValid) {
//       final isUpdating = widget.note != null;
//
//       if (isUpdating) {
//         await updateNote();
//         Navigator.of(context).pop();
//       } else {
//         await addNote();
//         Navigator.pop(context);
//         Navigator.pop(context);
//         Navigator.pushNamed(context, 'home');
//       }
//
//
//     }
//   }
//
//   ///This is the function for updating note
//   Future updateNote() async {
//     final note = widget.note!.copy(
//       isImportant: isImportant,
//       number: number,
//       title: title,
//       description: description,
//       uploaded: 'Yes',
//       updated: 'No',
//     );
//
//     await NotesDatabase.instance.update(note);
//   }
//
//   ///This is the function for add notte
//   Future addNote() async {
//     final note = Note(
//         title: title,
//         isImportant: isImportant,
//         number: number,
//         description: description,
//         createdTime: DateTime.now(),
//         uploaded: 'No',
//         updated: 'Yes',
//         deleted: 'No',
//         docId: generateRandomString(25)
//     );
//
//     await NotesDatabase.instance.create(note);
//   }
//
//   ///This is used to make unique key
//   String generateRandomString(int len) {
//     var r = Random();
//     const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//     return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
//   }
// }
