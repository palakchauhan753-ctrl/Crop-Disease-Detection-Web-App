import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() =>
      _StatisticsPageState();
}

class _StatisticsPageState
    extends State<StatisticsPage> {

  // ✅ HISTORY LIST
  List historyList = [];

  int totalScans = 0;
  int healthyCount = 0;
  int diseasedCount = 0;

  String commonDisease = "None";

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  // ==========================================
  // 📊 FETCH HISTORY + CALCULATE STATS
  // ==========================================
  Future<void> fetchStatistics() async {

    final response = await http.get(

      Uri.parse(
        "http://127.0.0.1:5000/history",
      ),
    );

    if (response.statusCode == 200) {

      historyList =
      jsonDecode(response.body);

      totalScans =
          historyList.length;

      Map<String, int> diseaseMap = {};

      healthyCount = 0;
      diseasedCount = 0;

      for (var item in historyList) {

        String title =
        item["title"]
            .toString()
            .toLowerCase();

        // ✅ HEALTHY COUNT
        if (title.contains("healthy")) {

          healthyCount++;

        } else {

          diseasedCount++;
        }

        // ✅ MOST COMMON DISEASE
        diseaseMap[title] =
            (diseaseMap[title] ?? 0) + 1;
      }

      // ✅ FIND MOST COMMON
      int maxCount = 0;

      diseaseMap.forEach((key, value) {

        if (value > maxCount) {

          maxCount = value;

          commonDisease = key;
        }
      });

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode =

        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Farm Statistics",
        ),

        backgroundColor: Colors.teal,
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: GridView.count(

          crossAxisCount: 4,

          crossAxisSpacing: 15,

          mainAxisSpacing: 15,

          children: [

            statCard(
              "$totalScans",
              "Total Scans",
              Icons.document_scanner,
              Colors.blue,
              isDarkMode,
            ),

            statCard(
              "$healthyCount",
              "Healthy",
              Icons.check_circle,
              Colors.green,
              isDarkMode,
            ),

            statCard(
              "$diseasedCount",
              "Diseased",
              Icons.warning,
              Colors.red,
              isDarkMode,
            ),

            statCard(
              commonDisease,
              "Common Disease",
              Icons.coronavirus,
              Colors.orange,
              isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 📦 STAT CARD
  // ==========================================
  Widget statCard(

      String value,
      String title,
      IconData icon,
      Color color,
      bool isDarkMode,
      ) {

    return Container(

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

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            color: color,
            size: 30,
          ),

          const SizedBox(height: 6),

          Text(

            value,

            style: TextStyle(

              fontSize: 24,

              fontWeight:
              FontWeight.bold,

              color:
              isDarkMode
                  ? Colors.white
                  : Colors.black,
            ),
          ),

          const SizedBox(height: 8),

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
        ],
      ),
    );
  }
}