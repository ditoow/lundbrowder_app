import 'package:flutter/material.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/calculation/age_selection_screen.dart';
import '../presentation/screens/calculation/info_screen.dart';
import '../presentation/screens/calculation/burn_input_screen.dart';
import '../presentation/screens/calculation/result_screen.dart';
import '../presentation/screens/calculation/parkland_screen.dart';
import '../presentation/screens/calculation/absi_screen.dart';
import '../presentation/screens/calculation/absi_result_screen.dart';

/// App route names
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String ageSelection = '/age-selection';
  static const String info = '/info';
  static const String burnInput = '/burn-input';
  static const String result = '/result';
  static const String parkland = '/parkland';
  static const String absi = '/absi';
  static const String absiResult = '/absi-result';

  /// Generate route based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case ageSelection:
        return MaterialPageRoute(builder: (_) => const AgeSelectionScreen());
      case info:
        return MaterialPageRoute(builder: (_) => const InfoScreen());
      case burnInput:
        return MaterialPageRoute(builder: (_) => const BurnInputScreen());
      case result:
        return MaterialPageRoute(builder: (_) => const ResultScreen());
      case parkland:
        return MaterialPageRoute(builder: (_) => const ParklandScreen());
      case absi:
        return MaterialPageRoute(builder: (_) => const AbsiScreen());
      case absiResult:
        return MaterialPageRoute(builder: (_) => const AbsiResultScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
