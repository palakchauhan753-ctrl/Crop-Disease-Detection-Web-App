import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class LanguageSelection extends StatelessWidget {

  // 🔵 USER DATA FROM LOGIN PAGE
  final String userName;
  final String userPhone;

  const LanguageSelection({
    super.key,
    required this.userName,
    required this.userPhone,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text("Select Language"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 20),

            Text(
              "Choose Your Language 🌍",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Select the language you want to use in the app",
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

            SizedBox(height: 30),

            // 🔵 ENGLISH CARD
            languageCard(
              context,
              title: "English",
              subtitle: "Use app in English",
              icon: Icons.language,
              language: "English",
            ),

            SizedBox(height: 15),

            // 🔵 HINDI CARD
            languageCard(
              context,
              title: "हिंदी",
              subtitle: "ऐप हिंदी में उपयोग करें",
              icon: Icons.translate,
              language: "Hindi",
            ),
          ],
        ),
      ),
    );
  }

  // 🔵 LANGUAGE CARD
  Widget languageCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String language,
  }) {
    return InkWell(

      borderRadius: BorderRadius.circular(18),

      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardPage(

              // ✅ REAL USER DATA
              name: userName,
              email: userPhone,
              language: language,
            ),
          ),
        );
      },

      child: Container(
        padding: EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            ),
          ],
        ),

        child: Row(
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.green.shade100,

              child: Icon(
                icon,
                color: Colors.green,
                size: 28,
              ),
            ),

            SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              color: Colors.green,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}