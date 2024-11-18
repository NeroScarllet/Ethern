import 'package:ethern/pages/campaign_list_page.dart';
import 'package:ethern/pages/d20_page.dart';
import 'package:ethern/pages/menu.dart';
import 'package:ethern/pages/profile_page.dart';
import 'package:ethern/util/character_preview_tile2.dart';
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
        leading: Icon(Icons.menu),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(Icons.person),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
            height: MediaQuery.sizeOf(context).height - 385,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                CharacterPreviewTile2(
                  ImagePath: 'lib/assets/images/Katsuo.png',
                  Name: 'Katsuo Hitsuki',
                  Description:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
                  Race: 'Humano',
                  Campaign: 'Limiar Crescente',
                ),
                CharacterPreviewTile2(
                  ImagePath: 'lib/assets/images/Katsuo.png',
                  Name: 'Katsuo Hitsuki',
                  Description:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
                  Race: 'Humano',
                  Campaign: 'Limiar Crescente',
                ),
                CharacterPreviewTile2(
                  ImagePath: 'lib/assets/images/Katsuo.png',
                  Name: 'Katsuo Hitsuki',
                  Description:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
                  Race: 'Humano',
                  Campaign: 'Limiar Crescente',
                ),
                CharacterPreviewTile2(
                  ImagePath: 'lib/assets/images/Katsuo.png',
                  Name: 'Katsuo Hitsuki',
                  Description:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
                  Race: 'Humano',
                  Campaign: 'Limiar Crescente',
                ),
              ],
            ),
          ),
        ]),
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
            selectedIndex: 1,
            onTabChange: _onTabChange,
          ),
        ),
      ),
    );
  }
}
