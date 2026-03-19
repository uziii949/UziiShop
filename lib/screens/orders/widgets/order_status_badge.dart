import 'package:flutter/material.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  Color get _bgColor {
    switch (status.toLowerCase()) {
      case 'placed':
        return const Color(0xFF6C5DD3).withValues(alpha: 0.12);
      case 'processing':
        return const Color(0xFFFF9800).withValues(alpha: 0.12);
      case 'shipped':
        return const Color(0xFF2196F3).withValues(alpha: 0.12);
      case 'delivered':
        return const Color(0xFF4CAF50).withValues(alpha: 0.12);
      default:
        return const Color(0xFF666666).withValues(alpha: 0.12);
    }
  }

  Color get _textColor {
    switch (status.toLowerCase()) {
      case 'placed':
        return const Color(0xFF6C5DD3);
      case 'processing':
        return const Color(0xFFFF9800);
      case 'shipped':
        return const Color(0xFF2196F3);
      case 'delivered':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF666666);
    }
  }

  IconData get _icon {
    switch (status.toLowerCase()) {
      case 'placed':
        return Icons.check_circle_outline;
      case 'processing':
        return Icons.autorenew;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.done_all;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: _textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}