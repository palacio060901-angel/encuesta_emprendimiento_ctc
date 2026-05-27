import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'utils/firebase_options.dart';
import 'servicios/auth_service.dart';
import 'servicios/firebase_service.dart';
import 'servicios/database_service.dart';
import 'pantallas/inicio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirebaseService>(create: (_) => FirebaseService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
      ],
      child: MaterialApp(
        title: 'Encuestas Emprendimiento CTC',
        theme: ThemeData(
          primaryColor: Color(0xFFD32F2F),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color(0xFFD32F2F),
            secondary: Color(0xFFD32F2F),
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFD32F2F),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFD32F2F)),
            ),
          ),
        ),
        home: InicioPantalla(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}