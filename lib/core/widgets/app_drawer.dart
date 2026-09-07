import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/utils/session_service.dart';
import 'package:appshop/core/widgets/modal_custom.dart';
import 'package:appshop/modules/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;

    return Drawer(
      width: width * 0.65,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
            iconTheme: IconThemeData(color: colorScheme.onPrimary),
            title: Text(
              user!.name,
              style: TextStyle(color: colorScheme.onPrimary, fontSize: 18),
            ),
          ),
          SizedBox(height: 8),
          _DrawerMenuItem(
            title: "Início",
            icon: Icons.home,
            route: AppRoutes.HOME,
          ),
          _DrawerMenuItem(
            title: "Meu perfil",
            icon: Icons.person,
            route: AppRoutes.PROFILE,
          ),
          _DrawerMenuItem(
            title: "Meu carrinho",
            icon: Icons.shopping_cart,
            route: AppRoutes.CART,
          ),
          _DrawerMenuItem(
            title: "Minhas compras",
            icon: Icons.payment,
            route: AppRoutes.COMPRAS,
          ),
          _DrawerMenuItem(
            title: "Gerenciar produtos",
            icon: Icons.inventory,
            route: AppRoutes.MANAGE_PRODUCTS,
          ),
          ListTile(
            dense: true,
            visualDensity: VisualDensity(vertical: -2),
            leading: Icon(Icons.logout, color: colorScheme.primary),
            title: Text("Sair", style: TextStyle(color: colorScheme.primary)),
            onTap: () {
              modalCustom(
                context: context,
                onTap: () async => await SessionService().logout(context),
                icon: Icons.logout,
                title: "Deseja sair?",
                text:
                    "Após confirmar sua saída precisará se logar novamente na próxima vez.",
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  const _DrawerMenuItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            dense: true,
            visualDensity: VisualDensity(vertical: -2),
            leading: Icon(icon),
            title: Text(title),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(route);
            }),
        Divider(),
      ],
    );
  }
}
