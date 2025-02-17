import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/services/dummy_data_service.dart';
import 'package:e_learning_app/views/courses/payment_screen/widgets/payment_success_dialog.dart';

class PaymentService {
  static void processPayment({
    required GlobalKey<FormState> formKey,
    required String courseId,
  }) {
    if (formKey.currentState!.validate()) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Simulate payment processing
      Future.delayed(const Duration(seconds: 2), () {
        Get.back(); // Close loading dialog

        // Add the course to purchased courses
        DummyDataService.addPurchasedCourse(courseId);

        Get.dialog(
          const PaymentSuccessDialog(),
          barrierDismissible: false,
        );
      });
    }
  }
}
