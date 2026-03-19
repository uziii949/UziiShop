import 'package:flutter/material.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class UziiLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const UziiLogo({super.key, this.size = 100, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: size * 0.25,
                offset: Offset(0, size * 0.1),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size * 0.55, size * 0.55),
                painter: _ShoppingBagPainter(),
              ),
              Positioned(
                bottom: size * 0.18,
                child: Text(
                  'U',
                  style: TextStyle(
                    fontSize: size * 0.38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.18),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Uzii',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size * 0.30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                TextSpan(
                  text: 'Shop',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: size * 0.30,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size * 0.06),
          Text(
            'Shop Smart. Live Better.',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: size * 0.12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _ShoppingBagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final bagPath = Path()
      ..moveTo(w * 0.10, h * 0.38)
      ..lineTo(w * 0.05, h * 1.0)
      ..lineTo(w * 0.95, h * 1.0)
      ..lineTo(w * 0.90, h * 0.38)
      ..close();
    canvas.drawPath(bagPath, paint);

    final handlePaint = Paint()
      ..color = Colors.white.withOpacity(0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round;

    final handlePath = Path()
      ..moveTo(w * 0.30, h * 0.38)
      ..cubicTo(w * 0.30, h * 0.0, w * 0.70, h * 0.0, w * 0.70, h * 0.38);
    canvas.drawPath(handlePath, handlePaint);
  }

  @override
  bool shouldRepaint(_ShoppingBagPainter oldDelegate) => false;
}