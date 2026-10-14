import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'weather_page.dart';
import 'history_page.dart';

// ✅ ADD THESE PAGES
import 'disease_library_page.dart';
import 'statistics_page.dart';
import 'disease_detection_page.dart';

class VoicePage extends StatefulWidget {

  final String userName;

  const VoicePage({
    super.key,
    required this.userName,
  });

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {

  late stt.SpeechToText speech;

  final FlutterTts flutterTts = FlutterTts();

  bool isListening = false;
  bool isNavigating = false;

  String text = "Press mic and speak...";

  @override
  void initState() {

    super.initState();

    speech = stt.SpeechToText();

    initTTS();
  }

  Future<void> initTTS() async {

    await flutterTts.setLanguage("en-US");

    await flutterTts.setSpeechRate(0.5);

    await flutterTts.setPitch(1.0);
  }

  Future<void> speak(String message) async {

    await flutterTts.stop();

    await flutterTts.speak(message);
  }

  Future<void> openPage(Widget page) async {

    if (isNavigating) return;

    isNavigating = true;

    stopListening();

    await Navigator.push(

      context,

      MaterialPageRoute(
        builder: (_) => page,
      ),
    );

    isNavigating = false;
  }

  // ================= CITY EXTRACTION =================
  String extractCity(String command) {

    command = command.toLowerCase().trim();

    List<String> prefixes = [

      "open weather of",
      "open weather in",
      "open weather",
      "weather of",
      "weather in",
      "show weather of",
      "show weather in",
      "temperature in",
      "temperature of",
    ];

    for (String prefix in prefixes) {

      if (command.startsWith(prefix)) {

        return command
            .replaceFirst(prefix, "")
            .trim();
      }
    }

    return "";
  }

  // ================= START LISTENING =================
  Future<void> startListening() async {

    if (isListening) return;

    bool available = await speech.initialize();

    if (!available) {

      setState(() => text = "Speech not available");

      return;
    }

    setState(() {

      isListening = true;

      text = "Listening...";
    });

    speech.listen(

      listenFor: const Duration(seconds: 10),

      pauseFor: const Duration(seconds: 2),

      onResult: (result) {

        if (result.finalResult) {

          String command =
              result.recognizedWords
                  .toLowerCase()
                  .trim();

          setState(() => text = command);

          checkCommand(command);
        }
      },
    );
  }

  // ================= STOP LISTENING =================
  void stopListening() {

    speech.stop();

    if (mounted) {

      setState(() => isListening = false);
    }
  }

  // ================= COMMAND ENGINE =================
  void checkCommand(String command) async {

    stopListening();

    // 🌦 WEATHER COMMAND
    if (command.contains("weather") ||
        command.contains("temperature")) {

      String city = extractCity(command);

      await speak(

        city.isEmpty
            ? "Opening weather page"
            : "Opening weather for $city",
      );

      await Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) => WeatherPage(

            initialCity:
                city.isNotEmpty ? city : null,
          ),
        ),
      );
    }

    // 📚 LIBRARY PAGE
    else if (command.contains("library") ||
        command.contains("open library")) {

      await speak("Opening library");

      openPage(const DiseaseLibraryPage());
    }

    // 📊 FARMER STAT PAGE
    //else if (command.contains("farmer stat") ||
        //command.contains("open farmer stat")) {

      //await speak("Opening farmer stat");

      //openPage(const StatisticsPage());
    //}
    // 📊 FARMER STAT PAGE
else if (

    command.contains("farmer stat") ||
    command.contains("farmers stat") ||
    command.contains("farmer stats") ||
    command.contains("farmer statistics") ||
    command.contains("statistics") ||
    command.contains("stats") ||
    command.contains("open farmer stat") ||
    command.contains("open statistics") ||
    command.contains("open stats")

) {

  await speak("Opening farmer statistics");

  openPage(const StatisticsPage());
}

    // 🖼 IMAGE UPLOAD PAGE
    else if (command.contains("image upload") ||
        command.contains("upload image") ||
        command.contains("open image upload") ||
        command.contains("detect disease") ||
        command.contains("open camera")) {

      await speak("Opening image upload page");

      openPage(const DiseaseDetectionPage());
    }

    // 📜 HISTORY PAGE
    else if (command.contains("history")) {

      await speak("Opening history page");

      openPage(const HistoryPage());
    }

    // ❌ UNKNOWN COMMAND
    else {

      setState(() =>
          text = "Command not recognized");

      await speak("Command not recognized");
    }
  }

  @override
  void dispose() {

    speech.stop();

    flutterTts.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.green.shade50,

      appBar: AppBar(

        title: const Text("Smart Voice AI"),

        backgroundColor: Colors.green,

        centerTitle: true,
      ),

      body: Center(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                // ================= MIC ANIMATION =================
                AnimatedContainer(

                  duration:
                      const Duration(milliseconds: 300),

                  padding: const EdgeInsets.all(30),

                  decoration: BoxDecoration(

                    shape: BoxShape.circle,

                    color: isListening
                        ? Colors.green.shade200
                        : Colors.green.shade100,
                  ),

                  child: Icon(

                    isListening
                        ? Icons.mic
                        : Icons.mic_none,

                    size: 90,

                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 30),

                // ================= RESULT TEXT =================
                Container(

                  padding: const EdgeInsets.all(15),

                  width: double.infinity,

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(15),

                    border:
                        Border.all(color: Colors.green),
                  ),

                  child: Text(

                    text,

                    textAlign: TextAlign.center,

                    style:
                        const TextStyle(fontSize: 18),
                  ),
                ),

                const SizedBox(height: 30),

                // ================= BUTTON =================
                ElevatedButton.icon(

                  onPressed:
                      isListening
                          ? stopListening
                          : startListening,

                  icon: Icon(
                    isListening
                        ? Icons.stop
                        : Icons.mic,
                  ),

                  label: Text(
                    isListening ? "Stop" : "Start",
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // ================= HINTS BELOW BUTTON =================
                Container(

                  width: double.infinity,

                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(15),

                    border: Border.all(
                      color: Colors.green.shade300,
                    ),
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: const [

                      Text(
                        "🎤 Supported Commands",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "• Open weather in Delhi",
                      ),

                      SizedBox(height: 5),

                      Text(
                        "• Weather in Mumbai",
                      ),

                      SizedBox(height: 5),

                      Text(
                        "• Open library",
                      ),

                      SizedBox(height: 5),

                      Text(
                        "• Open farmer stat",
                      ),

                      SizedBox(height: 5),

                      Text(
                        "• Open history",
                      ),

                      SizedBox(height: 5),

                      Text(
                        "• Open image upload",
                      ),

                      SizedBox(height: 5),

                      Text(
                        "• Detect disease",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}