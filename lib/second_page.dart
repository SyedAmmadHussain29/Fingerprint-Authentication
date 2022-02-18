import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C3E52),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF3C3E52),
      ),
      body: Center(
          child: Text(
        'Sucess',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 82),
      )),
    );
  }
}
