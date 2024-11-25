import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CharacterSelectedPage extends StatefulWidget {
  final String? characterId; // Agora aceita um characterId opcional

  const CharacterSelectedPage({super.key, this.characterId});

  @override
  State<CharacterSelectedPage> createState() => _CharacterSelectedPageState();
}

class Character {
  String nome;
  String sobre;
  String campanha;
  String raca;
  String? imageUrl; // Adicionado para armazenar a URL da imagem

  Character({
    required this.nome,
    required this.sobre,
    required this.campanha,
    required this.raca,
    this.imageUrl, // Inicializando a URL da imagem
  });

  @override
  String toString() {
    return 'Character(nome: $nome, sobre: $sobre, campanha: $campanha, raca: $raca, imageUrl: $imageUrl)';
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'sobre': sobre,
      'campanha': campanha,
      'raca': raca,
      'imageUrl': imageUrl,
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
  final TextEditingController _urlController =
      TextEditingController(); // Controller para a URL da imagem
  String?
      _profileImageUrl; // Adicionado para armazenar a URL da imagem de perfil

  @override
  void initState() {
    super.initState();
    if (widget.characterId != null) {
      _loadCharacterData();
    }
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
    if (currentUser != null &&
        _profileImageUrl != null &&
        widget.characterId != null) {
      String userId = currentUser.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('characters')
          .doc(widget.characterId!)
          .update({'imageUrl': _profileImageUrl});
    }
  }

  Future<void> _loadCharacterData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && widget.characterId != null) {
      String userId = currentUser.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('characters')
          .doc(widget.characterId!)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _nameController.text = data['nome'];
          _aboutController.text = data['sobre'];
          _campaignController.text = data['campanha'];
          _raceController.text = data['raca'];
          _profileImageUrl = data['imageUrl']; // Carregar a URL da imagem
        });
      }
    }
  }

  Future<void> createCharacter() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
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
      imageUrl: _profileImageUrl, // Adicionar a URL da imagem
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      if (widget.characterId != null) {
        // Atualizar o personagem existente
        await firestore
            .collection('users')
            .doc(userId)
            .collection('characters')
            .doc(widget.characterId!)
            .update(character.toMap());
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Personagem atualizado com sucesso!"),
            );
          },
        );
      } else {
        // Criar um novo personagem
        await firestore
            .collection('users')
            .doc(userId)
            .collection('characters')
            .add(character.toMap());
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Personagem adicionado com sucesso!"),
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Erro ao salvar personagem: $e"),
          );
        },
      );
    }
  }

  Future<void> deleteCharacter() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || widget.characterId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content:
                Text('Nenhum usuário está logado ou characterId está vazio.'),
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
          .doc(widget.characterId!)
          .delete();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Personagem apagado com sucesso!"),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Erro ao apagar personagem: $e"),
          );
        },
      );
    }
  }

  Widget buildContent() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                _nameController.text.isNotEmpty
                    ? _nameController.text
                    : 'Nome do personagem',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                _campaignController.text.isNotEmpty
                    ? _campaignController.text
                    : 'Nome da campanha',
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
                    hintText: _aboutController.text.isNotEmpty
                        ? _aboutController.text
                        : 'Sobre o personagem',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personagens"),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                    backgroundImage:
                        NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU'),
                  );
                } else {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final profileImageUrl = data['profileImageUrl'] ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAxxVodD07h3CI901DNtkUIhgRJ0HqS2bGVskSwY54xNSm9_-ynW8X_UfzeGQCuBvH6NI&usqp=CAU';
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
    );
  }

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
