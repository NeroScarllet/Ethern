// ignore_for_file: non_constant_identifier_names

import 'package:ethern/pages/character_selected_page.dart';
import 'package:flutter/material.dart';

class CharacterPreviewTile2 extends StatelessWidget {
  final String ImagePath;
  final String Name;
  final String Description;
  final String Race;
  final String Campaign;
  final String characterId;  // Adicionado para passar o ID do personagem

  const CharacterPreviewTile2({
    super.key,
    required this.ImagePath,
    required this.Name,
    required this.Description,
    required this.Race,
    required this.Campaign,
    required this.characterId,  // Adicionado para receber o ID do personagem
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          padding: EdgeInsets.all(8),
          width: 200,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black54,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                ImagePath,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Name,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        Description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            Race,
                            style: TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              Campaign,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
