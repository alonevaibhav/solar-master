import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- Required for setting system UI overlay
import 'package:get/get.dart';
import 'API Service/api_service.dart';
import 'Route Manager/app_bindings.dart';
import 'Route Manager/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'View/Auth/token_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiService.init();

  // Determine initial route based on token status
  String initialRoute = AppRoutes.login;

  try {
    final hasValidToken =
        await TokenManager.hasToken() && !await TokenManager.isTokenExpired();

    if (hasValidToken) {
      final role = await TokenManager.getUserRole();
      if (role != null && role.isNotEmpty) {
        switch (role.toLowerCase()) {
          case 'cleaner':
            initialRoute = AppRoutes.cleaner;
            break;
          case 'inspector':
            initialRoute = AppRoutes.inspector;
            break;
          default:
            print('Unknown role: $role, redirecting to login');
            initialRoute = AppRoutes.login;
        }
        print('Valid token found, navigating to: $initialRoute');
      } else {
        print('No user role found, redirecting to login');
        initialRoute = AppRoutes.login;
      }
    } else {
      print('No valid token found, redirecting to login');
      initialRoute = AppRoutes.login;
    }
  } catch (e) {
    print('Error checking initial token status: $e');
    initialRoute = AppRoutes.login;
  }

  // 🧱 Match status bar and nav bar with white background
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark, // black icons
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        onInit: () {
          // Only start token management if we're starting with login
          if (initialRoute == AppRoutes.login) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              TokenManager.startTokenExpirationTimer();
            });
          } else {
            // For other routes, just start the timer without checking expiration
            WidgetsBinding.instance.addPostFrameCallback((_) {
              TokenManager.startTokenExpirationTimer();
            });
          }
        },
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        initialRoute: initialRoute,
        getPages: AppRoutes.routes,
        initialBinding: AppBindings(),
      ),
    );
  }
}
