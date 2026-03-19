import 'package:flutter/material.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _FaqItem(
            question: 'How do I track my order?',
            answer: 'Go to My Orders section to view your order status and details.',
          ),
          _FaqItem(
            question: 'How do I return a product?',
            answer: 'Contact us at support@uziishop.com within 7 days of delivery.',
          ),
          _FaqItem(
            question: 'What payment methods are accepted?',
            answer: 'We accept Cash on Delivery, Credit/Debit Cards, and mobile wallets.',
          ),
          _FaqItem(
            question: 'How long does delivery take?',
            answer: 'Standard: 3-5 days, Express: 1-2 days, Same Day available in select areas.',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Contact Us', style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                _ContactRow(icon: Icons.email_outlined, text: 'support@uziishop.com'),
                const SizedBox(height: 8),
                _ContactRow(icon: Icons.phone_outlined, text: '+92 300 0000000'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ExpansionTile(
        title: Text(widget.question,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13,
                fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        onExpansionChanged: (v) => setState(() => _expanded = v),
        trailing: Icon(_expanded ? Icons.remove : Icons.add,
            color: AppColors.primary, size: 20),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(widget.answer,
                style: const TextStyle(fontFamily: 'Roboto', fontSize: 13,
                    color: AppColors.textSecondary, height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontFamily: 'Roboto',
            fontSize: 13, color: AppColors.textSecondary)),
      ],
    );
  }
}