import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ourpass/config/constants.dart';
import 'package:ourpass/config/theme.dart';
import 'package:ourpass/core/model/user.dart';
import 'package:ourpass/core/presentation/onboarding.dart';
import 'package:ourpass/core/utils/async_value.dart';
import 'package:ourpass/feature/authentication/provider/auth_provider.dart';
import 'package:ourpass/feature/weight_tracker/presentation/home.dart';
import 'package:ourpass/feature/weight_tracker/provider/weight_provider.dart';
import 'package:ourpass/config/firebase_options.dart';
import 'package:ourpass/injector.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initApp();
  runApp(const OurpassApp());
}

class OurpassApp extends StatelessWidget {
  const OurpassApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (context) => getIt()),
        ChangeNotifierProvider<WeightDataProvider>(create: (context) => getIt())
      ],
      child: Selector<AuthProvider, AsyncValue<UserModel>>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.defaultTheme,
            title: AppStrings.kTitle,
            home: value.when(
              loading: (_) => const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              done: (_) => const HomePage(),
              error: (_) => const OnboardingPage(),
            ),
          );
        },
        selector: (context, auth) => auth.asyncValueOfUser,
      ),
    );
  }
}
