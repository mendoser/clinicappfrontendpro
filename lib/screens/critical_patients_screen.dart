import 'package:clinic_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CriticalPatientsScreen extends StatefulWidget {
  const CriticalPatientsScreen({super.key});

  @override
  State<CriticalPatientsScreen> createState() => _CriticalPatientsScreenState();
}

class _CriticalPatientsScreenState extends State<CriticalPatientsScreen> {
  
  
final AuthService authService = AuthService();
List<Map<String, dynamic>> patients = [];
String determineSeverity(int systolic, int diastolic, int heartRate, int oxygen) {
  if (systolic > 140 || diastolic > 90 || heartRate < 50 || heartRate > 120 || oxygen < 90) {
    return "High";
  } else if ((systolic >= 130 && systolic <= 140) || (diastolic >= 80 && diastolic <= 90) ||
             (heartRate >= 50 && heartRate <= 60) || (heartRate >= 100 && heartRate <= 120) ||
             (oxygen >= 90 && oxygen < 95)) {
    return "Medium";
  } else {
    return "Low";
  }
}

List<Map<String, String>> formatCriticalPatients(List<Map<String, dynamic>> rawPatients) {
  List<Map<String, String>> formatted = [];

  for (var patient in rawPatients) {
    final critical = patient['criticalData'].last;
    int systolic = 0, diastolic = 0;

    if (critical.containsKey('bloodPressure')) {
      final parts = critical['bloodPressure'].split('/');
      systolic = int.tryParse(parts[0]) ?? 0;
      diastolic = int.tryParse(parts[1]) ?? 0;
    }

    final heartRate = critical['heartRate'] ?? 0;
    final oxygen = critical['oxygenLevel'] ?? 0;

    formatted.add({
      "id": patient['_id'],
      "name": patient['name'],
      "condition":
          "Blood Pressure: ${systolic}/${diastolic}, Heart Rate: $heartRate, Oxygen: $oxygen",
      "severity": determineSeverity(systolic, diastolic, heartRate, oxygen),
    });
  }

  return formatted;
}

@override
void initState() {
  super.initState();
  _loadCriticalPatients();
}

void _loadCriticalPatients() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    // Handle the case where the token is not available
    return;
  }

  final data = await authService.getCriticalPatients(token);
  setState(() {
    patients = List<Map<String, dynamic>>.from(data);
  });
}



  @override
  Widget build(BuildContext context) {
List<Map<String, String>> criticalPatients = formatCriticalPatients(patients);
    if (criticalPatients.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Critical Patients'),
          backgroundColor: Colors.red[700],
          elevation: 4,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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