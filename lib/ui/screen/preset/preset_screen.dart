import 'dart:async';

import 'package:call_court/app/router.dart';
import 'package:call_court/data/domain/court/call_court_controller.dart';
import 'package:call_court/data/domain/court/court.dart';
import 'package:call_court/data/service/shared_pref_service.dart';
import 'package:call_court/data/service/tts_service.dart';
import 'package:call_court/ui/component/court_list_tile.dart';
import 'package:call_court/ui/modal/make_court_bottom_sheet.dart';
import 'package:call_court/ui/screen/full_screen/full_screen_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PresetScreen extends HookConsumerWidget {
  const PresetScreen({super.key});

  static const routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callCourts = ref.watch(callCourtControllerProvider.select((v) => v.callCourts));
    final lastCalledCourt = ref.watch(callCourtControllerProvider.select((v) => v.lastCalledCourt));
    final presetCourts = ref.watch(presetCourtsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('囚人番号朝礼点呼'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CallWaitList(
            callCourts: callCourts,
            backgroundColor: Colors.greenAccent,
            buttonLabel: '点呼',
            onTap: () async {
              if (callCourts.isEmpty) {
                return;
              }

              unawaited(
                ref.read(routerProvider).push(
                      FullScreenScreen.routePath,
                      extra: FullScreenScreenProps(courts: callCourts),
                    ),
              );
              await TtsService.shared.speak('朝礼を始めます！');
              for (final entry in callCourts.asMap().entries) {
                await TtsService.shared.callCourt(entry.key + 1, entry.value);
              }
              ref.read(callCourtControllerProvider.notifier).clearCourt();
            },
          ),
          CallWaitList(
            callCourts: lastCalledCourt,
            backgroundColor: Colors.red,
            buttonLabel: '愚民を呼ぶ',
            onTap: () async {
              if (lastCalledCourt.isEmpty) {
                return;
              }
              unawaited(
                ref.read(routerProvider).push(
                      FullScreenScreen.routePath,
                      extra: FullScreenScreenProps(courts: lastCalledCourt),
                    ),
              );

              await TtsService.shared.speak('きけーい！');
              for (final entry in lastCalledCourt.asMap().entries) {
                await TtsService.shared.callCourt(entry.key + 1, entry.value);
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Gap(10),
                  const Divider(),
                  const Gap(10),
                  const GuideCourt(),
                  const Gap(16),
                  ...presetCourts.asMap().entries.map<Widget>((entry) {
                    final patternName = (entry.key + 1).toString();
                    final court = entry.value //
                      ..patternName = patternName;

                    return CourtListTile(
                      patternName: patternName,
                      court: court,
                      onTap: () {
                        ref.read(callCourtControllerProvider.notifier).addCourt(court);
                      },
                      onLongPress: () {
                        SharedPrefService.shared.removePresetCourt(entry.key);
                        ref.read(callCourtControllerProvider.notifier).reloadCourt();
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.newspaper),
        onPressed: () {
          MakeCourtBottomSheet.show(context);
        },
      ),
    );
  }
}

class GuideCourt extends StatelessWidget {
  const GuideCourt({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Gap(7),
        Text('パターン'),
        Gap(50),
        Text('左翼'),
        Gap(50),
        Text('ねっと'),
        Gap(50),
        Text('右翼'),
      ],
    );
  }
}

class CallWaitList extends HookConsumerWidget {
  const CallWaitList({
    super.key,
    required this.callCourts,
    required this.backgroundColor,
    required this.buttonLabel,
    required this.onTap,
  });

  final List<Court> callCourts;
  final Color backgroundColor;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: backgroundColor,
      height: 80,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Gap(6),
                  const Icon(Icons.person),
                  const Gap(6),
                  ...callCourts.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () {
                              ref.read(callCourtControllerProvider.notifier).removeCourt(entry.key);
                            },
                            child: CircleAvatar(
                              child: Text(
                                entry.value.patternName ?? 'エラー',
                              ),
                              backgroundColor: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton(
              onPressed: onTap,
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
