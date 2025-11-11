// features/profile/profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goal_buddy/navBar.dart';
import 'profile_controller.dart';
import 'profile_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      bottomNavigationBar: NavBar(currentIndex: 4),

      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.error.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Profile content
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildUserInfoSection(controller),
                const SizedBox(height: 32),
                _buildStatsSection(controller),
                const SizedBox(height: 32),
                _buildSignOutButton(controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// User info section with name, email, and badge
  Widget _buildUserInfoSection(ProfileController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.grey[300],
              child: Text(
                controller.getDisplayName()[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              controller.getDisplayName(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              controller.currentUser.value?.email ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Badge
            if (controller.stats.value != null)
              _buildBadge(controller.stats.value!.badgeType),
          ],
        ),
      ),
    );
  }

  /// Badge widget
  Widget _buildBadge(BadgeType badgeType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Color(badgeType.color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(badgeType.color), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(badgeType.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(
            badgeType.displayName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(badgeType.color),
            ),
          ),
        ],
      ),
    );
  }

  /// Stats section showing active and completed goals
  Widget _buildStatsSection(ProfileController controller) {
    if (controller.stats.value == null) {
      return const SizedBox.shrink();
    }

    final stats = controller.stats.value!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Goal Statistics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Active Goals
            _buildStatRow(
              icon: Icons.trending_up,
              label: 'Active Goals',
              value: stats.activeGoals.toString(),
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // Completed Goals
            _buildStatRow(
              icon: Icons.check_circle,
              label: 'Completed Goals',
              value: stats.completedGoals.toString(),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  /// Single stat row
  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Sign out button
  Widget _buildSignOutButton(ProfileController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          // Show confirmation dialog
          final confirmed = await Get.dialog<bool>(
            AlertDialog(
              title: const Text('Sign Out'),
              content: const Text('Are you sure you want to sign out?'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            await controller.handleLogout();
          }
        },
        icon: const Icon(Icons.logout),
        label: const Text('Sign Out'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
