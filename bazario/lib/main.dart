// dart format width=80
import 'package:bazario/data/repositories/payment_provider.dart';
import 'package:bazario/data/repositories/shipping_provider.dart';
import 'package:bazario/user_features/checkout&payment/models/shipping_model.dart';
import 'package:bazario/user_features/home/models/cart_item.dart';
import 'package:bazario/user_features/home/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:bazario/app/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/repositories/home_provider.dart';
import 'firebase_options.dart';

/// The entry point of the Flutter application.
/// This function is asynchronous as it performs a number of initialization tasks
/// before the app can run.
void main() async {
  // Ensures that Flutter widgets are initialized before any other
  // Flutter-specific functions are called.
  WidgetsFlutterBinding.ensureInitialized();
  // Sets the publishable key for Stripe. This key is necessary to
  // perform payment operations.
  Stripe.publishableKey = 'your_stripe_publishable_key';

  // Initialize Firebase with the default options for the current platform.
  // This is a crucial step for using Firebase services like Firestore, Auth, etc.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize and open Hive, a local NoSQL database.
  await Hive.initFlutter();

  // Register adapters for custom classes so Hive knows how to read and write them.
  // This is important for storing complex objects locally.
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ShippingAddressAdapter());
  Hive.registerAdapter(ShippingTypeAdapter());

  // Open the necessary Hive boxes to store data.
  // 'cartBox' is likely for storing items in the shopping cart.
  // 'transactions' and 'saved_cards' are for payment-related data.
  await Hive.openBox<CartItem>('cartBox');
  await Hive.openBox('transactions');
  await Hive.openBox('saved_cards');

  // Once all initializations are complete, run the main application widget.
  runApp(const BazarioApp());
}

/// The root widget of the application.
/// It sets up the app's state management, theme, and routing.
class BazarioApp extends StatelessWidget {
  const BazarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider is used to provide multiple state management objects
    // to the widget tree.
    return MultiProvider(
      providers: [
        // HomeProvider manages the state for the home page.
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        // ShippingProvider manages state related to shipping options and addresses.
        ChangeNotifierProvider(create: (_) => ShippingProvider()),
        // PaymentProvider handles state for payment-related logic.
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      // MaterialApp.router is used with auto_route for declarative routing.
      child: MaterialApp.router(
        // Disables the debug banner in the top right corner.
        debugShowCheckedModeBanner: false,
        title: 'Bazario',
        // Defines the app's overall theme, including colors and fonts.
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        // Sets the router configuration, which defines all the app's routes.
        routerConfig: AppRouter().config(),
      ),
    );
  }
}
