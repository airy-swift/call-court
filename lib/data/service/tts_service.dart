import 'dart:io';

import 'package:call_court/data/domain/court/court.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TtsService {
  TtsService._();

  static TtsService get shared => _shared;
  static final _shared = TtsService._();

  late final FlutterTts _tts;

  Future<void> init() async {
    _tts = FlutterTts();
    // if (Platform.isIOS) {
    //   await _tts.setSharedInstance(true);
    // }
    // await _tts.setIosAudioCategory(
    //     IosTextToSpeechAudioCategory.ambient,
    //     [
    //       IosTextToSpeechAudioCategoryOptions.allowBluetooth,
    //       IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
    //       IosTextToSpeechAudioCategoryOptions.mixWithOthers,
    //     ],
    //     IosTextToSpeechAudioMode.voicePrompt);
    await _tts.awaitSpeakCompletion(true);
    // await _tts.awaitSynthCompletion(true);
  }

  Future<void> speak(String text) async {
    final result = await _tts.speak(text);
    print(result);
  }
  Future<void> stop() async {
    final result = await _tts.stop();
    print(result);
  }

  Future<void> callCourt(int courtNumber, Court court) async {
    await speak('第$courtNumberコート');
    await court.callEach();
  }
}
