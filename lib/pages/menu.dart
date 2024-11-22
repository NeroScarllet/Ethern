// ignore_for_file: sized_box_for_whitespace

import 'package:ethern/pages/campaign_list_page.dart';
import 'package:ethern/pages/character_list_page.dart';
import 'package:ethern/pages/d20_page.dart';
import 'package:ethern/pages/home.dart';
import 'package:ethern/pages/profile_page.dart';
import 'package:ethern/util/campaign_preview_tile.dart';
import 'package:ethern/util/character_preview_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Icon(Icons.menu),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(Icons.person),
          )
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(right: 25.0, left: 25.0, top: 15.0),
              child: Text(
                'Olá usuário, bem vindo a Ethern!',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
         
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CharacterListPage()));
                },
                child: Row(
                  children: [
                    Text(
                      'Personagens',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 340,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CharacterPreviewTile(
                    ImagePath: 'lib/assets/images/Katsuo.png',
                    Name: 'Katsuo Hitsuki',
                    Race: 'Humano',
                    Campaign: 'Limiar Crescente',
                  ),
                  CharacterPreviewTile(
                    ImagePath: 'lib/assets/images/Katsuo.png',
                    Name: 'Katsuo Hitsuki',
                    Race: 'Humano',
                    Campaign: 'Limiar Crescente',
                  ),
                  CharacterPreviewTile(
                    ImagePath: 'lib/assets/images/Katsuo.png',
                    Name: 'Katsuo Hitsuki',
                    Race: 'Humano',
                    Campaign: 'Limiar Crescente',
                  ),
                  CharacterPreviewTile(
                    ImagePath: 'lib/assets/images/Katsuo.png',
                    Name: 'Katsuo Hitsuki',
                    Race: 'Humano',
                    Campaign: 'Limiar Crescente',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CampaignListPage()));
                },
                child: Row(
                  children: [
                    Text(
                      'Campanhas',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 400,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CampaignPreviewTile(
                    ImagePath: 'lib/assets/images/LimiarCrescente.png',
                    Name: 'Limiar Crescente',
                  ),
                  CampaignPreviewTile(
                    ImagePath: 'lib/assets/images/LimiarCrescente.png',
                    Name: 'Limiar Crescente',
                  ),
                  CampaignPreviewTile(
                    ImagePath: 'lib/assets/images/LimiarCrescente.png',
                    Name: 'Limiar Crescente',
                  ),
                  CampaignPreviewTile(
                    ImagePath: 'lib/assets/images/LimiarCrescente.png',
                    Name: 'Limiar Crescente',
                  ),
                  CampaignPreviewTile(
                    ImagePath: 'lib/assets/images/LimiarCrescente.png',
                    Name: 'Limiar Crescente',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const D20Page()));
                },
                child: Row(
                  children: [
                    Text(
                      'Girar o D20',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const D20Page()));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset("lib/assets/images/d20_preview.png")),
              ),
            ),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              color: Colors.blue,
              child: Text('Deslogar'),
            ),
          ],
        ),
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
            selectedIndex: 0,
            onTabChange: _onTabChange,
          ),
        ),
      ),
    );
  }
}
