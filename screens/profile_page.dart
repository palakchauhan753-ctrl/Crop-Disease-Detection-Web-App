import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  final String name;
  final String email;
  final String language;

  const ProfilePage({

    super.key,

    required this.name,
    required this.email,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {

    // ✅ THEME CHECK
    bool isDarkMode =

        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor:
      isDarkMode
          ? Colors.black
          : Colors.grey.shade100,

      appBar: AppBar(

        title: const Text(
          "Profile",
        ),

        centerTitle: true,

        flexibleSpace: Container(

          decoration: BoxDecoration(

            gradient: LinearGradient(

              colors: isDarkMode

                  ? [
                Colors.black,
                Colors.grey.shade800,
              ]

                  : [
                Colors.green.shade700,
                Colors.green.shade400,
              ],
            ),
          ),
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 20),

            // 👤 PROFILE IMAGE
            CircleAvatar(

              radius: 55,

              backgroundColor:
              Colors.green,

              child: Text(

                name[0].toUpperCase(),

                style: const TextStyle(

                  fontSize: 40,

                  color: Colors.white,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 📋 PROFILE CARD
            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color:
                isDarkMode
                    ? Colors.grey.shade900
                    : Colors.white,

                borderRadius:
                BorderRadius.circular(20),

                boxShadow: [

                  BoxShadow(

                    color:
                    Colors.black.withOpacity(0.08),

                    blurRadius: 6,

                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(

                children: [

                  profileTile(

                    icon: Icons.person,

                    title: "Name",

                    value: name,

                    isDarkMode:
                    isDarkMode,
                  ),

                  const SizedBox(height: 15),

                  profileTile(

                    icon: Icons.email,

                    title: "Email",

                    value: email,

                    isDarkMode:
                    isDarkMode,
                  ),

                  const SizedBox(height: 15),

                  profileTile(

                    icon: Icons.language,

                    title: "Language",

                    value: language,

                    isDarkMode:
                    isDarkMode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 📦 PROFILE TILE
  // ==========================================
  Widget profileTile({

    required IconData icon,
    required String title,
    required String value,
    required bool isDarkMode,
  }) {

    return Row(

      children: [

        Icon(

          icon,

          color: Colors.green,

          size: 28,
        ),

        const SizedBox(width: 15),

        Expanded(

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(

                title,

                style: TextStyle(

                  fontSize: 14,

                  color:
                  isDarkMode
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),

              const SizedBox(height: 3),

              Text(

                value,

                style: TextStyle(

                  fontSize: 18,

                  fontWeight:
                  FontWeight.bold,

                  color:
                  isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}