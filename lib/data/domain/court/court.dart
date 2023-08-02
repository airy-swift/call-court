import 'package:call_court/data/service/tts_service.dart';

class Court {
  Court({
    this.patternName,
    required this.leftFirst,
    required this.leftSecond,
    required this.rightFirst,
    required this.rightSecond,
  });

  factory Court.none() => Court(leftFirst: 0, leftSecond: 0, rightFirst: 0, rightSecond: 0);

  factory Court.fromString(String raw) {
    // shared_prefでは 1,2/3,4 という風に保存する
    // "/"でコートを。","で囚人番号を区別する

    final splitCourt = raw.split('/');
    assert(splitCourt.length == 2);
    final left = splitCourt[0].split(',');
    assert(left.length == 2);
    final right = splitCourt[1].split(',');
    assert(right.length == 2);

    return Court(
      leftFirst: int.parse(left[0]),
      leftSecond: int.parse(left[1]),
      rightFirst: int.parse(right[0]),
      rightSecond: int.parse(right[1]),
    );
  }

  String? patternName;
  final int leftFirst;
  final int leftSecond;
  final int rightFirst;
  final int rightSecond;

  Future<void> callEach() async {
    await TtsService.shared.speak('$leftFirst番');
    await TtsService.shared.speak('$leftSecond番');
    await TtsService.shared.speak('$rightFirst番');
    await TtsService.shared.speak('$rightSecond番');
  }

  String get formatString => '$leftFirst,$leftSecond/$rightFirst,$rightSecond';
}
