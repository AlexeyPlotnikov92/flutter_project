import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_project/pages/auth.dart';
import 'package:flutter_test_project/pages/home.dart';
import 'package:flutter_test_project/pages/landing.dart';
import 'package:flutter_test_project/pages/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test_project/pages/newpag.dart';
import 'package:flutter_test_project/servises/auth.dart';
import 'package:flutter_test_project/servises/user_project.dart';
import 'package:provider/provider.dart';


void initFireBase() async {

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserProject?>.value(
      initialData: null,
      value: AuthService().currentUser,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.orangeAccent,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LandingPage(),
          '/auth':(context) => Autorization(),
          '/start': (context) => MainScreen(),
          '/todo': (context) => Home(),
          '/newtodo' : (context) => MyApp(),
        },
      ),
    );
  }
}



