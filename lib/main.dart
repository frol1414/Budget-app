import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/firebase_service.dart';
import 'repositories/transaction_repository.dart';
import 'repositories/mock_transaction_repository.dart';
import 'repositories/firestore_transaction_repository.dart';
import 'providers/finance_provider.dart';

import 'screens/home_screen.dart';
import 'screens/add_transaction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();

  final TransactionRepository repository = FirebaseService.isInitialized
      ? FirestoreTransactionRepository()
      : MockTransactionRepository();

  runApp(
    ChangeNotifierProvider(
      create: (_) => FinanceProvider(repository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Starter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F4F4), // Light gray background from example.webp
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF202020), // Charcoal/Dark gray from Pallete.webp
          secondary: const Color(0xFFEDFF5C), // Lime Yellow from Pallete.webp
          tertiary: const Color(0xFF00C7BD), // Turquoise from Pallete.webp
          surface: Colors.white,
          onSurface: const Color(0xFF202020),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.light().textTheme.apply(
            bodyColor: const Color(0xFF202020),
            displayColor: const Color(0xFF202020),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF202020)),
          titleTextStyle: TextStyle(
            color: Color(0xFF202020),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          );
        }
        if (settings.name == '/add_transaction') {
          // Slide transition from the left
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) => const AddTransactionScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        }
        return null;
      },
    );
  }
}
