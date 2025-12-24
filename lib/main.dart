import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'data/services/database_service.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/calculation_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/calculation_provider.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final databaseService = DatabaseService();
    final userRepository = UserRepository(databaseService);
    final calculationRepository = CalculationRepository(databaseService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(userRepository)),
        ChangeNotifierProvider(
          create: (_) => CalculationProvider(calculationRepository),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // iPhone X design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Lund & Browder Calculator',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: AppColors.background,
              fontFamily: GoogleFonts.poppins().fontFamily,
              useMaterial3: true,
            ),
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
