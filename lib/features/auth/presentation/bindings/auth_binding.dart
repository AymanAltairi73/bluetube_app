import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';
import '../../domain/usecases/social_login_use_case.dart';
import '../controllers/auth_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/signup_controller.dart';

/// Binding for authentication screens
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Register data sources
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(secureStorage: const FlutterSecureStorage()),
    );

    // Register AuthService
    Get.lazyPut<AuthService>(
      () => AuthService(),
    );

    // Register repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        authService: Get.find<AuthService>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
      ),
    );

    // Register use cases
    Get.lazyPut(
      () => LoginUseCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut(
      () => SignupUseCase(Get.find<AuthRepository>()),
    );

    Get.lazyPut(
      () => SocialLoginUseCase(Get.find<AuthRepository>()),
    );

    // Register controllers
    Get.put<AuthController>(
      AuthController(authRepository: Get.find<AuthRepository>()),
      permanent: true,
    );

    Get.lazyPut(
      () => LoginController(loginUseCase: Get.find<LoginUseCase>()),
    );

    Get.lazyPut(
      () => SignupController(
        signupUseCase: Get.find<SignupUseCase>(),
        socialLoginUseCase: Get.find<SocialLoginUseCase>(),
      ),
    );
  }
}
