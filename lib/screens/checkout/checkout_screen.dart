import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uzii_shop/providers/cart_provider.dart';
import 'package:uzii_shop/providers/checkout_provider.dart';
import 'package:uzii_shop/models/shipping_address_model.dart';
import 'package:uzii_shop/theme/app_theme.dart';
import 'package:uzii_shop/screens/checkout/widgets/delivery_method_selector.dart';
import 'package:uzii_shop/screens/checkout/widgets/payment_method_selector.dart';
import 'package:uzii_shop/screens/checkout/widgets/promo_code_section.dart';
import 'package:uzii_shop/screens/checkout/widgets/checkout_summary_card.dart';
import 'package:uzii_shop/screens/checkout/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(
      text: user?.displayName ?? '',
    );
    _phoneController = TextEditingController();
    _address1Controller = TextEditingController();
    _address2Controller = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _postalController = TextEditingController();
    _countryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    if (cart.itemCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final address = ShippingAddress(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address1: _address1Controller.text.trim(),
      address2: _address2Controller.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postalCode: _postalController.text.trim(),
      country: _countryController.text.trim(),
    );

    final checkout = context.read<CheckoutProvider>();
    final success = await checkout.placeOrder(
      address: address,
      cartItems: cart.items.values.toList(),
      subtotal: cart.subtotal,
    );

    if (success && mounted) {
      cart.clearCart();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: checkout.lastOrder!),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to place order. Try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Checkout')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Address
                  _SectionTitle(title: 'Shipping Address'),
                  const SizedBox(height: 12),
                  _AddressForm(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    address1Controller: _address1Controller,
                    address2Controller: _address2Controller,
                    cityController: _cityController,
                    stateController: _stateController,
                    postalController: _postalController,
                    countryController: _countryController,
                  ),
                  const SizedBox(height: 24),

                  // Delivery Method
                  _SectionTitle(title: 'Delivery Method'),
                  const SizedBox(height: 12),
                  const DeliveryMethodSelector(),
                  const SizedBox(height: 24),

                  // Payment Method
                  _SectionTitle(title: 'Payment Method'),
                  const SizedBox(height: 12),
                  const PaymentMethodSelector(),
                  const SizedBox(height: 24),

                  // Promo Code
                  _SectionTitle(title: 'Promo Code'),
                  const SizedBox(height: 12),
                  const PromoCodeSection(),
                  const SizedBox(height: 24),

                  // Order Summary
                  _SectionTitle(title: 'Order Summary'),
                  const SizedBox(height: 12),
                  const CheckoutSummaryCard(),
                ],
              ),
            ),
          ),

          // Sticky Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '\$${checkout.getTotal(cart.subtotal).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: checkout.isLoading ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: checkout.isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : const Text(
                        'Place Order',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Title ──────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ── Address Form ───────────────────────────────
class _AddressForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController address1Controller;
  final TextEditingController address2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalController;
  final TextEditingController countryController;

  const _AddressForm({
    required this.nameController,
    required this.phoneController,
    required this.address1Controller,
    required this.address2Controller,
    required this.cityController,
    required this.stateController,
    required this.postalController,
    required this.countryController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _FormField(
            controller: nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            validator: (v) =>
            v!.trim().isEmpty ? 'Full name is required' : null,
          ),
          const SizedBox(height: 12),
          _FormField(
            controller: phoneController,
            label: 'Phone Number',
            hint: '+92 300 0000000',
            keyboardType: TextInputType.phone,
            validator: (v) =>
            v!.trim().isEmpty ? 'Phone number is required' : null,
          ),
          const SizedBox(height: 12),
          _FormField(
            controller: address1Controller,
            label: 'Address Line 1',
            hint: 'Street address, P.O. box',
            validator: (v) =>
            v!.trim().isEmpty ? 'Address is required' : null,
          ),
          const SizedBox(height: 12),
          _FormField(
            controller: address2Controller,
            label: 'Address Line 2 (Optional)',
            hint: 'Apartment, suite, unit',
            isRequired: false,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FormField(
                  controller: cityController,
                  label: 'City',
                  hint: 'Lahore',
                  validator: (v) =>
                  v!.trim().isEmpty ? 'City is required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormField(
                  controller: stateController,
                  label: 'State',
                  hint: 'Punjab',
                  validator: (v) =>
                  v!.trim().isEmpty ? 'State is required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FormField(
                  controller: postalController,
                  label: 'Postal Code',
                  hint: '54000',
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                  v!.trim().isEmpty ? 'Postal code required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormField(
                  controller: countryController,
                  label: 'Country',
                  hint: 'Pakistan',
                  validator: (v) =>
                  v!.trim().isEmpty ? 'Country is required' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool isRequired;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}