import 'package:call_court/data/domain/court/court.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPrefKind {
  presetCourt,
}

class SharedPrefService {
  SharedPrefService._();

  static final _shared = SharedPrefService._();

  static SharedPrefService get shared => _shared;

  late final SharedPreferences _instance;

  Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  T fetch<T>(SharedPrefKind kind) {
    switch (kind) {
      case SharedPrefKind.presetCourt:
        return _presetCourt as T;
    }
  }

  void addPresetCourt(Court court) {
    final courts = _presetCourt.toList()..add(court);
    final rawStringCourts = courts.map((v) => v.formatString).toList();
    _instance.setStringList(SharedPrefKind.presetCourt.name, rawStringCourts);
  }

  void removePresetCourt(int index) {
    final courts = _presetCourt.toList()..removeAt(index);
    savePresetCourt(courts);
  }

  void savePresetCourt(List<Court> courts) {
    final rawStringCourts = courts.map((v) => v.formatString).toList();
    _instance.setStringList(SharedPrefKind.presetCourt.name, rawStringCourts);
  }

  List<Court> get _presetCourt {
    final presetStringList = _instance.getStringList(SharedPrefKind.presetCourt.name) ?? [];
    return presetStringList.map(Court.fromString).toList();
  }
}
