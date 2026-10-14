import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  List historyList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  // ✅ FETCH HISTORY
  Future<void> fetchHistory() async {

    try {

      final response = await http.get(

        Uri.parse(
          "http://127.0.0.1:5000/history",
        ),
      );

      // ✅ STATUS CHECK
      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        setState(() {

          historyList = data;

          isLoading = false;
        });

      } else {

        setState(() {

          isLoading = false;
        });
      }

    } catch (e) {

      setState(() {

        isLoading = false;
      });

      print("History Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode =

        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor:
      isDarkMode
          ? Colors.black
          : Colors.grey.shade100,

      appBar: AppBar(

        title: const Text("History"),

        backgroundColor: Colors.green,
      ),

      body:

      // ✅ LOADING
      isLoading

          ? const Center(
        child: CircularProgressIndicator(),
      )

      // ✅ NO DATA
          : historyList.isEmpty

          ? Center(

        child: Text(

          "No History Found",

          style: TextStyle(

            fontSize: 18,

            color:
            isDarkMode
                ? Colors.white
                : Colors.black,
          ),
        ),
      )

      // ✅ HISTORY LIST
          : ListView.builder(

        padding: const EdgeInsets.all(10),

        itemCount: historyList.length,

        itemBuilder: (context, index) {

          final item = historyList[index];

          return Card(

            color:
            isDarkMode
                ? Colors.grey.shade900
                : Colors.white,

            margin:
            const EdgeInsets.only(bottom: 12),

            shape: RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(15),
            ),

            child: ListTile(

              leading: const Icon(

                Icons.local_florist,

                color: Colors.green,
              ),

              title: Text(

                item["title"] ?? "",

                style: TextStyle(

                  fontWeight: FontWeight.bold,

                  color:
                  isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),

              subtitle: Text(

                item["subtitle"] ?? "",

                style: TextStyle(

                  color:
                  isDarkMode
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),

              trailing: SizedBox(

                width: 80,

                child: Text(

                  item["date"] ?? "",

                  style: TextStyle(

                    fontSize: 10,

                    color:
                    isDarkMode
                        ? Colors.white70
                        : Colors.black54,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}