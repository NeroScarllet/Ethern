import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethern/util/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ethern/pages/campaign_list_page.dart';
import 'package:ethern/pages/character_list_page.dart';
import 'package:ethern/pages/d20_page.dart';
import 'package:ethern/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  final double coverHeight = 280;
  final double profileHeight = 144;
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _urlController =
      TextEditingController(); // Controller para a URL da imagem
  String?
      _profileImageUrl; // Adicionado para armazenar a URL da imagem de perfil
  String _username =
      'Nome de usuário não encontrado'; // Adicionado para armazenar o nome de usuário

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
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _showUrlDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          true, // Permite que o diálogo seja fechado ao clicar fora dele
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insira a URL da nova imagem'),
          content: TextField(
            controller: _urlController,
            decoration: InputDecoration(hintText: "URL da imagem"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                setState(() {
                  _profileImageUrl = _urlController.text;
                });
                _saveProfileImageUrl();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProfileImageUrl() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && _profileImageUrl != null) {
      String userId = currentUser.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profileImageUrl': _profileImageUrl});
    }
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!documentSnapshot.exists) {
        // Se o documento não existir, cria um novo documento com os dados padrão.
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'about': '',
          'profileImageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU',
          'username':
              'Nome de usuário não encontrado', // Adicionado campo padrão de username
        });
        documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
      }

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _aboutController.text = data['about'] ?? '';
          _profileImageUrl = data['profileImageUrl'];
          _username = data['username'] ??
              'Nome de usuário não encontrado'; // Carregar o nome de usuário
        });
      }
    }
  }

  Future<void> _saveUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'about': _aboutController.text});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU'),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[300],
      drawer: SideBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          SizedBox(
            height: 7,
          ),
          buildContent(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveUserData,
        backgroundColor: Colors.blue, // Salvar os dados ao clicar no botão
        child: Icon(Icons.save),
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
            selectedIndex: 4,
            onTabChange: _onTabChange,
          ),
        ),
      ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom), child: buildCoverImage()),
        Positioned(top: top, child: buildProfileImage()),
      ],
    );
  }

  Widget buildContent() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                _username,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
                padding: EdgeInsets.zero,
                width: double.infinity,
                child: Divider()),
            Text(
              'Sobre',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.7),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  controller: _aboutController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Fale um pouco sobre você...',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.network(
          'https://images2.alphacoders.com/133/1337879.png',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildProfileImage() => GestureDetector(
        onTap: _showUrlDialog, // Permite a inserção da URL da imagem
        child: Container(
          padding: EdgeInsets.all(4), // Adiciona um padding para a borda
          decoration: BoxDecoration(
            color: Colors.blue, // Cor da borda
            shape: BoxShape.circle, // Formato circular
          ),
          child: CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.grey.shade800,
            backgroundImage: _profileImageUrl != null
                ? NetworkImage(_profileImageUrl!)
                : NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU'),
          ),
        ),
      );
}
