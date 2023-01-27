import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../widgets/chat/new_message.dart';
import '../services/notification_service.dart';
import '/widgets/chat/messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen via _handleMessage method.
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final fcm = FirebaseMessaging.instance;
    fcm.requestPermission();
    fcm.subscribeToTopic('chat');

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint('Listen onMessage: ${FirebaseMessaging.onMessage.listen}');
        debugPrint('Message data: ${message.data}');
        if (message.notification != null) {
          debugPrint(message.notification!.title);
          debugPrint(message.notification!.body);
          NotificationService.createAndDisplayNotification(message);
        }
      },
    );
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text(logout),
              ),
            ],
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 0) {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
