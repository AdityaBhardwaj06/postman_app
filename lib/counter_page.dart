import 'package:flutter/material.dart';
import 'api.dart';

class CounterPage extends StatefulWidget {
  final String namespace;
  final String keyName;

  const CounterPage({super.key, required this.namespace, required this.keyName});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counterValue = 0;
  final ApiService _apiService = ApiService();
  final TextEditingController _updateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    int? value = await _apiService.getCounterValue(context, widget.namespace, widget.keyName);
    if (value != null) {
      setState(() {
        counterValue = value;
      });
    }
  }

  Future<void> _incrementCounter() async {
    await _apiService.incrementCounter(context, widget.namespace, widget.keyName);
    _loadCounter();
  }

  Future<void> _decrementCounter() async {
    await _apiService.decrementCounter(context, widget.namespace, widget.keyName);
    _loadCounter();
  }

  Future<void> _updateCounter() async {
    int? newValue = int.tryParse(_updateController.text);
    if (newValue != null) {
      await _apiService.updateCounter(context, widget.namespace, widget.keyName, newValue);
      _loadCounter();
      _updateController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.namespace} / ${widget.keyName}"),
        backgroundColor: const Color.fromARGB(255, 216, 92, 52)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Counter Value", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text("$counterValue", style: TextStyle(fontSize: 40)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _decrementCounter,
              child: Text("Decrement"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text("Increment"),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _updateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "New Counter Value"),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateCounter,
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
