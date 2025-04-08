import 'package:clinic_app/screens/add_critical_patient.dart';
import 'package:clinic_app/screens/critical_patients_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/add_clinical_data_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/patient_list_screen.dart' hide AddPatientScreen, PatientDetailsScreen;
import 'screens/add_patient_screen.dart';
import 'screens/patient_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLoggedIn = await checkLoginStatus();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');
  return token != null; // User is logged in if token exists
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // Set the initial route
      routes: {
        '/': (context) => PatientListScreen(),
        '/addPatient': (context) => AddPatientScreen(),
        '/patientDetails': (context) => PatientDetailsScreen(),
        '/login': (context) => LoginScreen(), // Ensure LoginScreen is defined
        '/home': (context) => HomeScreen(),  // Ensure HomeScreen is defined
             '/addClinicalData': (context) => AddClinicalDataScreen(),
             '/criticalPatients': (context) => CriticalPatientsScreen(),
             '/addCriticalPatient': (context) => CriticalDataScreen(),

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
    );
  }
}