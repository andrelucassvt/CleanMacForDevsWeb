import 'package:base_app/common/services/shared_preferences_service.dart';
import 'package:base_app/common/services/storage_service.dart';
import 'package:base_app/presentation/landing/view_model/landing_cubit.dart';
import 'package:base_app/presentation/locale/view_model/locale_cubit.dart';
import 'package:get_it/get_it.dart';

enum AppFlavor { development, staging, production }

class AppInjector {
  static GetIt inject = GetIt.instance;

  static Future<void> setupDependencies({
    required AppFlavor flavor,
  }) async {
    inject
      ..registerLazySingleton<AppFlavor>(() => flavor)
      ..registerLazySingleton<StorageService>(
        SharedPreferencesService.new,
      )
      ..registerLazySingleton<LocaleCubit>(LocaleCubit.new)
      ..registerFactory<LandingCubit>(LandingCubit.new);
  }
}
