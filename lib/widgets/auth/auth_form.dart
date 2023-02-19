import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/string_extension.dart';
import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, BuildContext ctx) onLogin;
  final void Function(
    String email,
    String password,
    String username,
    File userImage,
    BuildContext ctx,
  ) onSignup;
  final bool isLoading;
  const AuthForm({
    super.key,
    required this.onLogin,
    required this.onSignup,
    required this.isLoading,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userEmailCtrl = TextEditingController();
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _userPasswordCtrl = TextEditingController();
  final TextEditingController _userConfirmPasswordCtrl = TextEditingController();
  bool _isLoginMode = true;
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLoginMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please pick an image.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          closeIconColor: Theme.of(context).colorScheme.onError,
          showCloseIcon: true,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState?.save();
      if (_isLoginMode) {
        widget.onLogin(
          _userEmailCtrl.text,
          _userPasswordCtrl.text,
          context,
        );
      } else {
        widget.onSignup(
          _userEmailCtrl.text,
          _userPasswordCtrl.text,
          _userNameCtrl.text,
          _userImageFile!,
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.topCenter,
        curve: Curves.easeInOut,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLoginMode)
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: UserImagePicker(
                          onImagePicked: _pickedImage,
                        ),
                      ),
                    TextFormField(
                      controller: _userEmailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.validEmail) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    if (!_isLoginMode)
                      TextFormField(
                        controller: _userNameCtrl,
                        decoration: const InputDecoration(labelText: 'Username'),
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                        keyboardType: TextInputType.name,
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters.';
                          }
                          return null;
                        },
                      ),
                    TextFormField(
                      controller: _userPasswordCtrl,
                      decoration: const InputDecoration(labelText: 'Password'),
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 7) {
                          return 'Please enter at least 7 characters.';
                        }
                        return null;
                      },
                    ),
                    if (!_isLoginMode)
                      TextFormField(
                        controller: _userConfirmPasswordCtrl,
                        decoration: const InputDecoration(labelText: 'Confirm Password'),
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value != _userPasswordCtrl.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: widget.isLoading ? null : _trySubmit,
                      child: Text(_isLoginMode ? 'Login' : 'Signup'),
                    ),
                    TextButton(
                      onPressed: widget.isLoading
                          ? null
                          : () {
                              setState(() {
                                _isLoginMode = !_isLoginMode;
                              });
                            },
                      child:
                          Text(_isLoginMode ? 'Create new account' : 'I already have an account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
