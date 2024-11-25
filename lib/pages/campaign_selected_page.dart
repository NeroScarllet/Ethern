import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CampaignSelectedPage extends StatefulWidget {
  final String? campaignId; // Agora aceita um campaignId opcional

  const CampaignSelectedPage({super.key, this.campaignId});

  @override
  State<CampaignSelectedPage> createState() => _CampaignSelectedPageState();
}

class Campaign {
  String nome;
  String verso;
  String sobre;
  String? imageUrl; // Adicionado para armazenar a URL da imagem

  Campaign({
    required this.nome,
    required this.verso,
    required this.sobre,
    this.imageUrl, // Inicializando a URL da imagem
  });

  @override
  String toString() {
    return 'Campaign(nome: $nome, verso: $verso, sobre: $sobre, imageUrl: $imageUrl)';
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'verso': verso,
      'sobre': sobre,
      'imageUrl': imageUrl,
    };
  }
}

class _CampaignSelectedPageState extends State<CampaignSelectedPage> {
  final double coverHeight = 280;
  final double profileHeight = 144;
  final _nameController = TextEditingController();
  final _verseController = TextEditingController();
  final _aboutController = TextEditingController();
  final TextEditingController _urlController =
      TextEditingController(); // Controller para a URL da imagem
  String?
      _profileImageUrl; // Adicionado para armazenar a URL da imagem de perfil

  @override
  void initState() {
    super.initState();
    if (widget.campaignId != null) {
      _loadCampaignData();
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
        widget.campaignId != null) {
      String userId = currentUser.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('campaigns')
          .doc(widget.campaignId!)
          .update({'imageUrl': _profileImageUrl});
    }
  }

  Future<void> _loadCampaignData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && widget.campaignId != null) {
      String userId = currentUser.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('campaigns')
          .doc(widget.campaignId!)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _nameController.text = data['nome'];
          _verseController.text = data['verso'];
          _aboutController.text = data['sobre'];
          _profileImageUrl = data['imageUrl']; // Carregar a URL da imagem
        });
      }
    }
  }

  Future<void> createCampaign() async {
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

    Campaign campaign = Campaign(
      nome: _nameController.text,
      verso: _verseController.text,
      sobre: _aboutController.text,
      imageUrl: _profileImageUrl, // Adicionar a URL da imagem
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      if (widget.campaignId != null) {
        // Atualizar a campanha existente
        await firestore
            .collection('users')
            .doc(userId)
            .collection('campaigns')
            .doc(widget.campaignId!)
            .update(campaign.toMap());
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Campanha atualizada com sucesso!"),
            );
          },
        );
      } else {
        // Criar uma nova campanha
        await firestore
            .collection('users')
            .doc(userId)
            .collection('campaigns')
            .add(campaign.toMap());
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Campanha adicionada com sucesso!"),
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Erro ao salvar campanha: $e"),
          );
        },
      );
    }
  }

  Future<void> deleteCampaign() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || widget.campaignId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content:
                Text('Nenhum usuário está logado ou campaignId está vazio.'),
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
          .collection('campaigns')
          .doc(widget.campaignId!)
          .delete();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Campanha apagada com sucesso!"),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Erro ao apagar campanha: $e"),
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
                    : 'Nome da campanha',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                _verseController.text.isNotEmpty
                    ? _verseController.text
                    : 'Verso da campanha',
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
                        : 'Sobre a campanha',
                  ),
                ),
              ),
            ),
            Divider(),
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
                  controller: _nameController,
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
              'Verso da campanha',
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
                  controller: _verseController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Verso da campanha',
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
                onTap: createCampaign,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Salvar Campanha',
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
                onTap: deleteCampaign,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      'Deletar Campanha',
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
        title: Text("Campanha"),
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
                    'https://i.sstatic.net/mwFzF.png'),
          ),
        ),
      );
}
