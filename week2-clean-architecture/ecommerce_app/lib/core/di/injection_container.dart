import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/auth_local_data_source_impl.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/signup.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/chat/data/datasources/chat_remote_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/delete_chat.dart';
import '../../features/chat/domain/usecases/get_chat_messages.dart';
import '../../features/chat/domain/usecases/get_my_chats.dart';
import '../../features/chat/domain/usecases/initiate_chat.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
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
import '../platform/network_info.dart';
import '../utils/auth_api_service.dart';
import '../utils/chat_api_service.dart';
import '../utils/input_converter.dart';
import '../utils/product_api_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Register SharedPreferences asynchronously
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());

  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl<InternetConnectionChecker>()),
  );
  sl.registerLazySingleton<InputConverter>(() => InputConverter());

  sl.registerLazySingleton<ApiService>(() => ApiService(client: sl()));
  sl.registerLazySingleton<AuthApiService>(() => AuthApiService(client: sl()));

  // Auth Data Layer
  // This is the corrected line. AuthRemoteDataSourceImpl now only depends on AuthApiService.
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: sl()),
  );

  // Register AuthLocalDataSource after SharedPreferences is ready
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Auth Domain Layer
  sl.registerLazySingleton<Login>(() => Login(sl()));
  sl.registerLazySingleton<SignUp>(() => SignUp(sl()));
  sl.registerLazySingleton<Logout>(() => Logout(sl()));

  // Auth Presentation Layer
  sl.registerFactory(() => AuthBloc(
        login: sl(),
        signUp: sl(),
        logout: sl(),
      ));

  // Product Data Layer
  sl.registerSingletonWithDependencies<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: sl()),
    dependsOn: [SharedPreferences],
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

  // Product Domain Layer
  sl.registerLazySingleton<GetAllProducts>(() => GetAllProducts(sl()));
  sl.registerLazySingleton<GetProduct>(() => GetProduct(sl()));
  sl.registerLazySingleton<InsertProduct>(() => InsertProduct(sl()));
  sl.registerLazySingleton<UpdateProduct>(() => UpdateProduct(sl()));
  sl.registerLazySingleton<DeleteProduct>(() => DeleteProduct(sl()));

  // Product Presentation Layer
  sl.registerFactory(() => ProductBloc(
        insertProduct: sl(),
        updateProduct: sl(),
        deleteProduct: sl(),
        getProduct: sl(),
        getAllProducts: sl(),
        inputConverter: sl(),
      ));

  // Chat Feature
  // BLoC
  sl.registerFactory(() => ChatBloc(
        getMyChats: sl(),
        getChatMessages: sl(),
        initiateChat: sl(),
        deleteChat: sl(),
      ));

  // Use cases
  sl.registerLazySingleton<GetMyChats>(() => GetMyChats(sl()));
  sl.registerLazySingleton<GetChatMessages>(() => GetChatMessages(sl()));
  sl.registerLazySingleton<InitiateChat>(() => InitiateChat(sl()));
  sl.registerLazySingleton<DeleteChat>(() => DeleteChat(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      authRepository: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(apiService: sl()));

  // API Service
  sl.registerLazySingleton<ChatApiService>(() => ChatApiService(client: sl()));

  await sl.allReady();
}