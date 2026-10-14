import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DiseaseDetectionPage extends StatefulWidget {
  const DiseaseDetectionPage({super.key});

  @override
  State<DiseaseDetectionPage> createState() =>
      _DiseaseDetectionPageState();
}

class _DiseaseDetectionPageState
    extends State<DiseaseDetectionPage> {

  File? imageFile;
  Uint8List? webImage;

  String disease = "";
  String solution = "";

  double confidence = 0;

  bool isLoading = false;

  final ImagePicker picker = ImagePicker();

  // ⭐ SAVE HISTORY
  Future<void> saveToHistory(
    String title,
    String subtitle,
    double conf,
  ) async {

    try {

      await http.post(

        Uri.parse(
          "http://127.0.0.1:5000/save_history",
        ),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "title": title,
          "subtitle": subtitle,
          "confidence": conf,
          "date": DateTime.now().toString(),

        }),
      );

    } catch (e) {

      print("History Save Error: $e");
    }
  }

  // 🖼 GALLERY
  Future<void> pickFromGallery() async {

    final XFile? picked =
    await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (picked != null) {

      if (kIsWeb) {

        final bytes =
        await picked.readAsBytes();

        setState(() {

          webImage = bytes;
        });

      } else {

        setState(() {

          imageFile = File(picked.path);
        });
      }

      // RESET
      setState(() {

        disease = "";
        solution = "";
        confidence = 0;
      });
    }
  }

  // 🌿 SOLUTION LOGIC
  String getSolution(String diseaseName) {

    switch (diseaseName.toLowerCase()) {

      case "apple_scab":
        return "Use fungicide spray and remove infected leaves.";

      case "black_rot":
        return "Prune infected branches and apply copper-based fungicide.";

      case "rust":
        return "Use sulfur spray and avoid excess moisture on leaves.";

      case "healthy":
        return "Your plant looks healthy. Maintain proper watering and sunlight.";

      default:
        return "No solution available.";
    }
  }

  // 🤖 DETECT DISEASE
  Future<void> detectDisease() async {

    if (!hasImage) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            "Please upload image first",
          ),
        ),
      );

      return;
    }

    setState(() {

      isLoading = true;
    });

    try {

      // 🔥 BACKEND URL
      var uri = Uri.parse(
        "http://127.0.0.1:5000/predict",
      );

      var request =
      http.MultipartRequest(
        "POST",
        uri,
      );

      // 🌐 WEB
      if (kIsWeb) {

        request.files.add(

          http.MultipartFile.fromBytes(
            "image",
            webImage!,
            filename: "image.jpg",
          ),
        );

      } else {

        // 📱 MOBILE
        request.files.add(

          await http.MultipartFile.fromPath(
            "image",
            imageFile!.path,
          ),
        );
      }

      // 🔥 SEND REQUEST
      var response =
      await request.send();

      var res =
      await http.Response.fromStream(response);

      // ✅ SERVER ERROR CHECK
      if (res.statusCode != 200) {

        throw Exception("Server Error");
      }

      // 🔥 JSON DATA
      var data =
      jsonDecode(res.body);

      // ✅ BACKEND ERROR CHECK
      if (data["error"] != null) {

        throw Exception(data["error"]);
      }

      String detectedDisease =
      data["disease"];

      double detectedConfidence =
      double.parse(
        data["confidence"].toString(),
      );

      String detectedSolution =
      getSolution(detectedDisease);

      setState(() {

        disease = detectedDisease;

        confidence =
            detectedConfidence;

        solution =
            detectedSolution;

        isLoading = false;
      });

      // ⭐ SAVE HISTORY
      await saveToHistory(

        "${disease.toUpperCase()} Detected",

        solution,

        confidence,
      );

    } catch (e) {

      setState(() {

        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  // ✅ IMAGE CHECK
  bool get hasImage =>

      kIsWeb
          ? webImage != null
          : imageFile != null;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "Disease Detection",
        ),

        centerTitle: true,

        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(

        padding: EdgeInsets.all(16),

        child: Column(

          children: [

            // 🖼 IMAGE BOX
            Container(

              height: 220,
              width: double.infinity,

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(15),

                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),

              child: hasImage

                  ? ClipRRect(

                borderRadius:
                BorderRadius.circular(15),

                child: kIsWeb

                    ? Image.memory(
                  webImage!,
                  fit: BoxFit.contain,
                )

                    : Image.file(
                  imageFile!,
                  fit: BoxFit.contain,
                ),
              )

                  : Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.image,
                    size: 70,
                    color: Colors.green,
                  ),

                  SizedBox(height: 10),

                  Text(

                    "No Image Selected",

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // BUTTONS
            SingleChildScrollView(

              scrollDirection: Axis.horizontal,

              child: Row(

                children: [

                  // GALLERY
                  ElevatedButton.icon(

                    onPressed:
                    pickFromGallery,

                    icon: Icon(
                      Icons.photo,
                    ),

                    label: Text(
                      "Gallery",
                    ),

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      Colors.green,

                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  // RESET
                  if (hasImage)

                    ElevatedButton.icon(

                      onPressed: () {

                        setState(() {

                          imageFile = null;
                          webImage = null;

                          disease = "";
                          solution = "";
                          confidence = 0;
                        });
                      },

                      icon: Icon(
                        Icons.refresh,
                      ),

                      label: Text(
                        "Reset",
                      ),

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        Colors.orange,

                        padding:
                        EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // DETECT BUTTON
            if (hasImage)

              SizedBox(

                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(

                  onPressed:
                  isLoading
                      ? null
                      : detectDisease,

                  icon: Icon(
                    Icons.search,
                  ),

                  label: Text(

                    "Detect Disease",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.green,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 20),

            // LOADING
            if (isLoading)

              Column(

                children: [

                  CircularProgressIndicator(),

                  SizedBox(height: 12),

                  Text(

                    "Detecting disease...",

                    style: TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),

            SizedBox(height: 20),

            // RESULT
            if (disease.isNotEmpty)

              Container(

                width: double.infinity,

                padding: EdgeInsets.all(18),

                decoration: BoxDecoration(

                  color:
                  Colors.green.shade50,

                  borderRadius:
                  BorderRadius.circular(15),

                  border: Border.all(
                    color: Colors.green,
                  ),
                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      "Disease Detected",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    SizedBox(height: 15),

                    Text(

                      "Disease: $disease",

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(

                      "Confidence: ${confidence.toStringAsFixed(2)}%",

                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(height: 10),

                    LinearProgressIndicator(

                      value:
                      confidence / 100,

                      minHeight: 10,

                      backgroundColor:
                      Colors.grey.shade300,

                      color: Colors.green,
                    ),

                    SizedBox(height: 18),

                    Text(

                      "Solution:",

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(

                      solution,

                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}