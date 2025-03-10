import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterPage extends StatefulWidget {
  final String namespace;
  final String keyName;

  const CounterPage({super.key, required this.namespace, required this.keyName});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counterValue = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counterValue = prefs.getInt('${widget.namespace}:${widget.keyName}') ?? 0;
    });
  }

  Future<void> _updateCounter(int newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.namespace}:${widget.keyName}', newValue);
    setState(() {
      counterValue = newValue;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Counter updated successfully!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _renameCounter() async {
    TextEditingController namespaceController = TextEditingController(text: widget.namespace);
    TextEditingController keyController = TextEditingController(text: widget.keyName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rename Counter"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namespaceController,
                decoration: InputDecoration(labelText: "Namespace"),
              ),
              TextField(
                controller: keyController,
                decoration: InputDecoration(labelText: "Key Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newNamespace = namespaceController.text.trim();
                String newKey = keyController.text.trim();

                if (newNamespace.isEmpty || newKey.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Namespace and Key cannot be empty!"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                SharedPreferences prefs = await SharedPreferences.getInstance();

                int? value = prefs.getInt('${widget.namespace}:${widget.keyName}');
                if (value != null) {
                  await prefs.setInt('$newNamespace:$newKey', value);
                  await prefs.remove('${widget.namespace}:${widget.keyName}');
                }

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Counter renamed successfully!"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );

                Navigator.pop(context);
                Navigator.pop(context, {
                  "namespace": newNamespace,
                  "key": newKey
                });
              },
              child: Text("Save"),
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
        title: Text("${widget.namespace} / ${widget.keyName}"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Color.fromARGB(255, 216, 92, 52)),
            onPressed: _renameCounter,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Counter Value", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text("$counterValue", style: TextStyle(fontSize: 40)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _updateCounter(counterValue - 1),
                  child: Text("Decrement"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _updateCounter(counterValue + 1),
                  child: Text("Increment"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
