// dart format width=80
import 'package:bazario/user_features/home/models/cart_item.dart' hide CartItem;
import 'package:bazario/user_features/home/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bazario/app/app_router.dart';
import 'data/repositories/home_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hive_ce_flutter/hive_flutter.dart'; // Import Hive for Flutter

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open a box
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(CartItemAdapter());

  // Open the cart box
  await Hive.openBox<CartItem>('cartBox');


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(BazarioApp());
}

class BazarioApp extends StatelessWidget {
  BazarioApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Bazario',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}