import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final loggerProvider = Provider<Logger>(
  (ref) {
    return Logger(
      filter:
          MyFilter(), // Use the default LogFilter (-> only log in debug mode)
      printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
      output: null, // Use the default LogOutput (-> send everything to console)
    );
  },
);

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // return true;
    if (event.level != Level.info) {
      return true;
    } else {
      return false;
    }
  }
}
