import 'package:flutter/material.dart';

class DiseaseLibraryPage extends StatelessWidget {

  const DiseaseLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {

    bool isDarkMode =

        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Disease Library",
        ),

        backgroundColor: Colors.brown,
      ),

      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [

          diseaseCard(

            context,

            title: "Apple Scab",

            symptom:
            "Brown and dark spots on leaves.",

            solution:
            "Use fungicide spray and remove infected leaves.",

            color: Colors.orange,

            isDarkMode: isDarkMode,
          ),

          diseaseCard(

            context,

            title: "Black Rot",

            symptom:
            "Dark rotten spots on fruit.",

            solution:
            "Prune infected areas and use copper fungicide.",

            color: Colors.red,

            isDarkMode: isDarkMode,
          ),

          diseaseCard(

            context,

            title: "Rust",

            symptom:
            "Yellow-orange powder on leaves.",

            solution:
            "Use sulfur spray and avoid excess moisture.",

            color: Colors.deepOrange,

            isDarkMode: isDarkMode,
          ),

          diseaseCard(

            context,

            title: "Healthy Plant",

            symptom:
            "Green healthy leaves.",

            solution:
            "Maintain proper sunlight and watering.",

            color: Colors.green,

            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  // ======================================
  // 🌿 DISEASE CARD
  // ======================================
  Widget diseaseCard(

      BuildContext context, {

        required String title,
        required String symptom,
        required String solution,
        required Color color,
        required bool isDarkMode,
      }) {

    return Container(

      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(16),

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

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              CircleAvatar(

                backgroundColor: color,

                child: const Icon(
                  Icons.local_florist,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              Text(

                title,

                style: TextStyle(

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                  color:
                  isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Text(

            "Symptoms",

            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(symptom),

          const SizedBox(height: 15),

          const Text(

            "Solution",

            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(solution),
        ],
      ),
    );
  }
}