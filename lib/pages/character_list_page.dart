import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethern/pages/campaign_list_page.dart';
import 'package:ethern/pages/character_selected_page.dart';
import 'package:ethern/pages/d20_page.dart';
import 'package:ethern/pages/menu.dart';
import 'package:ethern/pages/profile_page.dart';
import 'package:ethern/util/character_preview_tile2.dart';
import 'package:ethern/util/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
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
        title: Text("Personagens"),
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
                    backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU'),
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
      drawer: SideBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CharacterSelectedPage(),
            ),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0, left: 25.0, top: 15.0),
            child: Text(
              'Crie e desenvolva seus personagens!',
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
            child: TextField(
              decoration: InputDecoration(
                fillColor: Colors.grey[500],
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                hintText: 'Encontre o que está procurando..',
                hintStyle: TextStyle(color: Colors.grey[600]),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade600)),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.sizeOf(context).height / 2,
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
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs.map((document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharacterSelectedPage(
                              characterId: document.id,
                            ),
                          ),
                        );
                      },
                      child: CharacterPreviewTile2(
                        ImagePath: data['imageUrl'] ?? 'https://i.sstatic.net/mwFzF.png',
                        Name: data['nome'] ?? 'Sem Nome',
                        Description: data['sobre'] ?? 'Sem Descrição',
                        Race: data['raca'] ?? 'Sem Raça',
                        Campaign: data['campanha'] ?? 'Sem Campanha',
                        characterId: document.id,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ]),
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
            selectedIndex: 1,
            onTabChange: _onTabChange,
          ),
        ),
      ),
    );
  }
}
