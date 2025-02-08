import 'package:e_learning_app/core/theme/app_colors.dart';
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
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Student Messages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: DummyDataService.getTeacherChats('inst_1'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chatsByCourse = DummyDataService.getTeacherChatsByCourse('inst_1');

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chatsByCourse.length,
            itemBuilder: (context, index) {
              final courseId = chatsByCourse.keys.elementAt(index);
              final courseChats = chatsByCourse[courseId]!;
              final course = DummyDataService.getCourseById(courseId);

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      course.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${courseChats.length} messages',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    children: courseChats.map((chat) => _buildChatTile(chat)).toList(),
                  ),
                ),
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

    return InkWell(
      onTap: () => Get.to(() => ChatScreen(
        courseId: lastMessage.courseId,
        instructorId: lastMessage.receiverId,
        isTeacherView: true,
        studentName: studentProgress?.studentName,
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade100),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                studentProgress?.studentName.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentProgress?.studentName ?? 'Unknown Student',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatTimestamp(lastMessage.timestamp),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
