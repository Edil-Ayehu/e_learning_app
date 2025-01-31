import 'package:cloud_firestore/cloud_firestore.dart';

class QuizAttempt {
  final String id;
  final String quizId;
  final String userId;
  final Map<String, String> answers; // questionId: selectedOptionId
  final int score;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int timeSpent; // in seconds

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.answers,
    required this.score,
    required this.startedAt,
    this.completedAt,
    required this.timeSpent,
  });

  factory QuizAttempt.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizAttempt(
      id: doc.id,
      quizId: data['quizId'] ?? '',
      userId: data['userId'] ?? '',
      answers: Map<String, String>.from(data['answers'] ?? {}),
      score: data['score'] ?? 0,
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      timeSpent: data['timeSpent'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quizId': quizId,
      'userId': userId,
      'answers': answers,
      'score': score,
      'startedAt': Timestamp.fromDate(startedAt),
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'timeSpent': timeSpent,
    };
  }
}
