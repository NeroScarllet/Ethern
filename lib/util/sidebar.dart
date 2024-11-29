import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ethern/pages/campaign_list_page.dart';
import 'package:ethern/pages/character_list_page.dart';
import 'package:ethern/pages/d20_page.dart';
import 'package:ethern/pages/home.dart';
import 'package:ethern/pages/menu.dart';
import 'package:ethern/pages/profile_page.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[300],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserAccountsDrawerHeader(
                  accountName: Text('Loading...'),
                  accountEmail: Text('Loading...'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return UserAccountsDrawerHeader(
                  accountName: Text('Error'),
                  accountEmail: Text('Error'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Icon(Icons.error),
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return UserAccountsDrawerHeader(
                  accountName: Text('No Data'),
                  accountEmail: Text('No Data'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Icon(Icons.error),
                    ),
                  ),
                );
              } else {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                final profileImageUrl =
                    data['profileImageUrl'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU';
                final username = data['username'] ?? 'No Username';
                final email = data['email'] ?? 'No Email';

                return UserAccountsDrawerHeader(
                  accountName: Text(username),
                  accountEmail: Text(email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.blue, // Borda azul
                    child: ClipOval(
                      child: Image.network(
                        profileImageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://images2.alphacoders.com/133/1337879.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.black),
            title: Text('Menu', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MenuPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.group, color: Colors.black),
            title: Text('Personagens', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CharacterListPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.book, color: Colors.black),
            title: Text('Campanhas', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CampaignListPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.casino, color: Colors.black),
            title: Text('D20', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const D20Page()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text('Perfil', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilePage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: Text('Configurações', style: TextStyle(color: Colors.black)),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.description, color: Colors.black),
            title: Text('Sobre', style: TextStyle(color: Colors.black)),
            onTap: null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.black),
            title: Text('Sair', style: TextStyle(color: Colors.black)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
