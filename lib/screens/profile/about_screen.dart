import 'package:flutter/material.dart';
import 'package:uzii_shop/theme/app_theme.dart';
import 'package:uzii_shop/widgets/uzii_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('About UziiShop')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const UziiLogo(size: 80, showText: false),
              const SizedBox(height: 20),
              const Text('UziiShop',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 24,
                      fontWeight: FontWeight.w700, color: AppColors.primary)),
              const SizedBox(height: 8),
              const Text('Version 1.0.0',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 13,
                      color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              const Text(
                'UziiShop is a modern e-commerce app built with Flutter. '
                    'Shop smart, live better.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Roboto', fontSize: 14,
                    color: AppColors.textSecondary, height: 1.6),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Built by Uziii Khan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                        fontWeight: FontWeight.w500, color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}