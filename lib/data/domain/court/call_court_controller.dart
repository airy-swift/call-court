import 'package:call_court/data/domain/court/court.dart';
import 'package:call_court/data/service/shared_pref_service.dart';
import 'package:call_court/foundation/util/reader.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final callCourtControllerProvider = StateNotifierProvider<CallCourtController, CallCourtState>(
  (ref) => CallCourtController(ref.read),
);

final presetCourtsProvider = StateProvider<List<Court>>((ref) {
  return SharedPrefService.shared.fetch(SharedPrefKind.presetCourt);;
});

class CallCourtState {
  CallCourtState({
    required this.callCourts,
    this.lastCalledCourt = const [],
  });

  final List<Court> callCourts;
  final List<Court> lastCalledCourt;
}

class CallCourtController extends StateNotifier<CallCourtState> {
  CallCourtController(this._read) : super(CallCourtState(callCourts: []));

  final Reader _read;

  void reloadCourt() {
    _read(presetCourtsProvider.notifier).state = SharedPrefService.shared.fetch(SharedPrefKind.presetCourt);
  }

  void addCourt(Court court) {
    final callCourts = state.callCourts.toList();
    state = CallCourtState(callCourts: callCourts..add(court), lastCalledCourt: state.lastCalledCourt);
  }

  void removeCourt(int index) {
    final callCourts = state.callCourts.toList();
    state = CallCourtState(callCourts: callCourts..removeAt(index), lastCalledCourt: state.lastCalledCourt);
  }

  void clearCourt() => //
      state = CallCourtState(callCourts: [], lastCalledCourt: state.callCourts);
}
