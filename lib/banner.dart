import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersistentFloatingBanner extends StatefulWidget {
  final RxBool isVisible;
  final RxString message;
  final String bannerType; // 'success', 'error', 'info'
  final VoidCallback? onDismiss;

  const PersistentFloatingBanner({
    super.key,
    required this.isVisible,
    required this.message,
    this.bannerType = 'info',
    this.onDismiss,
  });

  @override
  State<PersistentFloatingBanner> createState() =>
      _PersistentFloatingBannerState();
}

class _PersistentFloatingBannerState extends State<PersistentFloatingBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -2), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(PersistentFloatingBanner oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible.value && !_animationController.isAnimating) {
      _animationController.forward();
    } else if (!widget.isVisible.value && _animationController.isAnimating) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green.withOpacity(0.95);
      case 'error':
        return Colors.red.withOpacity(0.95);
      case 'info':
        return Colors.blue.withOpacity(0.95);
      default:
        return Colors.grey.withOpacity(0.95);
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle_outline;
      case 'error':
        return Icons.error_outline;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = _getBackgroundColor(widget.bannerType);
    final icon = _getIcon(widget.bannerType);
    const textColor = Colors.white;

    return Obx(() {
      if (!widget.isVisible.value) {
        return const SizedBox.shrink();
      }

      return SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: backgroundColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: textColor, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.message.value,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            _animationController.reverse().then((_) {
                              if (mounted) {
                                widget.isVisible(false);
                                widget.onDismiss?.call();
                              }
                            });
                          },
                          child: Icon(Icons.close, color: textColor, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
