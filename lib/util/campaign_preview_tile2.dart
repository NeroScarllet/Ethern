// ignore_for_file: non_constant_identifier_names

import 'package:ethern/pages/campaign_selected_page.dart';
import 'package:flutter/material.dart';

class CampaignPreviewTile2 extends StatelessWidget {
  final String ImagePath;
  final String Name;
  final String Description;
  final String campaignId; // Adicionado para passar o ID da campanha

  const CampaignPreviewTile2({
    super.key,
    required this.ImagePath,
    required this.Name,
    required this.Description,
    required this.campaignId, // Adicionado para receber o ID da campanha
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
              builder: (context) => CampaignSelectedPage(
                  campaignId: campaignId), // Passando o ID da campanha
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
                        maxLines: 4,
                        style: TextStyle(color: Colors.grey[400]),
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
