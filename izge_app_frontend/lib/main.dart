import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import 'app/app.dart';
import 'core/config/supabase_config.dart';

export 'app/app.dart';

import 'core/theme/theme_controller.dart';
import 'core/localization/language_controller.dart';
import 'core/state/activity_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.init();
  await LanguageController.instance.init();
  await ActivityState.instance.init();
  // Start Supabase initialization but don't await here so app can render
  // immediately. The app will show its UI and react when initialization
  // completes via the provided future.
  final initFuture = Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Run a lightweight debug test after Supabase finishes initializing
  initFuture.whenComplete(() {
    if (kDebugMode) {
      _runSupabaseTest();
    }
  });

  runApp(IzgeApp(initialization: initFuture));
}

/// Runs a simple Supabase query and prints the result to console.
/// This is intended as a debug/test helper and only runs in debug builds.
Future<void> _runSupabaseTest() async {
  try {
    final result = await Supabase.instance.client.from('events').select();

    // Print whatever the SDK returned (usually a List of rows)
    // ignore: avoid_print
    print('Supabase test result: $result');
  } catch (e) {
    // ignore: avoid_print
    print('Supabase test exception: $e');
  }
}