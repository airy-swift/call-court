import 'package:call_court/app/router.dart';
import 'package:call_court/data/domain/court/call_court_controller.dart';
import 'package:call_court/data/domain/court/court.dart';
import 'package:call_court/data/service/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class FullScreenScreenProps {
  const FullScreenScreenProps({
    required this.courts,
  });

  final List<Court> courts;
}

class FullScreenScreen extends HookConsumerWidget {
  const FullScreenScreen({
    super.key,
    required this.props,
  });

  static const routePath = '/full_screen';

  final FullScreenScreenProps props;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...props.courts.asMap().entries.map((entry) {
                return _Court(index: entry.key + 1, court: entry.value);
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(routerProvider).pop();
          TtsService.shared.stop();
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}

class _Court extends HookConsumerWidget {
  const _Court({
    required this.index,
    required this.court,
  });

  final int index;
  final Court court;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await TtsService.shared.speak('第$indexコート');
        await court.callEach();
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Text(
                '第$indexコート',
                style: TextStyle(fontSize: 24),
              ),
              Container(
                color: Colors.amberAccent,
                height: 210,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Number(number: court.leftFirst),
                          const Gap(4),
                          _Number(number: court.leftSecond),
                        ],
                      ),
                    ),
                    const Gap(24),
                    const Text('ね\nっ\nと'),
                    const Gap(24),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Number(number: court.rightFirst),
                          const Gap(4),
                          _Number(number: court.rightSecond),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Number extends StatelessWidget {
  const _Number({
    required this.number,
  });

  final int number;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 48,
      child: Text(
        number.toString(),
        style: const TextStyle(fontSize: 50),
      ),
    );
  }
}
