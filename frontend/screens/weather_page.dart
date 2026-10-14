import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {

  // ✅ initialCity support
  final String? initialCity;

  const WeatherPage({
    super.key,
    this.initialCity,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final TextEditingController cityController =
      TextEditingController();

  String city = "";
  double temperature = 0;
  int humidity = 0;
  double windSpeed = 0;
  int airQuality = 0;
  String condition = "";

  // ✅ IRRIGATION
  double irrigationPercent = 0;
  String irrigationAdvice = "";

  bool isLoading = false;
  bool hasData = false;

  // ================= INIT STATE =================
  @override
  void initState() {
    super.initState();

    // ✅ Auto-fill + Auto-fetch using initialCity
    if (widget.initialCity != null &&
        widget.initialCity!.trim().isNotEmpty) {

      cityController.text = widget.initialCity!;

      // Auto fetch after UI build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchWeather();
      });
    }
  }

  // ================= FETCH WEATHER =================
  Future<void> fetchWeather() async {

    String cityName = cityController.text.trim();

    if (cityName.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter city name"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
      hasData = false;
    });

    try {

      String apiKey = "API_Key";


      final response = await http.get(

        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric",
        ),
      );

      final data = jsonDecode(response.body);

      if (data["cod"] != 200) {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"]),
          ),
        );

        return;
      }

      double temp =
          double.tryParse(
            data["main"]["temp"].toString(),
          ) ?? 0;

      int hum =
          int.tryParse(
            data["main"]["humidity"].toString(),
          ) ?? 0;

      double wind =
          (double.tryParse(
            data["wind"]["speed"].toString(),
          ) ?? 0) * 3.6;

      String weatherCondition =
          data["weather"][0]["main"];

      double irrigation =
          calculateIrrigation(
            temp,
            hum,
            weatherCondition,
          );

      String advice =
          getIrrigationAdvice(irrigation);

      setState(() {

        city = data["name"];

        temperature = temp;

        humidity = hum;

        windSpeed = wind;

        condition = weatherCondition;

        airQuality = calculateAQI(
          humidity,
          temperature,
        );

        irrigationPercent = irrigation;
        irrigationAdvice = advice;

        isLoading = false;
        hasData = true;
      });

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

  // ================= AIR QUALITY =================
  int calculateAQI(
    int humidity,
    double temp,
  ) {

    int aqi = 50;

    if (humidity > 70) {
      aqi += 40;
    }

    if (temp > 35) {
      aqi += 30;
    }

    return aqi;
  }

  // ================= IRRIGATION =================
  double calculateIrrigation(
    double temp,
    int humidity,
    String condition,
  ) {

    double irrigation = 50;

    if (temp > 35) {
      irrigation += 30;
    }

    else if (temp > 25) {
      irrigation += 15;
    }

    else {
      irrigation -= 10;
    }

    if (humidity < 40) {
      irrigation += 25;
    }

    else if (humidity < 60) {
      irrigation += 10;
    }

    else {
      irrigation -= 15;
    }

    if (condition.toLowerCase().contains("rain")) {
      irrigation -= 40;
    }

    return irrigation.clamp(0, 100);
  }

  // ================= IRRIGATION ADVICE =================
  String getIrrigationAdvice(double irrigation) {

    if (irrigation >= 80) {
      return "High Water Needed";
    }

    else if (irrigation >= 50) {
      return "Moderate Irrigation";
    }

    else {
      return "Low Irrigation Needed";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4FFF6),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Column(

            children: [

              // ================= TOP HEADER =================
              Container(

                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),

                decoration: const BoxDecoration(

                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2E7D32),
                      Color(0xFF66BB6A),
                    ],

                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),

                child: Column(

                  children: [

                    const Text(
                      "🌦️ Smart Weather",

                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Live weather & irrigation updates",

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= SEARCH BOX =================
                    SizedBox(

                      width: 300,

                      child: Container(

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),

                        child: TextField(

                          controller: cityController,

                          decoration: const InputDecoration(

                            hintText: "Enter city name",

                            border: InputBorder.none,

                            prefixIcon:
                                Icon(Icons.location_city),

                            contentPadding:
                                EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ================= BUTTON =================
                    SizedBox(

                      width: 220,
                      height: 48,

                      child: ElevatedButton(

                        onPressed: fetchWeather,

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor: Colors.white,

                          foregroundColor:
                              Colors.green.shade700,

                          elevation: 4,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),

                        child: const Text(

                          "Get Weather",

                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (isLoading)
                const CircularProgressIndicator(),

              // ================= WEATHER RESULT =================
              if (hasData)

                Padding(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),

                  child: Column(

                    children: [

                      // ================= SMALL WEATHER CARD =================
                      Container(

                        width: double.infinity,
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(25),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),

                        child: Row(

                          children: [

                            CircleAvatar(

                              radius: 35,

                              backgroundColor:
                                  Colors.green.shade100,

                              child: const Icon(
                                Icons.cloud,
                                color: Colors.green,
                                size: 40,
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(
                                    city.toUpperCase(),

                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    condition,

                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors
                                          .grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              "${temperature.toStringAsFixed(1)}°C",

                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ================= WEATHER DETAILS =================
                      Row(

                        children: [

                          Expanded(
                            child: infoCard(
                              "Humidity",
                              "$humidity%",
                              Icons.water_drop,
                              Colors.blue,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: infoCard(
                              "Wind",
                              "${windSpeed.toStringAsFixed(1)} km/h",
                              Icons.air,
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(

                        children: [

                          Expanded(
                            child: infoCard(
                              "AQI",
                              airQuality.toString(),
                              Icons.eco,
                              Colors.green,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: infoCard(
                              "Irrigation",
                              "${irrigationPercent.toStringAsFixed(0)}%",
                              Icons.grass,
                              Colors.teal,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ================= IRRIGATION CARD =================
                      Container(

                        width: double.infinity,

                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(25),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: Column(

                          children: [

                            Row(

                              children: [

                                CircleAvatar(

                                  radius: 28,

                                  backgroundColor:
                                      Colors.green.shade100,

                                  child: const Icon(
                                    Icons.grass,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                ),

                                const SizedBox(width: 15),

                                Expanded(

                                  child: Column(

                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      const Text(
                                        "Irrigation Status",

                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),

                                      const SizedBox(
                                          height: 4),

                                      Text(
                                        irrigationAdvice,

                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors
                                              .grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            ClipRRect(

                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),

                              child:
                                  LinearProgressIndicator(

                                value:
                                    irrigationPercent / 100,

                                minHeight: 14,

                                backgroundColor:
                                    Colors.grey.shade300,

                                valueColor:
                                    AlwaysStoppedAnimation(
                                  irrigationPercent > 70
                                      ? Colors.red
                                      : irrigationPercent >
                                              40
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              "${irrigationPercent.toStringAsFixed(0)}% Water Requirement",

                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= INFO CARD =================
  Widget infoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {

    return Container(

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(

        children: [

          CircleAvatar(

            radius: 22,
            backgroundColor:
                color.withOpacity(0.15),

            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,

            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}