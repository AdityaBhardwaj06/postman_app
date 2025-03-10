import 'package:flutter/material.dart';
import 'counter_page.dart'; // Import CounterPage
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, String>> counters = [
    {"namespace": "Standard", "key": "Counter1"},
  ];

  Future<bool> _createNewCounter(String namespace, String keyName) async {
    try {
      // Simulate API request (Replace with actual API call)
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

      // Simulated API success condition (Change this to match your API response)
      bool apiSuccess = true;

      if (!apiSuccess) {
        throw Exception("API connection failed");
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('$namespace:$keyName', 0);

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error: Could not create counter"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
  }

  void _addNewItem() async {
    String namespace = "Standard";
    String keyName = "Counter${counters.length + 1}";

    bool created = await _createNewCounter(namespace, keyName);
    if (created) {
      setState(() {
        counters.add({"namespace": namespace, "key": keyName});
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Counter created successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CounterPage(
                            namespace: counters[index]['namespace']!,
                            keyName: counters[index]['key']!,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          counters[index] = {
                            "namespace": result["namespace"],
                            "key": result["key"],
                          };
                        });
                      }
                    },

                    onLongPress: () async {
                      TextEditingController namespaceController =
                          TextEditingController(
                        text: counters[index]["namespace"],
                      );
                      TextEditingController keyController =
                          TextEditingController(text: counters[index]["key"]);

                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Rename Counter"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: namespaceController,
                                  decoration: const InputDecoration(
                                    labelText: "Namespace",
                                  ),
                                ),
                                TextField(
                                  controller: keyController,
                                  decoration: const InputDecoration(
                                    labelText: "Key Name",
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    counters[index] = {
                                      "namespace": namespaceController.text,
                                      "key": keyController.text,
                                    };
                                  });
                                  Navigator.pop(context);

                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Counter renamed successfully!"),
                                      backgroundColor: Colors.blue,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          );
                        },
                      );
                    },

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          counters.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Counter deleted"),
                            backgroundColor: Colors.orange,
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
                onPressed: _addNewItem,
                child: const Text("Add New Space"),
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
          ],
        ),
      ),
    );
  }
}
