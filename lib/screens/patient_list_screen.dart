import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(PatientManagementApp());
}

class PatientManagementApp extends StatelessWidget {
  const PatientManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => PatientListScreen(),
        '/addPatient': (context) => AddPatientScreen(),
        '/patientDetails': (context) => PatientDetailsScreen(),
      },
    );
  }
}

// Patient List Screen
class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<Map<String, dynamic>> patients = [];
  List<Map<String, dynamic>> filteredPatients = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:6000/api/patients'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            patients = data.cast<Map<String, dynamic>>();
            filteredPatients = List.from(patients);
            isLoading = false;
          });
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (error) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print("Error fetching patients: $error");
    }
  }

  void _search(String query) {
    setState(() {
      filteredPatients = patients
          .where((p) => p["name"]?.toLowerCase()?.contains(query.toLowerCase()) ?? false)
          .toList();
    });
  }

  Future<void> _refresh() async {
    await _fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient List"),
        backgroundColor: Colors.blue[700],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Failed to load patients. Please try again.",
                          style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _fetchPatients,
                        child: Text("Retry"),
                      ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade50, Colors.blue.shade100],
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          onChanged: _search,
                          decoration: InputDecoration(
                            labelText: "Search Patients",
                            hintText: "Enter patient name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refresh,
                          child: filteredPatients.isEmpty
                              ? Center(child: Text("No patients found"))
                              : ListView.builder(
                                  itemCount: filteredPatients.length,
                                  itemBuilder: (context, index) {
                                    final patient = filteredPatients[index];
                                    return Card(
                                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                          child: Text(
                                            patient["name"].isNotEmpty ? patient["name"][0] : '?',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        title: Text(patient["name"] ?? "Unknown"),
                                        subtitle: Text("ID: ${patient["id"] ?? '-'}"),
                                        trailing: Icon(Icons.chevron_right),
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/patientDetails',
                                            arguments: patient,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addPatient');
        },
        child: Icon(Icons.person_add),
        backgroundColor: Colors.blue[700],
        tooltip: 'Add New Patient',
      ),
    );
  }
}

// Add Patient Screen
class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  String selectedGender = "Male";
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  Future<void> _savePatient() async {
    if (_isSubmitting) return;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:6000/api/patients'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': nameController.text,
            'age': int.parse(ageController.text),
            'gender': selectedGender,
            'address': addressController.text,
            'phone': phoneController.text,
            'condition': conditionController.text.isEmpty ? "N/A" : conditionController.text,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Patient added successfully!"),
            backgroundColor: Colors.green,
          ));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to add patient."),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Patient"),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Patient Name', border: OutlineInputBorder()),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter patient name' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter age';
                  final num = int.tryParse(value);
                  if (num == null || num <= 0) return 'Enter valid age';
                  return null;
                },
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: InputDecoration(labelText: 'Gender', border: OutlineInputBorder()),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                    .toList(),
                onChanged: (value) => setState(() => selectedGender = value!),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter phone number' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                maxLines: 2,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: conditionController,
                decoration: InputDecoration(
                    labelText: 'Medical Condition (optional)', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _savePatient,
                child: Text(_isSubmitting ? 'Saving...' : 'Save Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Patient Details Screen
class PatientDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> patient =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Details"),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            ListTile(
              title: Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(patient["name"] ?? "N/A"),
            ),
            ListTile(
              title: Text("ID", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(patient["id"].toString()),
            ),
            ListTile(
              title: Text("Age", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(patient["age"].toString()),
            ),
            ListTile(
              title: Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(patient["gender"] ?? "N/A"),
            ),
            ListTile(
              title: Text("Phone", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(patient["phone"] ?? "N/A"),
            ),
            ListTile(
              title: Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(patient["address"] ?? "N/A"),
            ),
            ListTile(
              title: Text("Condition", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(patient["condition"] ?? "N/A"),
            ),
          ],
        ),
      ),
    );
  }
}
