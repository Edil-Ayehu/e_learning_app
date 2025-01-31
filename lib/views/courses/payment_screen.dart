import 'package:e_learning_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  final double price;

  const PaymentScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.price,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  final _errorStyle = const TextStyle(color: Colors.red);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderSummary(theme),
              const SizedBox(height: 24),
              Text(
                'Payment Method',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildCardNumberField(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildExpiryField()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildCVVField()),
                ],
              ),
              const SizedBox(height: 16),
              _buildNameField(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Pay \$${widget.price}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.courseName,
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                '\$${widget.price}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardNumberField() {
    return TextFormField(
      controller: _cardNumberController,
      keyboardType: TextInputType.number,
      decoration: _buildInputDecoration(
        label: 'Card Number',
        hint: '1234 5678 9012 3456',
        icon: Icons.credit_card,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter card number';
        }
        if (value.length < 16) {
          return 'Invalid card number';
        }
        return null;
      },
      maxLength: 16,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
    );
  }

  Widget _buildExpiryField() {
    return TextFormField(
      controller: _expiryController,
      keyboardType: TextInputType.datetime,
      decoration: _buildInputDecoration(
        label: 'Expiry Date',
        hint: 'MM/YY',
        icon: Icons.calendar_today,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter expiry date';
        }
        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
          return 'Use format MM/YY';
        }
        return null;
      },
      maxLength: 5,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
      onChanged: (value) {
        if (value.length == 2 && !value.contains('/')) {
          _expiryController.text = '$value/';
          _expiryController.selection = TextSelection.fromPosition(
            TextPosition(offset: _expiryController.text.length),
          );
        }
      },
    );
  }

  Widget _buildCVVField() {
    return TextFormField(
      controller: _cvvController,
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: _buildInputDecoration(
        label: 'CVV',
        hint: '123',
        icon: Icons.security,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter CVV';
        }
        if (value.length < 3) {
          return 'Invalid CVV';
        }
        return null;
      },
      maxLength: 3,
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          null,
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      decoration: _buildInputDecoration(
        label: 'Cardholder Name',
        hint: 'John Doe',
        icon: Icons.person,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter cardholder name';
        }
        if (value.split(' ').length < 2) {
          return 'Please enter full name';
        }
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      errorStyle: _errorStyle,
    );
  }

  // Add form field widgets and payment processing logic here
  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Simulate payment processing
      Future.delayed(const Duration(seconds: 2), () {
        Get.back(); // Close loading dialog
        Get.dialog(
          _buildSuccessDialog(),
          barrierDismissible: false,
        );
      });
    }
  }

  Widget _buildSuccessDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Payment Successful!',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You can now access the course content',
              style: Get.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                  // Navigate to course content
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Start Learning'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
