import 'package:call_court/data/domain/court/court.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CourtListTile extends HookConsumerWidget {
  const CourtListTile({
    super.key,
    this.patternName,
    required this.court,
    required this.onTap,
    this.onLongPress,
  });

  final String? patternName;
  final Court court;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patternName = this.patternName;

    return ListTile(
      title: Row(
        mainAxisAlignment: patternName == null //
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          if (patternName != null) ...[
            CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(patternName),
            ),
            const Gap(30),
          ],

          ///
          CircleAvatar(
            child: Text(court.leftFirst.toString()),
          ),
          const Gap(6),
          CircleAvatar(
            child: Text(court.leftSecond.toString()),
          ),
          const Gap(16),
          const Text('ねっと'),
          const Gap(16),
          CircleAvatar(
            child: Text(court.rightFirst.toString()),
          ),
          const Gap(6),
          CircleAvatar(
            child: Text(court.rightSecond.toString()),
          ),
        ],
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
