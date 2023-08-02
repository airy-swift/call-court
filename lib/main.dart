import 'package:call_court/app/app.dart';
import 'package:call_court/data/service/shared_pref_service.dart';
import 'package:call_court/data/service/tts_service.dart';
import 'package:call_court/ui/modal/make_court_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TtsService.shared.init();
  await SharedPrefService.shared.init();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
