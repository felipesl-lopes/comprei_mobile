import 'package:appshop/core/constants/app_routes.dart';
import 'package:appshop/core/utils/get_iniciais.dart';
import 'package:appshop/core/widgets/back_app_bar.dart';
import 'package:appshop/modules/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _auth = Provider.of<AuthProvider>(context);

    final List<(IconData, String, VoidCallback?)> topics = [
      (
        Icons.person_outline,
        "Dados do usuário",
        () => Navigator.of(context).pushNamed(AppRoutes.PROFILE_USER_DATA),
      ),
      (
        Icons.home_outlined,
        "Gerenciar endereços",
        () => Navigator.of(context).pushNamed(AppRoutes.GERENCIAR_ENDERECO),
      ),
      (
        Icons.security_outlined,
        "Segurança e conta",
        () => Navigator.of(context).pushNamed(AppRoutes.PROFILE_USER_DATA),
      ),
      (
        Icons.link,
        "Integração com o app",
        () => Navigator.of(context).pushNamed(AppRoutes.PROFILE_USER_DATA),
      ),
      (
        Icons.tune_rounded,
        "Preferências",
        () => Navigator.of(context).pushNamed(AppRoutes.PREFERENCIAS),
      ),
      (
        Icons.info_outline_rounded,
        "Sobre",
        () => Navigator.of(context).pushNamed(AppRoutes.PROFILE_USER_DATA),
      ),
      (
        Icons.more_horiz_rounded,
        "Outros",
        () => Navigator.of(context).pushNamed(AppRoutes.PROFILE_USER_DATA),
      ),
    ];

    return Scaffold(
      appBar: BackAppBar(title: "Perfil"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shadowColor: colorScheme.shadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withOpacity(0.08),
                      colorScheme.primary.withOpacity(0.03),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 120,
                      width: 120,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withOpacity(0.15),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.2),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: colorScheme.primary.withOpacity(0.2),
                        child: !_auth.isAuth
                            ? Icon(
                                Icons.person,
                                size: 64,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              )
                            : Text(
                                getIniciais(
                                  _auth.isAuth ? _auth.user!.name : '',
                                ),
                                style: TextStyle(
                                  fontSize: 50,
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _auth.user!.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Configurações",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ),
            SizedBox(height: 12),
            Card(
              elevation: 1,
              shadowColor: colorScheme.shadow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    ...topics.asMap().entries.map((entry) {
                      final index = entry.key;
                      final (icon, title, action) = entry.value;

                      return Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            leading: Icon(icon,
                                color: colorScheme.primary, size: 22),
                            title: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: colorScheme.onSurface.withOpacity(0.4),
                            ),
                            onTap: action,
                          ),
                          if (index < topics.length - 1) Divider(height: 1),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
