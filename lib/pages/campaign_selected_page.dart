import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethern/pages/campaign_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CampaignSelectedPage extends StatefulWidget {
  final String? campaignId; // O campaignId é agora opcional

  const CampaignSelectedPage({super.key, this.campaignId});

  @override
  State<CampaignSelectedPage> createState() => _CampaignSelectedPageState();
}

class Campaign {
  String nome;
  String verso;
  String sobre;

  Campaign({
    required this.nome,
    required this.verso,
    required this.sobre,
  });

  @override
  String toString() {
    return 'Campaign(nome: $nome, verso: $verso, sobre: $sobre)';
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'verso': verso,
      'sobre': sobre,
    };
  }
}

class _CampaignSelectedPageState extends State<CampaignSelectedPage> {
  final double coverHeight = 280;
  final double profileHeight = 144;
  final _nameController = TextEditingController();
  final _verseController = TextEditingController();
  final _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.campaignId != null) {
      _loadCampaignData();
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
          .doc(widget.campaignId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _nameController.text = data['nome'];
          _verseController.text = data['verso'];
          _aboutController.text = data['sobre'];
        });
      }
    }
  }

  Future createCampaign() async {
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
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      if (widget.campaignId == null) {
        await firestore
            .collection('users')
            .doc(userId)
            .collection('campaigns')
            .add(campaign.toMap());
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Campanha adicionada com sucesso!"),
            );
          },
        );
      } else {
        await firestore
            .collection('users')
            .doc(userId)
            .collection('campaigns')
            .doc(widget.campaignId)
            .update(campaign.toMap());
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Campanha atualizada com sucesso!"),
            );
          },
        );
      }
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CampaignListPage()));
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Erro ao adicionar campanha: $e"),
          );
        },
      );
    }
  }

  Future deleteCampaign() async {
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
          .doc(widget.campaignId)
          .delete();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CampaignListPage()));
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
                    builder: (context) => const CampaignListPage()));
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
                _nameController.text, // Nome da campanha
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                _verseController.text, // Nome do verso
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
                    hintText: _aboutController.text, // Descrição da campanha
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
                    hintText: _nameController.text, // Nome da campanha
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Nome do verso',
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
                    hintText: _verseController.text, // Nome do verso
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
