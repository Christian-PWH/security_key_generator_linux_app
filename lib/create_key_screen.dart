import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class CreateKeyScreen extends StatefulWidget {
  const CreateKeyScreen({super.key, required this.selectedDrive});

  final String selectedDrive;

  @override
  State<CreateKeyScreen> createState() => _CreateKeyScreenState();
}

class _CreateKeyScreenState extends State<CreateKeyScreen> {
  String? selectedDrive;

  void _createJsonFile() async {
    selectedDrive = widget.selectedDrive;
    if (selectedDrive == null) return;

    String filePath = '$selectedDrive/data.json';
    File file = File(filePath);

    Map<String, dynamic> data = {
      'message': 'Hello from Flutter!',
      'timestamp': DateTime.now().toIso8601String(),
    };

    String jsonString = jsonEncode(data);

    try {
      await file.writeAsString(jsonString);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('JSON file created at $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
