// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethern/pages/campaign_list_page.dart';
import 'package:ethern/pages/character_list_page.dart';
import 'package:ethern/pages/d20_page.dart';
import 'package:ethern/pages/profile_page.dart';
import 'package:ethern/util/campaign_preview_tile.dart';
import 'package:ethern/util/character_preview_tile.dart';
import 'package:ethern/util/sidebar.dart';
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
  String _profileImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU'; // Imagem padrão
  final List<Widget> _pages = [
    MenuPage(),
    CharacterListPage(),
    CampaignListPage(),
    D20Page(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfileImage();
  }

  Future<void> _loadUserProfileImage() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _profileImageUrl = data['profileImageUrl'] ??
              _profileImageUrl; // Atualizar se disponível
        });
      }
    }
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(_profileImageUrl),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
      drawer: SideBar(),
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('characters')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Nenhum personagem encontrado'));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return CharacterPreviewTile(
                        ImagePath: data['imageUrl'] ??
                            'https://i.sstatic.net/mwFzF.png',
                        Name: data['nome'] ?? 'Sem Nome',
                        Race: data['raca'] ?? 'Sem Raça',
                        Campaign: data['campanha'] ?? 'Sem Campanha',
                        characterId: document.id, // Adicionado o characterId
                      );
                    }).toList(),
                  );
                },
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
              height: 280,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('campaigns')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Nenhuma campanha encontrada'));
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return CampaignPreviewTile(
                        ImagePath: data['imageUrl'] ??
                            'https://i.sstatic.net/mwFzF.png',
                        Name: data['nome'] ?? 'Sem Nome',
                        campaignId: document.id, // Adicionado o campaignId
                      );
                    }).toList(),
                  );
                },
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
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 15.0),
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
          ],
        ),
      ),
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
