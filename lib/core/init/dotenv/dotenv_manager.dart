import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvType { none }

class DotEnvManager {
  static final DotEnvManager _instance = DotEnvManager._init();
  static DotEnvManager get instance => _instance;

  DotEnvManager._init();

  static Future<void> initEnv() async {
    await dotenv.load(fileName: '.env');
  }

  String getEnv(EnvType envName) {
    return dotenv.get(envName.value, fallback: envName.fallback);
  }
}

extension _EnvTypeExtension on EnvType {
  String get value {
    switch (this) {
      case EnvType.none:
        return '';
    }
  }

  String get fallback {
    switch (this) {
      case EnvType.none:
        return '';
    }
  }
}
