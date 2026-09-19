import 'package:appshop/core/database/dataSource/product_local_data_source.dart';
import 'package:appshop/core/services/http_client_service.dart';
import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/auth/providers/auth_provider.dart';
import 'package:appshop/modules/auth/repositories/auth_repository.dart';
import 'package:appshop/modules/avaliacao/providers/avaliacao_provider.dart';
import 'package:appshop/modules/avaliacao/repositories/avaliacao_repository.dart';
import 'package:appshop/modules/cart/providers/cart_provider.dart';
import 'package:appshop/modules/cart/repositories/cart_repository.dart';
import 'package:appshop/modules/categorias/providers/categorias_provider.dart';
import 'package:appshop/modules/categorias/repositories/categorias_repository.dart';
import 'package:appshop/modules/compras/providers/order_list_provider.dart';
import 'package:appshop/modules/compras/repositories/order_repository.dart';
import 'package:appshop/modules/endereco/dataSource/endereco_local_data_source.dart';
import 'package:appshop/modules/endereco/providers/endereco_provider.dart';
import 'package:appshop/modules/endereco/repositories/endereco_repository.dart';
import 'package:appshop/modules/home/providers/banners_provider.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:appshop/modules/product/repositories/product_repository.dart';
import 'package:appshop/modules/profile/preferencias/providers/preferences_provider.dart';
import 'package:appshop/modules/profile/preferencias/repositories/preferences_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
String get apiurl => dotenv.env['API_URL'] ?? '';

void configureDependencies() {
  getIt.registerLazySingleton<IHttpClient>(
    () => HttpClientService(
      baseUrl: apiurl,
      getToken: () => getIt<AuthProvider>().token,
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<IHttpClient>()),
  );

  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<CategoriasRepository>(
    () => CategoriasRepository(getIt<IHttpClient>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(
      getIt<IHttpClient>(),
      getIt<ProductLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepository(getIt<IHttpClient>()),
  );
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepository(getIt<IHttpClient>()),
  );
  getIt.registerLazySingleton<EnderecoRepository>(
    () => EnderecoRepository(
      getIt<IHttpClient>(),
    ),
  );
  getIt.registerLazySingleton<AvaliacaoRepository>(
    () => AvaliacaoRepository(getIt<IHttpClient>()),
  );
  getIt.registerLazySingleton<PreferencesRepository>(
    () => PreferencesRepository(getIt<IHttpClient>()),
  );

  getIt.registerLazySingleton<CartProvider>(() => CartProvider(
        getIt<CartRepository>(),
        getIt<ProductProvider>(),
      ));

  getIt.registerLazySingleton<ProductProvider>(() => ProductProvider(
        getIt<ProductRepository>(),
      ));

  getIt.registerLazySingleton<CategoriasProvider>(() => CategoriasProvider(
        getIt<CategoriasRepository>(),
      ));

  getIt.registerLazySingleton<AvaliacaoProvider>(() => AvaliacaoProvider(
        getIt<AvaliacaoRepository>(),
        getIt<OrderListProvider>(),
        getIt<ProductProvider>(),
      ));

  getIt.registerLazySingleton<OrderListProvider>(() => OrderListProvider(
        getIt<OrderRepository>(),
      ));

  getIt.registerLazySingleton<BannersProvider>(() => BannersProvider(
        getIt<IHttpClient>(),
      ));

  getIt.registerLazySingleton<EnderecoProvider>(() => EnderecoProvider(
        getIt<EnderecoRepository>(),
      ));

  getIt.registerLazySingleton<PreferencesProvider>(() => PreferencesProvider(
        getIt<PreferencesRepository>(),
      ));

  getIt.registerLazySingleton<EnderecoLocalDataSource>(
    () => EnderecoLocalDataSource(),
  );

  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSource(),
  );
}
