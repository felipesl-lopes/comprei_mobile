import 'package:appshop/core/constants/app_colors.dart';
import 'package:appshop/core/constants/app_route_observer.dart';
import 'package:appshop/core/constants/app_routes.dart';
import 'package:flutter/material.dart';

class MaterialAppWidget extends StatelessWidget {
  const MaterialAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shopp",
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.textOnPrimary,
          secondary: AppColors.primaryLight,
          onSecondary: AppColors.textPrimary,
          error: AppColors.error,
          onError: AppColors.textOnPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          background: AppColors.background,
        ),
        textTheme: null,
        appBarTheme: null,
        elevatedButtonTheme: null,
        inputDecorationTheme: null,
        cardTheme: null,
        fontFamily: "Lato",
      ),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
