import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final String? currentLocaleId ;
  final String? translationLocaleId ;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final TextEditingController? controller;
  final bool? isListening;
  final String? lastWords;
  final String? lastText;
  final double? level;

  const NoteFormWidget({
    required this.lastWords,
    required this.level,
    required this.lastText,
    required this.translationLocaleId,
    required this.currentLocaleId,
    this.isListening,
    this.controller,
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Switch(
                value: isImportant ?? false,
                onChanged: onChangedImportant,
              ),
              Expanded(
                child: Slider(

                  value: (number ?? 0).toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  activeColor: sliderColors(),
                  onChanged: (number) {
                    onChangedNumber(number.toInt());
                  }
                ),
              )
            ],
          ),
          buildTitle(),
          const SizedBox(height: 8),
          SizedBox(
              height: MediaQuery.of(context).size.height,
              child:
              isListening!?
              RecognitionResultsWidget
                (lastWords: lastWords, level: level,
                controller: lastText,
                currentLocaleId: currentLocaleId,
                translationLocaleId: translationLocaleId,
              )
                  :
              buildDescription()),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );

  sliderColors(){
    switch(number){
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blue[900];
      case 3:
        return Colors.green[700];
      case 4:
        return Colors.red[700];
      case 5:
        return Colors.yellow[700];
      default:
        return Colors.blue;
    }
  }

  Widget buildTitle() => TextFormField(
    maxLines: 1,
    textCapitalization: TextCapitalization.words,
    initialValue: title,
    style: const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Title',
      hintStyle: TextStyle(color: Colors.white70),
    ),
    validator: (title) =>
    title != null && title.isEmpty ? 'The title cannot be empty' : null,
    onChanged: onChangedTitle,
  );

  Widget buildDescription() => TextFormField(
    maxLines: null,
    // initialValue: description,
    controller: controller,
    textCapitalization: TextCapitalization.sentences,
    style: const TextStyle(color: Colors.white60, fontSize: 18),
    decoration: const InputDecoration(
      border: InputBorder.none,
      hintText: 'Type something...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The description cannot be empty'
        : null,
    onChanged: onChangedDescription,
  );
}

/// Displays the most recently recognized words and the sound level.
class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    Key? key,
    required this.controller,
    required this.lastWords,
    required this.level,
    required this.currentLocaleId,
    required this.translationLocaleId
  }) : super(key: key);
  final String? lastWords;
  final double? level;
  final String? currentLocaleId ;
  final String? translationLocaleId ;
  final String? controller;


  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        controller! + lastWords!,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        textAlign: TextAlign.left,
      ),
    );
  }
}