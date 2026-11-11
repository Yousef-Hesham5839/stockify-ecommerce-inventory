import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/orders/data/datasources/order_remote_data_source.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/orders/domain/repositories/order_repository.dart';
import 'features/orders/domain/usecases/create_invoice_usecase.dart';
import 'features/orders/domain/usecases/get_my_invoices_usecase.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  //! Core
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<Dio>(
    () => Dio(),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl(), secureStorage: sl()),
  );

  //! Auth Feature

  
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl()),
  );

  
  //! Products Feature
  // Bloc
  sl.registerFactory(() => ProductBloc(getProductsUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  //! Cart Feature
  sl.registerLazySingleton(() => CartBloc());

    //! Orders Feature
  sl.registerFactory(
    () => OrderBloc(
      createInvoiceUseCase: sl(),
      getMyInvoicesUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => CreateInvoiceUseCase(sl()));
  sl.registerLazySingleton(() => GetMyInvoicesUseCase(sl()));

  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(client: sl()),
  );
}