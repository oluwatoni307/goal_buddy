import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../task_model.dart';

class TaskProgressPage extends StatefulWidget {
  final TaskCompletionDto task;
  final Map<String, dynamic> progressData;

  const TaskProgressPage({
    Key? key,
    required this.task,
    required this.progressData,
  }) : super(key: key);

  @override
  State<TaskProgressPage> createState() => _TaskProgressPageState();
}

class _TaskProgressPageState extends State<TaskProgressPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rating = _parseRating(widget.progressData['rating'] ?? 0);
    final feedback = widget.progressData['feedback'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Minimal Header
            _buildHeader(),

            // Main Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeController,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),

                        // Rating Number
                        _buildRatingNumber(rating),
                        const SizedBox(height: 16),

                        // Status Badge
                        _buildStatusBadge(rating),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10,
                        ),

                        // Feedback - NOW THE HERO
                        _buildFeedbackSection(feedback),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Footer Actions
            _buildFooterActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'COMPLETION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: () => Get.offAllNamed('/home'),
            child: const Icon(Icons.home, size: 20, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingNumber(int rating) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$rating',
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w300,
              color: Colors.black,
              height: 1.0,
            ),
          ),
          TextSpan(
            text: '/10',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(int rating) {
    final statusData = _getStatusData(rating);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusData['bgColor'],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusData['borderColor'], width: 1.2),
      ),
      child: Text(
        statusData['label'],
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: statusData['textColor'],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFeedbackSection(String feedback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FEEDBACK',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Text(
            feedback.isEmpty ? 'No additional feedback provided' : feedback,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.8,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: SizedBox(
        width: double.infinity,
        child: _buildMinimalButton(
          label: 'Go to Home',
          onPressed: () => Get.offAllNamed('/home'),
          isPrimary: true,
        ),
      ),
    );
  }

  Widget _buildMinimalButton({
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.black87 : Colors.white,
          border: Border.all(
            color: isPrimary ? Colors.black87 : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isPrimary ? Colors.white : Colors.black87,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(int rating) {
    if (rating >= 9) {
      return {
        'label': 'EXCEPTIONAL',
        'textColor': const Color(0xFF0D7377),
        'bgColor': const Color(0xFFF0FDF9),
        'borderColor': const Color(0xFF0D7377),
      };
    } else if (rating >= 7) {
      return {
        'label': 'EXCELLENT',
        'textColor': const Color(0xFF2D5A3D),
        'bgColor': const Color(0xFFF5F9F7),
        'borderColor': const Color(0xFF2D5A3D),
      };
    } else if (rating >= 5) {
      return {
        'label': 'GOOD',
        'textColor': const Color(0xFF6B5B4D),
        'bgColor': const Color(0xFFFAF8F5),
        'borderColor': const Color(0xFF6B5B4D),
      };
    } else if (rating >= 3) {
      return {
        'label': 'FAIR',
        'textColor': const Color(0xFF8B6F47),
        'bgColor': const Color(0xFFFEF9F0),
        'borderColor': const Color(0xFF8B6F47),
      };
    } else {
      return {
        'label': 'NEEDS IMPROVEMENT',
        'textColor': const Color(0xFF8B3A3A),
        'bgColor': const Color(0xFFFDF5F5),
        'borderColor': const Color(0xFF8B3A3A),
      };
    }
  }

  int _parseRating(dynamic rating) {
    if (rating is int) return rating;
    if (rating is String) return int.tryParse(rating) ?? 0;
    return 0;
  }
}
