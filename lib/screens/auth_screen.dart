import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/init/database/database_manager.dart';
import '../core/init/services/authentication/authentication_manager.dart';
import '../core/init/services/storage/storage_manager.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  void _onAuthError(String message, BuildContext ctx) {
    ScaffoldMessenger.of(ctx)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Theme.of(ctx).colorScheme.onError),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(ctx).colorScheme.error,
          closeIconColor: Theme.of(ctx).colorScheme.onError,
          showCloseIcon: true,
        ),
      );
  }

  Future<void> _authenticate(
    String email,
    String password,
    String? username,
    File? userImage,
    bool isLogin,
    BuildContext ctx,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      User? user;
      if (isLogin) {
        user = await AuthenticationManager.instance.loginEmailPassword(email, password);
      } else {
        if (username == null) {
          throw PlatformException(code: 'username', message: 'Username is required!');
        }
        user = await AuthenticationManager.instance.signUpEmailPassword(email, password);
      }
      if (user == null) {
        throw Exception('Login failed!');
      }
      if (!isLogin) {
        final imgUrl =
            await StorageManager.instance.uploadFile('user_image/${user.uid}.jpg', userImage!);

        await DatabaseManager.instance.addData('users', user.uid, {
          'username': username,
          'email': user.email,
          'userImage': imgUrl,
        });
      }
    } on PlatformException catch (e) {
      _onAuthError(e.message ?? 'An error occurred, please check your credentials!', ctx);
    } catch (e) {
      print(e);
      _onAuthError('Login failed!', ctx);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        onLogin: (email, password, ctx) => _authenticate(email, password, null, null, true, ctx),
        onSignup: (email, password, username, userImage, ctx) => _authenticate(
          email,
          password,
          username,
          userImage,
          false,
          ctx,
        ),
        isLoading: _isLoading,
      ),
    );
  }
}
