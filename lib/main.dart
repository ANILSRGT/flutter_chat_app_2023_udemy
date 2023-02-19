import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/init/database/database_manager.dart';
import 'core/init/dotenv/dotenv_manager.dart';
import 'core/init/navigation/core_router.dart';
import 'core/init/services/authentication/authentication_manager.dart';
import 'core/init/services/push_notification/push_notification_manager.dart';
import 'core/init/services/storage/storage_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _init().then((_) {
    runApp(const MyApp());
  });
}

Future<void> _init() async {
  await DotEnvManager.initEnv();
  await Firebase.initializeApp();
  await DatabaseManager.instance.initDB();
  await AuthenticationManager.instance.initAuth();
  await StorageManager.instance.initStorage();
  await PushNotificationManager.instance.initPushNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: const ColorScheme.light().copyWith(
          background: Colors.pink,
          primary: Colors.pink,
          onPrimary: Colors.white,
          primaryContainer: Colors.pink,
          onPrimaryContainer: Colors.white,
          secondary: Colors.deepPurple,
          onSecondary: Colors.white,
          secondaryContainer: Colors.deepPurple,
          onSecondaryContainer: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.pink,
          ),
        ),
      ),
      navigatorKey: CoreRouter.navigatorKey,
      initialRoute: CoreRouter.initialRoute,
      onGenerateRoute: CoreRouter.generateRoute,
    );
  }
}
