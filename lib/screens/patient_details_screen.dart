import 'package:flutter/material.dart';

class PatientDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, String>? patient =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    return Scaffold(
      appBar: AppBar(
        title: Text(patient?['name'] ?? 'Patient Details'),
        backgroundColor: Colors.blue[700],
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.blue[100]!],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient?['name'] ?? 'N/A',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      Divider(height: 20, thickness: 1),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.person_pin, color: Colors.blue[600]),
                          SizedBox(width: 10),
                          Text(
                            'Patient ID: ${patient?['id'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      if (patient?['condition'] != null)
                        Row(
                          children: [
                            Icon(Icons.local_hospital, color: Colors.red[600]),
                            SizedBox(width: 10),
                            Text(
                              'Condition: ${patient?['condition']}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.add_chart),
                label: Text('Add Clinical Data'),
                onPressed: () {
                  Navigator.pushNamed(context, '/addClinicalData', arguments: patient);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}