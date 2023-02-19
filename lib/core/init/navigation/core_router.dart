import 'package:flutter/material.dart';

import '../../../screens/auth_screen.dart';
import '../../../screens/chat_screen.dart';
import '../../constants/navigation/route_constants.dart';

class CoreRouter {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static String get initialRoute => RouteConstants.home;
  static Widget get authScreen => const AuthScreen();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.home:
        return materialPageRoute(const ChatScreen(), arguments: settings.arguments);
      case RouteConstants.auth:
        return materialPageRoute(authScreen, arguments: settings.arguments);
      default:
        return materialPageRoute(
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Error - 404!'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () =>
                      navigatorKey.currentState?.pushReplacementNamed(RouteConstants.home),
                ),
              ],
            ),
            body: const Center(
              child: Text('Page not found!'),
            ),
          ),
        );
    }
  }

  static materialPageRoute(Widget widget, {Object? arguments, bool fullScreenDialog = false}) {
    return MaterialPageRoute(
      builder: (_) => widget,
      settings: RouteSettings(arguments: arguments),
      fullscreenDialog: fullScreenDialog,
    );
  }
}
