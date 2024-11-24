import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethern/pages/character_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CharacterSelectedPage extends StatefulWidget {
  const CharacterSelectedPage({super.key});

  @override
  State<CharacterSelectedPage> createState() => _CharacterSelectedPageState();
}

class Character {
  String nome;
  String sobre;
  String campanha;
  String raca;

  Character(
      {required this.nome,
      required this.sobre,
      required this.campanha,
      required this.raca});

  @override
  String toString() {
    return 'Character(nome: $nome, sobre: $sobre, campanha: $campanha, raca: $raca)';
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'sobre': sobre,
      'campanha': campanha,
      'raca': raca,
    };
  }
}

class _CharacterSelectedPageState extends State<CharacterSelectedPage> {
  final double coverHeight = 280;
  final double profileHeight = 144;
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _campaignController = TextEditingController();
  final _raceController = TextEditingController();
  String? characterId; // Variable to hold the character ID

  Future createCharacter() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Exibir uma mensagem de erro se nenhum usuário estiver logado
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Nenhum usuário está logado.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    String userId = currentUser.uid;

    Character character = Character(
      nome: _nameController.text,
      sobre: _aboutController.text,
      campanha: _campaignController.text,
      raca: _raceController.text,
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('characters')
          .add(character.toMap());
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CharacterListPage()));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Personagem adicionado com sucesso!"),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Erro ao adicionar personagem: $e"),
          );
        },
      );
    }
  }

  Future deleteCharacter() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || characterId == null) {
      // Exibir uma mensagem de erro se nenhum usuário estiver logado ou characterId for nulo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Nenhum usuário está logado ou characterId está vazio.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    String userId = currentUser.uid;

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('characters')
          .doc(characterId)
          .delete();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CharacterListPage()));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Personagem deletado com sucesso!"),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Erro ao deletar personagem: $e"),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CharacterListPage()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(Icons.person),
          )
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          SizedBox(
            height: 7,
          ),
          buildContent(),
          SizedBox(height: 10,)
        ],
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
                'Nome do personagem',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                'Campanha do personagem',
                style:
                    TextStyle(fontSize: 18, height: 1.4, color: Colors.black),
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
                    hintText: '',
                  ),
                ),
              ),
            ),
            Divider(),
            Text(
              'Nome do personagem',
              style: TextStyle(fontSize: 18, height: 1.4, color: Colors.black),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.7),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nome do personagem',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Nome da campanha',
              style: TextStyle(fontSize: 18, height: 1.4, color: Colors.black),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.7),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _campaignController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nome da campanha',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Raça',
              style: TextStyle(fontSize: 18, height: 1.4, color: Colors.black),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.7),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  controller: _raceController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Raça',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: createCharacter,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Salvar Personagem',
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: deleteCharacter,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Deletar Personagem',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
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

  Widget buildProfileImage() => Container(
        padding: EdgeInsets.all(4), // Adiciona um padding para a borda
        decoration: BoxDecoration(
          color: Colors.blue, // Cor da borda
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: profileHeight / 2,
          backgroundColor: Colors.grey.shade800,
          backgroundImage: NetworkImage(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU'),
        ),
      );
}
