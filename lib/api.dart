import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://letscountapi.com";

  // Create Counter
  Future<int?> createCounter(
      BuildContext context, String namespace, String key, int initialValue) async {
    try {
      final url = Uri.parse("$baseUrl/$namespace/$key");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"current_value": initialValue}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['current_value'];
      } else {
        _showErrorSnackBar(context, "Failed to create counter: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      _showErrorSnackBar(context, "Network error: ${e.toString()}");
      return null;
    }
  }

  // Get Counter Value
  Future<int?> getCounterValue(BuildContext context, String namespace, String key) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$namespace/$key'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['current_value'];
      } else {
        _showErrorSnackBar(context, "Failed to fetch counter: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      _showErrorSnackBar(context, "Network error: ${e.toString()}");
      return null;
    }
  }

  // Increment Counter
  Future<void> incrementCounter(BuildContext context, String namespace, String key) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$namespace/$key/increment'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar(context, "Counter incremented successfully!");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Network error: ${e.toString()}");
    }
  }

  // Decrement Counter
  Future<void> decrementCounter(BuildContext context, String namespace, String key) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$namespace/$key/decrement'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        _showSuccessSnackBar(context, "Counter decremented successfully!");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Network error: ${e.toString()}");
    }
  }

  // Update Counter
  Future<void> updateCounter(BuildContext context, String namespace, String key, int value) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$namespace/$key/update'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"current_value": value}),
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
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }
}
