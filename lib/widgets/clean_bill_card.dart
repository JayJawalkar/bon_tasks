import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CleanBillCard extends StatelessWidget {
  final String amount;
  final String date;
  final String status;
  final String merchant;
  final String category;
  final Color statusColor;
  final bool isTablet;

  const CleanBillCard({
    required this.amount,
    required this.date,
    required this.status,
    required this.merchant,
    required this.category,
    required this.statusColor,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isTablet ? 60 : 56,
            height: isTablet ? 60 : 56,
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: _getCategoryColor(category).withOpacity(0.2),
              ),
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: _getCategoryColor(category),
              size: isTablet ? 28 : 24,
            ),
          ),
          SizedBox(width: isTablet ? 20 : 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        merchant,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: isTablet ? 18 : 16,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 16 : 12),
                    Text(
                      amount,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 18 : 16,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 10 : 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: isTablet ? 15 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 14 : 12,
                        vertical: isTablet ? 6 : 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: isTablet ? 13 : 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Shopping':
        return Iconsax.bag;
      case 'Entertainment':
        return Iconsax.video_play;
      case 'Utilities':
        return Iconsax.flash;
      default:
        return Iconsax.card;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Shopping':
        return const Color(0xFF8B5CF6);
      case 'Entertainment':
        return const Color(0xFFEF4444);
      case 'Utilities':
        return const Color(0xFF06B6D4);
      default:
        return const Color(0xFF64748B);
    }
  }
}
