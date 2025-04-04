import 'package:flutter/material.dart';

class CriticalPatientsScreen extends StatelessWidget {
  final List<Map<String, String>> criticalPatients = [
    {"id": "1", "name": "John Doe", "condition": "High Blood Pressure", "severity": "High"},
    {"id": "2", "name": "Jane Smith", "condition": "Low Oxygen Level", "severity": "Critical"},
    {"id": "3", "name": "Robert Johnson", "condition": "Irregular Heart Rate", "severity": "Medium"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Critical Patients'),
        backgroundColor: Colors.red[700],
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[50]!, Colors.red[100]!],
          ),
        ),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red[700], size: 28),
                  SizedBox(width: 10),
                  Text(
                    "Patients Requiring Immediate Attention",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: criticalPatients.length,
                itemBuilder: (context, index) {
                  final patient = criticalPatients[index];
                  // Determine severity color
                  Color severityColor;
                  if (patient["severity"] == "Critical") {
                    severityColor = Colors.red[800]!;
                  } else if (patient["severity"] == "High") {
                    severityColor = Colors.orange[700]!;
                  } else {
                    severityColor = Colors.yellow[700]!;
                  }
                  
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: severityColor,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: severityColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            "${patient["severity"]} Severity",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(12),
                          title: Text(
                            patient['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                              Text(
                                "Condition: ${patient['condition']}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red[700],
                                ),
                              ),
                              Text("Patient ID: ${patient['id']}"),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/patientDetails',
                                arguments: patient,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('View'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // This could navigate to a screen to update critical patients list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Refreshing critical patients list...'),
              backgroundColor: Colors.red[700],
            ),
          );
        },
        backgroundColor: Colors.red[700],
        icon: Icon(Icons.refresh),
        label: Text('Refresh'),
      ),
    );
  }
}