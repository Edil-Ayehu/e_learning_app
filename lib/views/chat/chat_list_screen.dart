import 'package:e_learning_app/models/chat_message.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';
import 'package:e_learning_app/views/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Messages'),
        elevation: 0,
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: DummyDataService.getTeacherChats('inst_1'), // Replace with actual instructor ID
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final chats = snapshot.data!;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return _buildChatTile(chat);
            },
          );
        },
      ),
    );
  }

  Widget _buildChatTile(ChatMessage lastMessage) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text('Student Name'), // Replace with actual student name
      subtitle: Text(lastMessage.message),
      trailing: Text(
        _formatTimestamp(lastMessage.timestamp),
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: () => Get.to(() => ChatScreen(
        courseId: lastMessage.courseId,
        instructorId: lastMessage.receiverId,
      )),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    // Implement timestamp formatting logic
    return '2m ago';
  }
}
