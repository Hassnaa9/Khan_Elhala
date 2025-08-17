// dart format width=80
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:bazario/app/app_router.dart';
import 'data/repositories/home_provider.dart'; // Make sure this is the correct path to your HomeProvider

void main() {
  runApp(BazarioApp());
}

class BazarioApp extends StatelessWidget {
  BazarioApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    // Wrap the entire app with MultiProvider to make the HomeProvider
    // accessible throughout the entire app's widget tree.
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
        routerConfig: _appRouter.config(), // Provide the router configuration
      ),
    );
  }
}