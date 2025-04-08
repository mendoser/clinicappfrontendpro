import 'package:clinic_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CriticalDataScreen extends StatefulWidget {
  const CriticalDataScreen({Key? key}) : super(key: key);

  @override
  State<CriticalDataScreen> createState() => _CriticalDataScreenState();
}

class _CriticalDataScreenState extends State<CriticalDataScreen> {
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _oxygenLevelController = TextEditingController();
  final AuthService authService = AuthService();

 Map<String, dynamic>? patient;
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          patient = args;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  bool _isLoading = false;
  String _resultMessage = "";



  

  void _submitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('auth_token') ?? '';

    setState(() {

      _isLoading = true;
      _resultMessage = "";
    });

    final result = await authService.addCriticalData(
       patient?['_id'].toString().trim() ?? '',
      _bloodPressureController.text.trim(),
      int.tryParse(_heartRateController.text.trim()) ?? 0,
      int.tryParse(_oxygenLevelController.text.trim()) ?? 0,
      token,
    );

    setState(() {
      _isLoading = false;
      _resultMessage = result['success']
          ? "Data added successfully!"
          : "Failed: ${result['message']}";
    });
  }

  @override

  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Critical Data'),
        backgroundColor: Colors.blue[700],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Patient ID: ${patient?['_id'] ?? ''}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bloodPressureController,
              decoration: const InputDecoration(labelText: "Blood Pressure (e.g. 120/80)"),
            ),
            TextField(
              controller: _heartRateController,
              decoration: const InputDecoration(labelText: "Heart Rate"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _oxygenLevelController,
              decoration: const InputDecoration(labelText: "Oxygen Level (%)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitData,
                    child: const Text("Submit"),
                  ),
            const SizedBox(height: 20),
            Text(
              _resultMessage,
              style: TextStyle(
                color: _resultMessage.contains("successfully")
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
