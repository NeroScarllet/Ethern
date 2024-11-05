
import 'package:ethern/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Logou'),
        MaterialButton(onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HomePage()));
        },
        color: Colors.blue,
        child: Text('Deslogar'),)
      ],
    )));
  }
}
