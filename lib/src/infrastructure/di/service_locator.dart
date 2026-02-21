import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:traditional_saju/src/application/ports/auth/auth_port.dart';
import 'package:traditional_saju/src/application/ports/saju/saju_port.dart';
import 'package:traditional_saju/src/application/ports/user/user_port.dart';
import 'package:traditional_saju/src/application/use_cases/auth/check_auth_status_use_case.dart';
import 'package:traditional_saju/src/application/use_cases/auth/login_use_case.dart';
import 'package:traditional_saju/src/application/use_cases/auth/sign_out_use_case.dart';
import 'package:traditional_saju/src/application/use_cases/saju/get_daily_fortune_use_case.dart';
import 'package:traditional_saju/src/application/use_cases/saju/get_yearly_fortune_use_case.dart';
import 'package:traditional_saju/src/application/use_cases/user/check_user_exists_use_case.dart';
import 'package:traditional_saju/src/application/use_cases/user/delete_user_use_case.dart';
import 'package:traditional_saju/src/application/use_cases/user/get_current_user_use_case.dart';
import 'package:traditional_saju/src/config/app_config.dart';
import 'package:traditional_saju/src/infrastructure/adapter/auth/auth_adapter.dart';
import 'package:traditional_saju/src/infrastructure/adapter/saju/saju_adapter.dart';
import 'package:traditional_saju/src/infrastructure/adapter/user/user_adapter.dart';
import 'package:traditional_saju/src/infrastructure/client/api_client.dart';
import 'package:traditional_saju/src/infrastructure/oauth/google_oauth_helper.dart';
import 'package:traditional_saju/src/infrastructure/oauth/kakao_oauth_helper.dart';
import 'package:traditional_saju/src/infrastructure/storage/drift/database.dart';
import 'package:traditional_saju/src/infrastructure/storage/storage_initializer.dart';
import 'package:traditional_saju/src/infrastructure/storage/token_storage_service.dart';
import 'package:traditional_saju/src/infrastructure/storage/user_storage_service.dart';
import 'package:traditional_saju/src/presentation/features/auth/bloc/auth_bloc.dart';
import 'package:traditional_saju/src/presentation/features/daily_fortune/bloc/daily_fortune_bloc.dart';
import 'package:traditional_saju/src/presentation/features/user/bloc/user_info_bloc.dart';
import 'package:traditional_saju/src/presentation/features/yearly_fortune/bloc/yearly_fortune_bloc.dart';

final GetIt getIt = GetIt.instance;

/// Initialize dependency injection container
Future<void> setupServiceLocator() async {
  // Configuration
  getIt.registerLazySingleton<AppConfig>(() => AppConfig.instance);

  // Core dependencies
  getIt.registerLazySingleton<Logger>(Logger.new);
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Initialize Drift Database
  await StorageInitializer.initialize();

  // Storage services
  getIt.registerLazySingleton<TokenStorageService>(
    () => TokenStorageService(
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );
  getIt.registerLazySingleton<UserStorageService>(
    () => UserStorageService(database: AppDatabase.instance),
  );

  // HTTP Client
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: getIt<AppConfig>().apiBaseUrl,
      secureStorage: getIt<FlutterSecureStorage>(),
      logger: getIt<Logger>(),
    ),
  );

  // OAuth helpers
  // getIt.registerLazySingleton<GoogleOAuthHelper>(GoogleOAuthHelper.new);
  getIt.registerLazySingleton<GoogleOAuthHelper>(
    () => GoogleOAuthHelper(
      clientId: getIt<AppConfig>().googleClientId,
      serverClientId: getIt<AppConfig>().googleServerClientId,
    ),
  );
  getIt.registerLazySingleton<KakaoOAuthHelper>(
    () => KakaoOAuthHelper(
      nativeAppKey: getIt<AppConfig>().kakaoNativeAppKey,
    ),
  );

  // Adapters (Ports implementations)
  getIt.registerLazySingleton<AuthPort>(
    () => AuthAdapter(
      apiClient: getIt<ApiClient>(),
    ),
  );
  getIt.registerLazySingleton<UserPort>(
    () => UserAdapter(
      apiClient: getIt<ApiClient>(),
    ),
  );
  getIt.registerLazySingleton<SajuPort>(
    () => SajuAdapter(
      apiClient: getIt<ApiClient>(),
      userStorage: getIt<UserStorageService>(),
    ),
  );

  // Auth Use Cases
  getIt.registerLazySingleton(
    () => LoginUseCase(authPort: getIt<AuthPort>()),
  );
  getIt.registerLazySingleton(
    () => SignOutUseCase(authPort: getIt<AuthPort>()),
  );
  getIt.registerLazySingleton(
    () => CheckAuthStatusUseCase(authPort: getIt<AuthPort>()),
  );

  // User Use Cases
  getIt.registerLazySingleton(
    () => GetCurrentUserUseCase(userPort: getIt<UserPort>()),
  );
  getIt.registerLazySingleton(
    () => CheckUserExistsUseCase(userPort: getIt<UserPort>()),
  );
  getIt.registerLazySingleton(
    () => DeleteUserUseCase(userPort: getIt<UserPort>()),
  );

  // Saju Use Cases
  getIt.registerLazySingleton(
    () => GetDailyFortuneUseCase(sajuPort: getIt<SajuPort>()),
  );
  getIt.registerLazySingleton(
    () => GetYearlyFortuneUseCase(sajuPort: getIt<SajuPort>()),
  );

  // BLoCs
  getIt.registerFactory(
    () => AuthBloc(
      checkAuthStatus: getIt<CheckAuthStatusUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      signOut: getIt<SignOutUseCase>(),
      googleOAuthHelper: getIt<GoogleOAuthHelper>(),
      kakaoOAuthHelper: getIt<KakaoOAuthHelper>(),
    ),
  );
  getIt.registerFactory(
    () => UserInfoBloc(
      userStorage: getIt<UserStorageService>(),
    ),
  );
  getIt.registerFactory(
    () => DailyFortuneBloc(
      getDailyFortune: getIt<GetDailyFortuneUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => YearlyFortuneBloc(
      getYearlyFortune: getIt<GetYearlyFortuneUseCase>(),
    ),
  );
}
