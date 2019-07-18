import 'package:flutter/services.dart';
import 'package:fun_translate_it/src/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeBloc {
  final BehaviorSubject<FunLanguage> _languageController =
      BehaviorSubject<FunLanguage>();
  final BehaviorSubject<String> _textController = BehaviorSubject<String>();
  final BehaviorSubject<String> _resultController = BehaviorSubject<String>();

  Function(FunLanguage) get languageChanged => _languageController.sink.add;
  Function(String) get textChanged => _textController.sink.add;
  Function(String) get resultChanged => _resultController.sink.add;

  Stream<FunLanguage> get language => _languageController.stream;
  Stream<String> get text => _textController.stream;
  Stream<String> get result => _resultController.stream;

  Future<void> translate() async {
    resultChanged('wait');
    final String url =
        'https://api.funtranslations.com/translate/${_languageController.value.json}?text=${_textController.value}';
    var response = await http.get(url);
    var jsonResponse = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      String result = jsonResponse['contents']['translated'];
      resultChanged(result);
      print(result);
    } else {
      _resultController.sink.addError(jsonResponse['error']['message']);
      print("Request failed with status: ${jsonResponse['error']['message']}.");
    }
  }

  void copyText() {
    Clipboard.setData(ClipboardData(text: _resultController.value));
  }

  void shareText() {
    Share.share(_resultController.value);
  }

  void dispose() {
    _languageController.close();
    _textController.close();
    _resultController.close();
  }
}
