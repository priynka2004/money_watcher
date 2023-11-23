import 'package:flutter/material.dart';
import 'package:money_watcher/login/provider/auth_provider.dart';
import 'package:money_watcher/login/ui/login_screen.dart';
import 'package:money_watcher/shared/app_colors.dart';
import 'package:money_watcher/shared/app_string.dart';
import 'package:money_watcher/shared/database_service.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService databaseService = DatabaseService();
  await databaseService.initDatabase();
  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.databaseService, super.key});

  final DatabaseService databaseService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return AuthProvider(databaseService);
        })
      ],
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: appColorScheme),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
