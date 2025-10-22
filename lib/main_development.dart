import 'package:flutter/widgets.dart';
import 'package:javerage_todos/app/app.dart';
import 'package:javerage_todos/core/bootstrap.dart';

Future<void> main() async {
  // Ensure Flutter bindings are ready before any plugin or platform
  // channel calls that may happen during app startup or imports.
  WidgetsFlutterBinding.ensureInitialized();

  await bootstrap(() => const App());
}
