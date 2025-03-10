import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://your-api.com"; // Replace with actual API URL

  Future<int?> getCounterValue(BuildContext context, String namespace, String key) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$namespace/$key'));

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        _showErrorSnackBar(context, "Failed to fetch counter: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      _showErrorSnackBar(context, "Network error: ${e.toString()}");
      return null;
    }
  }

  Future<void> incrementCounter(BuildContext context, String namespace, String key) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/$namespace/$key/increment'));

      if (response.statusCode == 200) {
        _showSuccessSnackBar(context, "Counter incremented successfully!");
      } else {
        _showErrorSnackBar(context, "Failed to increment counter");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Network error: ${e.toString()}");
    }
  }

  Future<void> decrementCounter(BuildContext context, String namespace, String key) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/$namespace/$key/decrement'));

      if (response.statusCode == 200) {
        _showSuccessSnackBar(context, "Counter decremented successfully!");
      } else {
        _showErrorSnackBar(context, "Failed to decrement counter");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Network error: ${e.toString()}");
    }
  }

  Future<void> updateCounter(BuildContext context, String namespace, String key, int value) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$namespace/$key/update'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"value": value}),
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar(context, "Counter updated successfully!");
      } else {
        _showErrorSnackBar(context, "Failed to update counter");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Network error: ${e.toString()}");
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
