import 'package:flutter/material.dart';

import '../core/base/widget/base_screen_widget.dart';
import '../core/init/services/authentication/authentication_manager.dart';
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

enum ChatScreenDropdownMenuItems { logout }

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      checkAuth: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat Screen'),
          actions: [
            DropdownButton<ChatScreenDropdownMenuItems>(
              underline: const SizedBox(),
              dropdownColor: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              items: [
                DropdownMenuItem(
                  value: ChatScreenDropdownMenuItems.logout,
                  child: Row(
                    children: [
                      const Icon(Icons.exit_to_app),
                      const SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == ChatScreenDropdownMenuItems.logout) {
                  AuthenticationManager.instance.signOut();
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const Expanded(
              child: Messages(),
            ),
            Container(
              constraints: const BoxConstraints(maxHeight: 75),
              child: const NewMessage(),
            ),
          ],
        ),
      ),
    );
  }
}
