import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
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
    // Register HTTP client if not already registered
    if (!Get.isRegistered<http.Client>()) {
      Get.put(http.Client());
    }

    // Register data sources
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(secureStorage: const FlutterSecureStorage()),
    );

    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(client: Get.find<http.Client>()),
    );

    // Register repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
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
    Get.put<AuthController>(AuthController(), permanent: true);

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
