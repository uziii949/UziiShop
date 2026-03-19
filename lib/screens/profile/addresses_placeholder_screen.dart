import 'package:flutter/material.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class AddressesPlaceholderScreen extends StatelessWidget {
  const AddressesPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on_outlined,
                    size: 60, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text('Saved Addresses',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 20,
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              const Text('Address management will be expanded in a future version.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 14,
                      color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}