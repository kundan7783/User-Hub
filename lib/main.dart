import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_hub/repositories/auth_repository.dart';
import 'package:user_hub/repositories/user_repository.dart';
import 'package:user_hub/services/auth_service.dart';
import 'package:user_hub/services/api_service.dart';
import 'package:user_hub/viewmodels/auth_viewmodel.dart';
import 'package:user_hub/viewmodels/user_viewmodel.dart';
import 'package:user_hub/views/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        /// AUTH
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider<AuthViewmodel>(
          create: (context) => AuthViewmodel(
            context.read<AuthRepository>(),
          ),
        ),

        /// USER API
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        Provider<UserRepository>(
          create: (context) => UserRepository(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider<UserViewModel>(
          create: (context) => UserViewModel(
            context.read<UserRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}