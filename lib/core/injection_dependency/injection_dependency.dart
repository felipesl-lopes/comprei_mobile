import 'package:appshop/core/database/dataSource/product_local_data_source.dart';
import 'package:appshop/core/services/auth_session_service.dart';
import 'package:appshop/core/services/http_client_service.dart';
import 'package:appshop/core/services/i_http_client.dart';
import 'package:appshop/modules/auth/repositories/auth_repository.dart';
import 'package:appshop/modules/avaliacao/repositories/avaliacao_repository.dart';
import 'package:appshop/modules/cart/repositories/cart_repository.dart';
import 'package:appshop/modules/categorias/repositories/categorias_repository.dart';
import 'package:appshop/modules/compras/repositories/order_repository.dart';
import 'package:appshop/modules/endereco/dataSource/endereco_local_data_source.dart';
import 'package:appshop/modules/endereco/repositories/endereco_repository.dart';
import 'package:appshop/modules/product/repositories/product_repository.dart';
import 'package:appshop/modules/profile/preferencias/repositories/preferences_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
String get apiUrl => dotenv.env['API_URL'] ?? '';

void configureDependencies() {
  getIt.registerLazySingleton<EnderecoLocalDataSource>(
    () => EnderecoLocalDataSource(),
  );

  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSource(),
  );

  getIt.registerLazySingleton<AuthSessionService>(
    () => AuthSessionService(),
  );

  getIt.registerLazySingleton<IHttpClient>(
    () => HttpClientService(
      baseUrl: apiUrl,
      getToken: () => getIt<AuthSessionService>().token,
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<IHttpClient>()),
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
}
