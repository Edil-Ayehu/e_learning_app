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
        stream: DummyDataService.getTeacherChats('inst_1'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final chatsByCourse = DummyDataService.getTeacherChatsByCourse('inst_1');
          
          return ListView.builder(
            itemCount: chatsByCourse.length,
            itemBuilder: (context, index) {
              final courseId = chatsByCourse.keys.elementAt(index);
              final courseChats = chatsByCourse[courseId]!;
              final course = DummyDataService.getCourseById(courseId);
              
              return ExpansionTile(
                title: Text(course.title),
                subtitle: Text('${courseChats.length} messages'),
                children: courseChats.map((chat) => _buildChatTile(chat)).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildChatTile(ChatMessage lastMessage) {
    final studentProgress = DummyDataService.studentProgress['inst_1']?.firstWhere(
      (progress) => progress.studentId == lastMessage.senderId,
      orElse: () => StudentProgress(
        studentId: lastMessage.senderId,
        studentName: 'Unknown Student',
        courseId: lastMessage.courseId,
        courseName: 'Unknown Course',
        progress: 0,
        lastActive: DateTime.now(),
        quizScores: [],
        completedLessons: 0,
        totalLessons: 0,
        averageTimePerLesson: 0,
      ),
    );

    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(studentProgress?.studentName ?? 'Unknown Student'),
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
