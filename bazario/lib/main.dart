// dart format width=80
import 'package:bazario/data/repositories/shipping_provider.dart';
import 'package:bazario/user_features/checkout&payment/models/shipping_model.dart';
import 'package:bazario/user_features/home/models/cart_item.dart';
import 'package:bazario/user_features/home/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:bazario/app/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/repositories/home_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize and open Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ShippingAddressAdapter());
  Hive.registerAdapter(ShippingTypeAdapter());
  await Hive.openBox<CartItem>('cartBox');

  runApp(const BazarioApp());
}

class BazarioApp extends StatelessWidget {
  const BazarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // You no longer need to provide CartService with MultiProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_)=>ShippingProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Bazario',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        routerConfig: AppRouter().config(),
      ),
    );
  }
}