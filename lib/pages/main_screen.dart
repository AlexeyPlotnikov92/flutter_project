import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: Text('Список'),
          centerTitle: true,
        ),
       body: Column(
         children: [
         Text('MainScreen', style: TextStyle(color: Colors.white),),
          ElevatedButton(onPressed: () {
            Navigator.pushReplacementNamed(context, '/todo');
          }, child: Text('Перейти далее')),
        ],
      )
    );
  }
}
