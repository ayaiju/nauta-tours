import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:nauta_tours/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔥 Supabase (OBLIGATORIO)
  await Supabase.initialize(
    url: 'https://thptturwimyojeplzvcd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRocHR0dXJ3aW15b2plcGx6dmNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU4MzMwMTksImV4cCI6MjA4MTQwOTAxOX0.WN6fQV1_LWXy2dDP1U8P2t3htO4VtzDnZo17pcEje1w',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainWrapper());
  }
}

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final logged = snapshot.data != null;
        return HomeScreen(isLoggedIn: logged);
      },
    );
  }
}
