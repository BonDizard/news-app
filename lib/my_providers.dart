import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/providers/user_provider.dart';
import 'features/auth/repository/auth_repository.dart';

class Providers {
  static final authRepositoryProvider = Provider<AuthRepository>(
    create: (_) => AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );

  static final authControllerProvider = ChangeNotifierProvider<AuthController>(
    create: (context) => AuthController(
      authRepository: authRepositoryProvider,
    ),
  );

  static final userProvider = ChangeNotifierProvider<UserProvider>(
    create: (_) => UserProvider(),
  );

  static final authStateChangeProvider = StreamProvider<User?>(
    create: (context) => authControllerProvider.authStateChange,
    initialData: null, // Provide an initial value for the stream
  );
}
