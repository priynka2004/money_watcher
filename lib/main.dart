import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_watcher/dashboard/provider/money_record_provider.dart';
import 'package:money_watcher/dashboard/service/money_watcher_firebase_service.dart';
import 'package:money_watcher/dashboard/ui/dashboard_screen.dart';
import 'package:money_watcher/firebase_options.dart';
import 'package:money_watcher/login/service/auth_service.dart';
import 'package:money_watcher/login/provider/auth_provider.dart';
import 'package:money_watcher/login/ui/login_screen.dart';
import 'package:money_watcher/shared/app_colors.dart';
import 'package:money_watcher/shared/app_string.dart';
import 'package:money_watcher/shared/database_service.dart';
import 'package:provider/provider.dart';
import 'firebase_remote_service/firebase_remote_configure_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DatabaseService databaseService = DatabaseService();
  await databaseService.initDatabase();
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
  try {
    await FirebaseRemoteConfigService.init();
  } catch (e) {
    if (kDebugMode) {
      print('Not Found:$e');
    }
  }
  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.databaseService, super.key});

  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return AuthProvider(AuthService());
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return MoneyRecordProvider(MoneyWatcherFirebaseService());
          },
        ),
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: appColorScheme),
          useMaterial3: true,
        ),
        home: FirebaseRemoteConfigService.dashBordScreen? const LoginScreen()
            : const DashboardScreen(),
      ),
    );
  }
}
