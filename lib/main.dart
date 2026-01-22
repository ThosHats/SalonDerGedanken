import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salon_der_gedanken/core/models/event.dart';
import 'package:salon_der_gedanken/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  // TODO: Register other adapters if needed

  runApp(const ProviderScope(child: SalonDerGedankenApp()));
}

class SalonDerGedankenApp extends ConsumerWidget {
  const SalonDerGedankenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Salon der Gedanken',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3211d4)),
        useMaterial3: true,
        fontFamily: 'Manrope',
      ),
      routerConfig: appRouter,
    );
  }
}
