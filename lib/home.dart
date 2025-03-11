import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'counter_page.dart'; // Import CounterPage
import 'api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> counters = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

  Future<void> _loadCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final String? countersJson = prefs.getString('counters');
    if (countersJson != null) {
      setState(() {
        counters = List<Map<String, String>>.from(
            json.decode(countersJson).map((item) => Map<String, String>.from(item)));
      });
    }
  }

  Future<void> _saveCounters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('counters', json.encode(counters));
  }

  Future<void> _showAddCounterDialog() async {
    String namespace = "";
    String keyName = "";
    String initialValue = "";

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Counter"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Namespace"),
                onChanged: (value) => namespace = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Key Name"),
                onChanged: (value) => keyName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Initial Value"),
                keyboardType: TextInputType.number,
                onChanged: (value) => initialValue = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (namespace.isNotEmpty && keyName.isNotEmpty && initialValue.isNotEmpty) {
                  int? initVal = int.tryParse(initialValue);
                  if (initVal != null) {
                    int? result = await _apiService.createCounter(context, namespace, keyName, initVal);
                    if (result != null && result > 0) {
                      setState(() {
                        counters.add({"namespace": namespace, "key": keyName});
                      });
                      await _saveCounters();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Counter created successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to create counter"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 216, 92, 52),
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 216, 92, 52),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: const Center(
                child: Text(
                  'Counters',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: counters.length,
                itemBuilder: (context, index) {
                  final config = counters[index];
                  return ListTile(
                    leading: const Icon(Icons.api_outlined),
                    title: Text("${config['key']} ( ${config['namespace']} )"),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CounterPage(
                            namespace: config['namespace']!,
                            keyName: config['key']!,
                          ),
                        ),
                      );
                      _loadCounters(); 
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          counters.removeAt(index);
                        });
                        _saveCounters();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Counter deleted"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _showAddCounterDialog,
                child: const Text("Add New Counter"),
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select a counter from the drawer",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30,),
            Text(
              "Made by Aditya Bhardwaj ",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
