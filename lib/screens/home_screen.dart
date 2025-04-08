import 'package:flutter/material.dart';
import 'package:clinic_app/screens/patient_list_screen.dart';
import 'package:clinic_app/screens/add_patient_screen.dart' as add_patient;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 126, 110, 226),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              child: const Text("View Patient List"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addPatient');
              },style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 133, 241, 145),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              child: const Text("Add Patient"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/criticalPatients');
              },style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 133, 241, 145),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              child: const Text("View Critical Patients"),
            ),
          
      
            
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Patient Management',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    initialRoute: '/home',
    routes: {
      '/': (context) => PatientListScreen(),
      '/addPatient': (context) => add_patient.AddPatientScreen(),
      '/home': (context) => HomeScreen(), // Navigate here after login
    },
    onUnknownRoute: (settings) {
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('404: Route not found'),
          ),
        ),
      );
    },
  ));
}
