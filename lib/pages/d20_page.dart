import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethern/util/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ethern/pages/campaign_list_page.dart';
import 'package:ethern/pages/character_list_page.dart';
import 'package:ethern/pages/menu.dart';
import 'package:ethern/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class D20Page extends StatefulWidget {
  const D20Page({super.key});

  @override
  State<D20Page> createState() => _D20PageState();
}

class _D20PageState extends State<D20Page> {
  int _selectedIndex = 0;
  int _randomNumber = 20;

  final List<Widget> _pages = [
    MenuPage(),
    CharacterListPage(),
    CampaignListPage(),
    D20Page(),
    ProfilePage(),
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => _pages[_selectedIndex]));
    });
  }

  void _rollDice() {
    setState(() {
      _randomNumber = Random().nextInt(20) + 1; // Gera um número aleatório de 1 a 20
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("D20"),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Icon(Icons.error);
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://i.sstatic.net/mwFzF.png'),
                  );
                } else {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final profileImageUrl = data['profileImageUrl'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU';
                  return CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(profileImageUrl),
                  );
                }
              },
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[300],
      drawer: SideBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Aposte o seu futuro',
              style: TextStyle(
                fontSize: 36,
                color: Colors.black,
              ),
            ),
          ),
          Spacer(),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Image.asset("lib/assets/images/d20.png", height: 350,),
              Text(
                '$_randomNumber',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 60,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: _rollDice,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    'Rodar dado',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
      // Botton Nav Bar
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.blue,
            gap: 8,
            padding: EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Menu',
              ),
              GButton(
                icon: Icons.group,
                text: 'Personagens',
              ),
              GButton(
                icon: Icons.book,
                text: 'Campanhas',
              ),
              GButton(
                icon: Icons.casino,
                text: 'D20',
              ),
              GButton(
                icon: Icons.person,
                text: 'Perfil',
              ),
            ],
            selectedIndex: 3,
            onTabChange: _onTabChange,
          ),
        ),
      ),
    );
  }
}
