import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:ourpass/feature/authentication/provider/auth_provider.dart';
import 'package:ourpass/feature/authentication/repository/auth_repository.dart';
import 'package:ourpass/feature/weight_tracker/provider/weight_provider.dart';
import 'package:ourpass/feature/weight_tracker/repository/weight_repository.dart';

final getIt = GetIt.I;

Future<void> initApp() async {
  final injectableModules = InjectableFactory.instance;

  // @repositories
  getIt.registerSingleton<IAuthRepository>(
    AuthRepository(injectableModules.auth),
  );
  getIt.registerSingleton<IWeightRepository>(
    WeightRepository(injectableModules.firestore),
  );

  // @providers
  getIt.registerSingleton<AuthProvider>(
    AuthProvider(
      authRepository: getIt(),
    )..getUser(),
  );

  getIt.registerSingleton<WeightDataProvider>(
    WeightDataProvider(
      weightRepository: getIt(),
    ),
  );
}

abstract class InjectableModules {
  FirebaseAuth get auth;
  FirebaseFirestore get firestore;
}

/// injectable modules in production environment
class InjectableModulesProd implements InjectableModules {
  @override
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  FirebaseFirestore firestore = FirebaseFirestore.instance;
}

/// injectable modules in development environment
class InjectableModulesDebug implements InjectableModules {
  @override
  FirebaseAuth auth = FirebaseAuth.instance..useAuthEmulator('localhost', 9099);
  @override
  FirebaseFirestore firestore = FirebaseFirestore.instance
    ..useFirestoreEmulator('localhost', 8080);
}

class InjectableFactory {
  static InjectableModules get instance {
    return EnvironmentConfig.isDebug
        ? InjectableModulesDebug()
        : InjectableModulesProd();
  }
}

class EnvironmentConfig {
  static const String production = 'production';
  static const String development = 'development';
  static const env = String.fromEnvironment('env', defaultValue: development);
  static const bool isDebug = env == development;
}
