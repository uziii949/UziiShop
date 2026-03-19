import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';
import 'package:uzii_shop/providers/auth_provider.dart';
import 'package:uzii_shop/providers/product_provider.dart';
import 'package:uzii_shop/providers/cart_provider.dart';
import 'package:uzii_shop/providers/wishlist_provider.dart';
import 'package:uzii_shop/providers/checkout_provider.dart';
import 'package:uzii_shop/providers/orders_provider.dart';
import 'package:uzii_shop/providers/profile_provider.dart';
import 'package:uzii_shop/screens/splash_screen.dart';
import 'package:uzii_shop/screens/home/home_screen.dart';
import 'package:uzii_shop/screens/auth/login_screen.dart';
import 'package:uzii_shop/screens/auth/signup_screen.dart';
import 'package:uzii_shop/screens/cart/cart_screen.dart';
import 'package:uzii_shop/screens/checkout/checkout_screen.dart';
import 'package:uzii_shop/screens/orders/orders_history_screen.dart';
import 'package:uzii_shop/providers/search_provider.dart';
import 'package:uzii_shop/providers/notification_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final cartProvider = CartProvider();
  await cartProvider.loadCart();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider.value(value: cartProvider),
        ChangeNotifierProvider(create: (_) => WishlistProvider()..loadWishlist()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const UziiShopApp(),
    ),
  );
}

class UziiShopApp extends StatelessWidget {
  const UziiShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UziiShop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
        '/cart': (_) => const CartScreen(),
        '/checkout': (_) => const CheckoutScreen(),
        '/orders': (_) => const OrdersHistoryScreen(),
      },
    );
  }
}