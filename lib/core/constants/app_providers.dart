import 'package:appshop/core/injection_dependency/injection_dependency.dart';
import 'package:appshop/modules/auth/providers/auth_provider.dart';
import 'package:appshop/modules/avaliacao/providers/avaliacao_provider.dart';
import 'package:appshop/modules/cart/providers/cart_provider.dart';
import 'package:appshop/modules/categorias/providers/categorias_provider.dart';
import 'package:appshop/modules/compras/providers/order_list_provider.dart';
import 'package:appshop/modules/endereco/providers/endereco_provider.dart';
import 'package:appshop/modules/home/providers/banners_provider.dart';
import 'package:appshop/modules/product/providers/product_provider.dart';
import 'package:appshop/modules/profile/preferencias/providers/preferences_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (_) => getIt<AuthProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<CartProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<ProductProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<CategoriasProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<OrderListProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<BannersProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<EnderecoProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<AvaliacaoProvider>(),
    ),
    ChangeNotifierProvider(
      create: (_) => getIt<PreferencesProvider>(),
    ),
  ];
}
