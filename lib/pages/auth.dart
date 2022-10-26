import 'package:flutter/material.dart';
import 'package:flutter_test_project/servises/auth.dart';
import 'package:flutter_test_project/servises/user_project.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Autorization extends StatefulWidget {

  const Autorization({Key? key}) : super(key: key);

  @override
  State<Autorization> createState() => _AutorizationState();
}

class _AutorizationState extends State<Autorization> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '';
  String password = '';
  bool showLogin = true;

  AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {

    Widget logo() {
        return Padding(padding: EdgeInsets.only(top: 100),
         child: Container(
           child: Align(
             child: Text('Todo List', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        );
    }

    Widget input(Icon icon, String hint, TextEditingController textEditingController, bool obscure) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: textEditingController,
          obscureText: obscure,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white30),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 3)
            ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54, width: 1)
              ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10, right: 10,),
              child: IconTheme(
                data: IconThemeData(color: Colors.white),
                child: icon
              ),
            )
          ),
        ),
      );
    }

    Widget button(String text, void func()) {
      return ElevatedButton(
          onPressed: () {
            func();
          },
          //splashColor: Colors.deepOrangeAccent,
          //highlightColor: Colors.deepOrangeAccent,
          //color: Colors.white,
          child: Text(
            text,
            style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent, fontSize: 20 ),
          )
      );
    }

    Widget form(String label, void func()) {
      return Container(
           child: Column(
             children: <Widget>[
                Padding(
                   padding: EdgeInsets.only(bottom: 20, top: 7),
                   child: input(Icon(Icons.email), 'email', emailController, false),
               ),
               Padding(
                 padding: EdgeInsets.only(bottom: 20),
                 child: input(Icon(Icons.block), 'password', passwordController, true),
               ),
               SizedBox(
                 height: 20,
               ),
               Padding(
                 padding: EdgeInsets.only(left: 20, right: 20),
                 child: Container(
                   height: 30,
                   width: MediaQuery.of(context).size.width,
                   child: button(label, func),
                 ),
               )
             ],
           ),
      );
    }


    void _logunButtonAction() async {
      email = emailController.text;
      password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        return;
      }
      
      UserProject? user = await _authService.signInWithEmail(email.trim(), password.trim());

      if (user == null) {
        Fluttertoast.showToast(
            msg: "Can't log in. Please, check email and password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        emailController.clear();
        passwordController.clear();
      }

      emailController.clear();
      passwordController.clear();
    }

    void _registerButtonAction() async {
      email = emailController.text;
      password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        return;
      }

      if (!email.contains('@')) {
        return;
      }

      UserProject? user = await _authService.registerInWithEmail(email, password);

      if (user == null) {
        Fluttertoast.showToast(
            msg: "Can't register. Please, check email and password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        emailController.clear();
        passwordController.clear();
      }

      emailController.clear();
      passwordController.clear();
    }



    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Column(
        children: <Widget>[
          logo(),
          (
              showLogin
                  ?
              Column(
            children: <Widget>[
              form('login', _logunButtonAction),
              Padding(
                child: GestureDetector(
                  child: Text('Not registered yet ? Register', style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onTap:() {
                    setState((){
                      showLogin = false;
                     });
                  },
                ),
                padding: EdgeInsets.all(1),
              )
            ],
           )
          :
          Column(
            children: <Widget>[
              form('register', _registerButtonAction),
              Padding(
                child: GestureDetector(
                  child: Text('Already register? Login', style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onTap:() {
                    setState((){
                      showLogin = true;
                    });
                  },
                ),
                padding: EdgeInsets.all(1),
              )
            ],
          )
          ),
      ],
      ),
    );
  }
}
