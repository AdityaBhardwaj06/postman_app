import 'package:flutter/material.dart';
import 'package:postman_app/firestore_counter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounterPage extends StatefulWidget {
  final String counterId;
  final String counterName;

  const CounterPage({
    super.key,
    required this.counterId,
    required this.counterName,
  });

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counterValue = 0;
  bool isLoading = false; 
  final FirestoreCounterService _firebaseService = FirestoreCounterService();
  final TextEditingController _updateController = TextEditingController();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    if (userId != null) {
      setState(() => isLoading = true);
      int? value = await _firebaseService.getCounterValue(
        userId!,
        widget.counterId,
      );
      if (value != null) {
        setState(() {
          counterValue = value;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _incrementCounter() async {
    if (userId != null) {
      setState(() => isLoading = true);
      await _firebaseService.incrementCounter(context, userId!, widget.counterId);
      await _loadCounter();
    }
  }

  Future<void> _decrementCounter() async {
    if (userId != null) {
      setState(() => isLoading = true);
      await _firebaseService.decrementCounter(context, userId!, widget.counterId);
      await _loadCounter();
    }
  }

  Future<void> _updateCounter() async {
    int? newValue = int.tryParse(_updateController.text);
    if (newValue != null && userId != null) {
      setState(() => isLoading = true);
      await _firebaseService.updateCounter(context, userId!, widget.counterId, newValue);
      await _loadCounter();
      _updateController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.counterName),
        backgroundColor: const Color.fromARGB(255, 216, 92, 52),
      ),
      body: Center(
        child:
            isLoading
                ? const CircularProgressIndicator() // Show loading spinner
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Counter Value", style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 20),
                    Text("$counterValue", style: const TextStyle(fontSize: 40)),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: _decrementCounter,
                          child: const Text("Decrement"),
                        ),
                        ElevatedButton(
                      onPressed: _incrementCounter,
                      child: const Text("Increment"),
                    ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _updateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "New Counter Value",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _updateCounter,
                      child: const Text("Update"),
                    ),
                  ],
                ),
      ),
    );
  }
}
