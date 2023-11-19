import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pgdbapp/home/home_page.dart';
import 'package:provider/provider.dart';
import '../models/data.dart';
import 'firebase_options.dart';
import 'login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Get the firebase user
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    // Define a widget
    Widget firstWidget;

    // Assign widget based on availability of currentUser
    if (firebaseUser != null) {
      firstWidget = HomePage();
    } else {
      firstWidget = LoginScreen();
    }
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        title: 'PGDB',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: firstWidget,
      ),
    );
  }
}
