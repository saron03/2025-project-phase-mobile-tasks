import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/product/data/datasources/product_local_data_dource.dart';
import '../../features/product/data/datasources/product_local_data_source_impl.dart';
import '../../features/product/data/datasources/product_remote_data_source.dart';
import '../../features/product/data/datasources/product_remote_data_source_impl.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/delete_product.dart';
import '../../features/product/domain/usecases/get_all_products.dart';
import '../../features/product/domain/usecases/get_product.dart';
import '../../features/product/domain/usecases/insert_product.dart';
import '../../features/product/domain/usecases/update_product.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';
import '../platform/netwrok_info.dart';
import '../utils/api_service.dart';
import '../utils/input_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
  sl.registerLazySingleton<ApiService>(() => ApiService(client: sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl(), connectionChecker: sl()));
  sl.registerLazySingleton<InputConverter>(() => InputConverter());

  // Data Layer
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Domain Layer
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetProduct(sl()));
  sl.registerLazySingleton(() => InsertProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));

  // Presentation Layer
  sl.registerFactory(() => ProductBloc(
        insertProduct: sl(),
        updateProduct: sl(),
        deleteProduct: sl(),
        getProduct: sl(),
        getAllProducts: sl(),
        inputConverter: sl(),
      ));

  // Ensure SharedPreferences is initialized
  await sl.allReady();
}