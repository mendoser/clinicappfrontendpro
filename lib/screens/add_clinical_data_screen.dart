import 'package:flutter/material.dart';

class AddClinicalDataScreen extends StatefulWidget {
  @override
  _AddClinicalDataScreenState createState() => _AddClinicalDataScreenState();
}

class _AddClinicalDataScreenState extends State<AddClinicalDataScreen> {
  final TextEditingController valueController = TextEditingController();
  String selectedVital = "Blood Pressure";
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Save data to storage or backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Clinical data saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String>? patient = 
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Clinical Data"),
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
          child: Form(
            key: _formKey,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (patient != null) 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          "Patient: ${patient['name']}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    Text(
                      "Vital Sign",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8, bottom: 16),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedVital,
                          items: [
                            "Blood Pressure",
                            "Oxygen Level",
                            "Heart Rate",
                            "Respiratory Rate",
                            "Temperature",
                            "Blood Glucose"
                          ]
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) => setState(() => selectedVital = value!),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: valueController,
                      decoration: InputDecoration(
                        labelText: 'Measurement Value',
                        hintText: selectedVital == "Blood Pressure" ? "e.g. 120/80" : "Enter value",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the measurement value';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue[600]),
                        SizedBox(width: 8),
                        Text(
                          "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Change Date'),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.save),
                        label: Text('Save Data'),
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}