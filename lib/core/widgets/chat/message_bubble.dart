import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userName;
  final bool isMe;
  final ImageProvider? userImage;
  final bool isImage;
  const MessageBubble({
    super.key,
    required this.message,
    required this.userName,
    required this.isMe,
    required this.userImage,
    this.isImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cts) {
        return Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isMe ? Colors.grey.shade300 : Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
                      bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: cts.maxWidth * 0.45,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    right: 8,
                    left: isMe ? 8 : (isImage ? 55 : 8),
                  ),
                  child: Column(
                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMe ? 'You' : userName,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: isMe ? Colors.black : Theme.of(context).colorScheme.onSecondary,
                        ),
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          color: isMe ? Colors.black : Theme.of(context).colorScheme.onSecondary,
                        ),
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                    ],
                  ),
                ),
                if (!isMe && isImage)
                  Positioned(
                    top: 4,
                    left: 8,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: userImage,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
