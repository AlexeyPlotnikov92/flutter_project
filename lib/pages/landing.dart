import 'package:flutter/material.dart';
import 'package:flutter_test_project/pages/auth.dart';
import 'package:flutter_test_project/pages/main_screen.dart';
import 'package:flutter_test_project/servises/user_project.dart';
import 'package:provider/provider.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final UserProject? user = Provider.of<UserProject?>(context);
    final bool isLoggedIn = user != null;
    //isLoggedIn = true;

    return isLoggedIn ? MainScreen() : Autorization();
  }
}
