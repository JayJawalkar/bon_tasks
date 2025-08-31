import 'package:flutter/material.dart';

class CleanBrandOption extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String discount;
  final Color color;
  final String? badge;
  final bool isTablet;
  final VoidCallback onTap;

  const CleanBrandOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.discount,
    required this.color,
    this.badge,
    required this.isTablet,
    required this.onTap,
  });

  @override
  State<CleanBrandOption> createState() => _CleanBrandOptionState();
}

class _CleanBrandOptionState extends State<CleanBrandOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _hoverController.forward(),
      onTapUp: (_) {
        _hoverController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(widget.isTablet ? 24 : 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.isTablet ? 20 : 16),
                border: Border.all(
                  color: widget.color.withOpacity(0.1),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(
                      0.08 * _elevationAnimation.value,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: widget.isTablet ? 64 : 56,
                    height: widget.isTablet ? 64 : 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withOpacity(0.1),
                          widget.color.withOpacity(0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: widget.color.withOpacity(0.2)),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: widget.isTablet ? 28 : 24,
                    ),
                  ),
                  SizedBox(width: widget.isTablet ? 20 : 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: widget.isTablet ? 18 : 16,
                                  color: const Color(0xFF0F172A),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            if (widget.badge != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.color,
                                      widget.color.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  widget.badge!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widget.isTablet ? 11 : 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: widget.isTablet ? 8 : 6),

                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontSize: widget.isTablet ? 15 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: widget.isTablet ? 6 : 4),

                        Text(
                          widget.discount,
                          style: TextStyle(
                            color: widget.color,
                            fontSize: widget.isTablet ? 14 : 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: widget.isTablet ? 36 : 32,
                    height: widget.isTablet ? 36 : 32,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: widget.color,
                      size: widget.isTablet ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
