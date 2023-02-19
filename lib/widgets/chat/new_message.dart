import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/init/database/database_manager.dart';
import '../../core/init/services/authentication/authentication_manager.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _enteredMessageController = TextEditingController();
  var _enteredMessage = '';

  void _userNotFoundMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User not found!'),
      ),
    );
  }

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();

    final user = AuthenticationManager.instance.currentUser;
    if (user == null) {
      _userNotFoundMessage();
      return;
    }

    final userData = await DatabaseManager.instance.getDataById('users', user.uid);
    if (userData == null) {
      _userNotFoundMessage();
      return;
    }

    DatabaseManager.instance.addData('chat', null, {
      'text': _enteredMessage,
      'userId': AuthenticationManager.instance.currentUser!.uid,
      'createdAt': Timestamp.now(),
      'username': userData['username'],
      'userImage': userData['userImage'],
    });
    _enteredMessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _enteredMessageController,
              maxLines: null,
              scrollPhysics: const BouncingScrollPhysics(),
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(hintText: 'Send a message...'),
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
            onPressed: _enteredMessage.isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
