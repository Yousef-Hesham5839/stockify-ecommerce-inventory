import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<Dio>(
    () => Dio(),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl(), secureStorage: sl()),
  );

}