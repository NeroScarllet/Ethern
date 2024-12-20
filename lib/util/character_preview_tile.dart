// ignore_for_file: unnecessary_string_escapes, non_constant_identifier_names, file_names

import 'package:ethern/pages/character_selected_page.dart';
import 'package:flutter/material.dart';

class CharacterPreviewTile extends StatelessWidget {
  final String ImagePath;
  final String Name;
  final String Race;
  final String Campaign;
  final String characterId;  // Adicionado para passar o ID do personagem

  const CharacterPreviewTile({
    super.key,
    required this.ImagePath,
    required this.Name,
    required this.Race,
    required this.Campaign,
    required this.characterId,  // Adicionado para receber o ID do personagem
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterSelectedPage(characterId: characterId),  // Passando o ID do personagem
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(12),
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black54,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  ImagePath.isNotEmpty ? ImagePath : 'https://i.sstatic.net/mwFzF.png',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Name,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(Race, style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Campaign, style: TextStyle(color: Colors.white)),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
