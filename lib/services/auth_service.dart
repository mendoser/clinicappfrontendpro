import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://localhost:6000/api"; // Your backend API URL

  // Function to register a provider
  Future<Map<String, dynamic>> registerProvider(String name, String email, String password) async {
    final String apiUrl = "$baseUrl/providers/register";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': "Registration successful"};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? "Registration failed"};
      }
    } catch (e) {
      return {'success': false, 'message': "Error: $e"};
    }
  }

  // Function to log in a user
  Future<String?> login(String email, String password) async {
    final String apiUrl = "$baseUrl/auth/login";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']; // Assuming backend returns a token
      } else {
        jsonDecode(response.body);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Function to get all patients
  Future<List<dynamic>> getAllPatients(String token) async {
    final url = Uri.parse("$baseUrl/patients");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Returns a list of patients
      } else {
        throw Exception("Failed to fetch patients");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }





  // Function to get critical patients
  Future<List<dynamic>> getCriticalPatients(String token) async {
    final url = Uri.parse("$baseUrl/patients?hasCriticalData=true");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception("Failed to fetch critical patients");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Function to get a specific patient's details
  Future<Map<String, dynamic>> getPatientInfo(String id, String token) async {
    final url = Uri.parse("$baseUrl/patients/$id");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception("Failed to fetch patient info");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Function to create a new patient
  Future<Map<String, dynamic>> createPatient(
      String name, int age, String gender, String condition, String phone, String token) async {
    final url = Uri.parse("$baseUrl/patients");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "name": name,
          "age": age,
          "gender": gender,
          "condition": condition,
          "phone": phone,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': "Error: $e"};
    }
  }

  // Function to create critical data for a patient
  Future<Map<String, dynamic>> addCriticalData(
      String patientId, String bloodPressure, int heartRate, int oxygenLevel, String token) async {
    final url = Uri.parse("$baseUrl/patients/$patientId/critical-data");
print("CriticalData: $bloodPressure , $heartRate , $oxygenLevel");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "bloodPressure": bloodPressure,
          "heartRate": heartRate,
          "oxygenLevel": oxygenLevel,
        }),
      );
print("CriticalData: $response");

      if (response.statusCode == 201) {
        
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': "Error: $e"};
    }
  }
//addcritical data2
  Future<Map<String, dynamic>> addCriticalData2(
      String patientId, String bloodPressure, int heartRate, int oxygenLevel, String token) async {
    final url = Uri.parse("$baseUrl/patients/$patientId/critical-data");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "bloodPressure": bloodPressure,
          "heartRate": heartRate,
          "oxygenLevel": oxygenLevel,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data']};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': "Error: $e"};
    }
  }
}
