import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../core/init/database/database_manager.dart';
import '../../core/init/services/authentication/authentication_manager.dart';
import '../../core/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    String? nextUserId;
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: DatabaseManager.instance.streamData('chat', orderField: 'createdAt'),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final data = snapshot.data ?? [];
        final user = AuthenticationManager.instance.currentUser;
        if (user == null) {
          AuthenticationManager.instance.signOut();
          return const Center(
            child: Text('User not found!'),
          );
        }
        return AnimationLimiter(
          child: ListView.builder(
            reverse: true,
            itemCount: data.length,
            itemBuilder: (ctx2, index) {
              if (index != data.length - 1) {
                nextUserId = data[index + 1]['userId'];
              } else {
                nextUserId = null;
              }
              return AnimationConfiguration.staggeredList(
                delay: const Duration(milliseconds: 100),
                position: index,
                child: SlideAnimation(
                  curve: Curves.easeInOutCubic,
                  horizontalOffset: 0,
                  verticalOffset: 10,
                  child: FadeInAnimation(
                    curve: Curves.easeInOutCubic,
                    child: MessageBubble(
                      key: ValueKey(data[index]['id']),
                      message: data[index]['text'],
                      userName: data[index]['username'],
                      isMe:
                          data[index]['userId'] == AuthenticationManager.instance.currentUser!.uid,
                      userImage: CachedNetworkImageProvider(
                        data[index]['userImage'],
                      ),
                      isImage: nextUserId == null || nextUserId != data[index]['userId'],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
