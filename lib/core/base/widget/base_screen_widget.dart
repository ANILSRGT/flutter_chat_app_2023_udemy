import 'package:flutter/material.dart';

import '../../init/navigation/core_router.dart';
import '../../init/services/authentication/authentication_manager.dart';
import '../../widgets/splash/splash_screen.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  final bool checkAuth;
  const BaseScreen({
    super.key,
    required this.child,
    required this.checkAuth,
  });

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.checkAuth) {
      return StreamBuilder(
        stream: AuthenticationManager.instance.getAuthStateChanges(),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return widget.child;
          }
          return CoreRouter.authScreen;
        },
      );
    } else {
      return widget.child;
    }
  }
}
