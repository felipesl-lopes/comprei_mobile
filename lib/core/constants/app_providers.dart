import 'package:appshop/core/injection_dependency/injection_dependency.dart';
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
import 'package:appshop/modules/endereco/providers/endereco_provider.dart';
import 'package:appshop/modules/endereco/repositories/endereco_repository.dart';
import 'package:appshop/modules/home/providers/banners_provider.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:appshop/modules/product/repositories/product_repository.dart';
import 'package:appshop/modules/profile/preferencias/providers/preferences_provider.dart';
import 'package:appshop/modules/profile/preferencias/repositories/preferences_repository.dart';
import 'package:appshop/core/services/auth_session_service.dart';
import 'package:appshop/core/services/i_http_client.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(
        getIt<AuthRepository>(),
        getIt<AuthSessionService>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => ProductProvider(
        getIt<ProductRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => CartProvider(
        getIt<CartRepository>(),
        context.read<ProductProvider>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => CategoriasProvider(
        getIt<CategoriasRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => OrderListProvider(
        getIt<OrderRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => AvaliacaoProvider(
        getIt<AvaliacaoRepository>(),
        context.read<OrderListProvider>(),
        context.read<ProductProvider>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => BannersProvider(
        getIt<IHttpClient>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => EnderecoProvider(
        getIt<EnderecoRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => PreferencesProvider(
        getIt<PreferencesRepository>(),
      ),
    ),
  ];
}
