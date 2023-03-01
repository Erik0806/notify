import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger_flutter_plus/logger_flutter_plus.dart';

final loggerProvider = Provider<Logger>(
  (ref) {
    return Logger(
      filter:
          MyFilter(), // Use the default LogFilter (-> only log in debug mode)
      printer: PrettyPrinter(
        printTime: true,
      ),

      output: AppLogOutput(
        logConsoleManager: ref.read(logConsoleManagerProvider),
      ), // Use the default LogOutput (-> send everything to console)
    );
  },
);

class AppLogOutput extends LogOutput {
  AppLogOutput({
    required this.logConsoleManager,
  });
  final LogConsoleManager logConsoleManager;

  @override
  void output(OutputEvent event) {
    logConsoleManager.addLog(event);
  }

  @override
  void destroy() {
    logConsoleManager.dispose();
    super.destroy();
  }
}

final logConsoleManagerProvider = Provider<LogConsoleManager>((ref) {
  return LogConsoleManager(
    isDark: true,
  );
});

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
