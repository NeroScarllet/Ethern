import 'package:ethern/pages/campaign_list_page.dart';
import 'package:flutter/material.dart';

class CampaignSelectedPage extends StatefulWidget {
  const CampaignSelectedPage({super.key});

  @override
  State<CampaignSelectedPage> createState() => _CampaignSelectedPageState();
}

class _CampaignSelectedPageState extends State<CampaignSelectedPage> {
  final double coverHeight = 280;
  final double profileHeight = 144;

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
                'Nome da campanha',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                'Verso',
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
                  controller: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
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
                  controller: null,
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
                  controller: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nome do verso',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
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
