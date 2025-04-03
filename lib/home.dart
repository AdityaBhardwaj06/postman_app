import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:postman_app/login.dart';
import 'counter_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  Future<void> _addCounter() async {
    String counterName = "";
    int initialValue = 0;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Counter"),
          content: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Counter Name"),
                onChanged: (value) => counterName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Initial value"),
                onChanged: (value) => initialValue = int.parse(value),
                keyboardType: TextInputType.number
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
                if (counterName.isNotEmpty) {
                  await _firestore
                      .collection("users")
                      .doc(user?.uid)
                      .collection("counters")
                      .add({"name": counterName, "value": initialValue});
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCounter(String docId) async {
    await _firestore
        .collection("users")
        .doc(user?.uid)
        .collection("counters")
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 216, 92, 52),
        title: Text("Postman Counter App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: const Color.fromARGB(255, 216, 92, 52),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Text(
                'Counters',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream:
                    _firestore
                        .collection("users")
                        .doc(user?.uid)
                        .collection("counters")
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No counters found."));
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((doc) {
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          return ListTile(
                            leading: const Icon(Icons.contact_page_outlined),
                            title: Text(data["name"] ?? "Unnamed Counter"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CounterPage(
                                        counterId: doc.id,
                                        counterName: data["name"]!,
                                      ),
                                ),
                              );
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCounter(doc.id),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _addCounter,
                child: const Text("Add New Counter"),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, ${user?.displayName ?? 'User'}",
              style: TextStyle(fontSize: 20),
            ),
            Text("${user?.email ?? 'User'}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
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
