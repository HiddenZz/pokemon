import 'dart:async';

import 'package:pokemon/src/core/utils/refined_logger.dart';
import 'package:pokemon/src/feature/initialization/logic/app_runner.dart';

void main() => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    );
