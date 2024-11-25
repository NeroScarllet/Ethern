// ignore_for_file: unnecessary_string_escapes, non_constant_identifier_names, file_names

import 'package:ethern/pages/campaign_selected_page.dart';
import 'package:flutter/material.dart';

class CampaignPreviewTile extends StatelessWidget {
  final String ImagePath;
  final String Name;
  final String campaignId; // Adicionado para passar o ID da campanha

  const CampaignPreviewTile({
    super.key,
    required this.ImagePath,
    required this.Name,
    required this.campaignId, // Adicionado para receber o ID da campanha
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
              builder: (context) => CampaignSelectedPage(campaignId: campaignId), // Passando o ID da campanha
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(12),
          width: 270,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black54,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  ImagePath.isNotEmpty ? ImagePath : 'https://i.sstatic.net/mwFzF.png',
                  height: 160,
                  width: 270,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://i.sstatic.net/mwFzF.png',
                      height: 160,
                      width: 270,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                child: Text(
                  Name,
                  style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: 'MedievalSharp'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
