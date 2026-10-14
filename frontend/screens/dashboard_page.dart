import 'package:flutter/material.dart';

import '../main.dart';
import 'disease_detection_page.dart';
import 'weather_page.dart';
import 'history_page.dart';
import 'voice_page.dart';
import 'statistics_page.dart';
import 'disease_library_page.dart';

class DashboardPage extends StatefulWidget {
  final String name;
  final String email;
  final String language;

  const DashboardPage({
    super.key,
    required this.name,
    required this.email,
    required this.language,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  String getText(String english, String hindi) {
    return widget.language == "Hindi"
        ? hindi
        : english;
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      // ================= DRAWER =================
      drawer: Drawer(
        child: Column(
          children: [

            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),

              //accountName: Text(widget.name),
              //accountEmail: Text(widget.email),

              accountName: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  ),
              ),

              accountEmail: Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),

              currentAccountPicture:
              const CircleAvatar(
                backgroundColor: Colors.white,

                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.green,
                ),
              ),
            ),

            SwitchListTile(

              secondary: Icon(
                isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),

              title: Text(
                getText(
                  "Dark Mode",
                  "डार्क मोड",
                ),
              ),

              value: isDarkMode,

              onChanged: (value) {
                MyApp.of(context)?.toggleTheme();
              },
            ),
          ],
        ),
      ),

      backgroundColor:
      isDarkMode
          ? Colors.black
          : Colors.green.shade700,

      // ================= APPBAR =================
      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.transparent,

        centerTitle: true,

        // ===== LEFT SIDE WELCOME =====
        leadingWidth: 320,

        leading: Builder(
          builder: (context) => Row(
            children: [

              IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),

              Expanded(
                child: Text(
                  getText(
                    "Welcome ${widget.name}",
                    "स्वागत ${widget.name}",
                  ),

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ===== CENTER TITLE =====
        title: const Text(

          "Crop Doctor 🌿",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 40,
          ),
        ),
      ),

      // ================= BODY =================
      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ================= TITLE =================
              Text(

                getText(
                  "Home Screen",
                  "होम स्क्रीन",
                ),

                style: const TextStyle(

                  fontSize: 32,

                  fontWeight: FontWeight.bold,

                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              Text(

                getText(
                  "Smart Farming Dashboard",
                  "स्मार्ट खेती डैशबोर्ड",
                ),

                style: const TextStyle(

                  fontSize: 16,

                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 35),

              // ================= ICON ROW =================
              Expanded(

                child: Row(

                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,

                  crossAxisAlignment:
                  CrossAxisAlignment.center,

                  children: [

                    dashboardCard(

                      title: getText(
                        "Disease",
                        "रोग",
                      ),

                      icon:
                      Icons.local_florist,

                      color: Colors.green,

                      page:
                      const DiseaseDetectionPage(),
                    ),

                    dashboardCard(

                      title: getText(
                        "Weather",
                        "मौसम",
                      ),

                      icon: Icons.cloud,

                      color: Colors.blue,

                      page:
                      const WeatherPage(),
                    ),

                    dashboardCard(

                      title: getText(
                        "History",
                        "इतिहास",
                      ),

                      icon: Icons.history,

                      color: Colors.orange,

                      page:
                      const HistoryPage(),
                    ),

                    dashboardCard(

                      title: getText(
                        "Voice AI",
                        "वॉइस AI",
                      ),

                      icon: Icons.mic,

                      color: Colors.purple,

                      page:
                      //const VoicePage(),
                      VoicePage(userName: widget.name),
                    ),

                    dashboardCard(

                      title: getText(
                        "Statistics",
                        "आंकड़े",
                      ),

                      icon: Icons.bar_chart,

                      color: Colors.teal,

                      page:
                      const StatisticsPage(),
                    ),

                    dashboardCard(

                      title: getText(
                        "Library",
                        "लाइब्रेरी",
                      ),

                      icon: Icons.menu_book,

                      color: Colors.red,

                      page:
                      const DiseaseLibraryPage(),
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

  // ================= CARD =================
  Widget dashboardCard({

    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [

          Container(

            width: 150,
            height: 200,

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(18),

              boxShadow: [

                BoxShadow(

                  color:
                  Colors.black.withOpacity(0.2),

                  blurRadius: 8,

                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Center(

              child: Icon(
                icon,
                size: 80,
                color: color,
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(

            width: 90,

            child: Text(

              title,

              textAlign: TextAlign.center,

              style: const TextStyle(

                color: Colors.white,

                fontWeight: FontWeight.bold,

                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}