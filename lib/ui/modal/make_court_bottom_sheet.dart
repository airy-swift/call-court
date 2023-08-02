import 'package:call_court/data/domain/court/call_court_controller.dart';
import 'package:call_court/data/domain/court/court.dart';
import 'package:call_court/data/service/shared_pref_service.dart';
import 'package:call_court/ui/component/court_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MakeCourtBottomSheet extends HookConsumerWidget {
  const MakeCourtBottomSheet._();

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const MakeCourtBottomSheet._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
          // 勝手にdividerが入ったりsplashの範囲が大きすぎたりして不便なので隠す
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SelectNumberIndicator(),
                  const _Buttons(),
                  const Gap(12),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(currentFieldProvider.notifier).state = DoubleCourt.leftFirst;
                      final inputCourt = ref.read(inputCourtProvider);
                      SharedPrefService.shared.addPresetCourt(inputCourt);
                      ref.read(inputCourtProvider.notifier).state = Court.none();
                      ref.read(callCourtControllerProvider.notifier).reloadCourt();
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text('保存'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Buttons extends HookConsumerWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ...List<Widget>.generate(
            40,
            (index) => Padding(
              padding: const EdgeInsets.all(6.0),
              child: FloatingActionButton(
                backgroundColor: Colors.pink,
                onPressed: () {
                  final current = ref.read(inputCourtProvider);
                  ref.read(inputCourtProvider.notifier).state = switch (ref.read(currentFieldProvider)) {
                    DoubleCourt.leftFirst => Court(leftFirst: index + 1, leftSecond: current.leftSecond, rightFirst: current.rightFirst, rightSecond: current.rightSecond),
                    DoubleCourt.leftSecond => Court(leftFirst: current.leftFirst, leftSecond: index + 1, rightFirst: current.rightFirst, rightSecond: current.rightSecond),
                    DoubleCourt.rightFirst => Court(leftFirst: current.leftFirst, leftSecond: current.leftSecond, rightFirst: index + 1, rightSecond: current.rightSecond),
                    DoubleCourt.rightSecond => Court(leftFirst: current.leftFirst, leftSecond: current.leftSecond, rightFirst: current.rightFirst, rightSecond: index + 1),
                  };
                  ref.read(currentFieldProvider.notifier).state = ref.read(currentFieldProvider).next;
                },
                child: Text(
                  (index + 1).toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectNumberIndicator extends HookConsumerWidget {
  const _SelectNumberIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const ColoredBox(
          color: Colors.amberAccent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
            child: _InputCourtTile(),
          ),
        ),
      ),
    );
  }
}

final inputCourtProvider = StateProvider((ref) => Court.none());
final currentFieldProvider = StateProvider((ref) => DoubleCourt.leftFirst);

enum DoubleCourt {
  leftFirst,
  leftSecond,
  rightFirst,
  rightSecond,
}

extension DoubleCourtEx on DoubleCourt {
  DoubleCourt get next => switch (this) {
        DoubleCourt.leftFirst => DoubleCourt.leftSecond,
        DoubleCourt.leftSecond => DoubleCourt.rightFirst,
        DoubleCourt.rightFirst => DoubleCourt.rightSecond,
        DoubleCourt.rightSecond => DoubleCourt.leftFirst,
      };

  int getNumber(Court court) => switch (this) {
        DoubleCourt.leftFirst => court.leftFirst,
        DoubleCourt.leftSecond => court.leftSecond,
        DoubleCourt.rightFirst => court.rightFirst,
        DoubleCourt.rightSecond => court.rightSecond,
      };
}

class _InputCourtTile extends HookConsumerWidget {
  const _InputCourtTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSelect = ref.watch(inputCourtProvider);

    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _InputCourtNumberField(value: DoubleCourt.leftFirst),
        Gap(6),
        _InputCourtNumberField(value: DoubleCourt.leftSecond),
        Gap(16),
        Text('ねっと'),
        Gap(16),
        _InputCourtNumberField(value: DoubleCourt.rightFirst),
        Gap(6),
        _InputCourtNumberField(value: DoubleCourt.rightSecond),
      ],
    );
  }
}

class _InputCourtNumberField extends HookConsumerWidget {
  const _InputCourtNumberField({
    required this.value,
  });

  final DoubleCourt value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSelectedField = ref.watch(currentFieldProvider);
    final court = ref.watch(inputCourtProvider);
    final number = value.getNumber(court);

    return GestureDetector(
      onTap: () {
        ref.read(currentFieldProvider.notifier).state = value;
      },
      child: CircleAvatar(
        radius: 26,
        backgroundColor: currentSelectedField == value ? Colors.blue : Colors.white,
        child: Text(
          number == 0 ? '' : number.toString(),
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
