import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todos/authenticate.dart';
import 'package:todos/firebase_options.dart';
import 'package:todos/pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: Authenticate.id,
      routes: {
        Home.id: (context) => const Home(),
        Authenticate.id: (context) => const Authenticate(),
      },
    );
  }
}
