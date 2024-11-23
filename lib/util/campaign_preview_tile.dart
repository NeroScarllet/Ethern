// ignore_for_file: unnecessary_string_escapes, non_constant_identifier_names, file_names

import 'package:ethern/pages/campaign_selected_page.dart';
import 'package:flutter/material.dart';

class CampaignPreviewTile extends StatelessWidget {
  final String ImagePath;
  final String Name;

  const CampaignPreviewTile({
    super.key,
    required this.ImagePath,
    required this.Name,
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
              builder: (context) => const CampaignSelectedPage(),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(12),
          
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black54,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(ImagePath, width: 270,),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
        
                  children: [
                    Text(
                      Name,
                      style: TextStyle(fontSize: 25, color: Colors.white, fontFamily: 'MedievalSharp'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
