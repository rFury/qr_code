import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code/Functions/encode_decode.dart';

// Class to represent each input field's data
class InputData {
  String type;
  String value;

  InputData(this.type, this.value);
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<InputData> inputDataList = []; // List to store user input data
  String qrData = "";
  String? selectedField; // Currently selected input type
  final TextEditingController inputController = TextEditingController();

  // List of input types to choose from
  final List<String> inputOptions = ["Name", "Last Name", "Phone"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Dropdown to choose input type
              DropdownButtonFormField<String>(
                value: selectedField,
                hint: const Text('Select an input type'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedField = newValue;
                    inputController.clear(); // Clear the input when the field changes
                  });
                },
                items: inputOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select an input type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Input field for entering the selected type
              if (selectedField != null)
                TextFormField(
                  controller: inputController,
                  decoration: InputDecoration(labelText: 'Enter your $selectedField'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your $selectedField';
                    }
                    if (selectedField == "Phone" && value.length < 8) {
                      return 'Phone number must be at least 8 characters';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 20),

              // Button to add the current input to the list
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      // Add the current input to the list
                      inputDataList.add(InputData(selectedField!, inputController.text));
                      inputController.clear(); // Clear the input after adding
                      selectedField = null; // Reset selected field
                    });
                  }
                },
                child: const Text('Add Input'),
              ),
              const SizedBox(height: 20),

              // Display all added inputs
              const Text(
                'Added Inputs:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),

              // List of added inputs
              ...inputDataList.map((inputData) {
                return Text('${inputData.type}: ${inputData.value}');
              }),

              const SizedBox(height: 20),

              // Button to generate QR Code
              ElevatedButton(
                onPressed: () {
                  if (inputDataList.isNotEmpty) {
                    setState(() {
                      qrData = inputDataList.map((input) {
                        return generateEncodedData(input.type, input.value);
                      }).join(''); // Concatenate all encoded data
                    });
                  }
                },
                child: const Text('Generate QR Code'),
              ),
              const SizedBox(height: 20),

              // QR Code display
              if (qrData.isNotEmpty)
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              const SizedBox(height: 20),

              const Text(
                'Your encoded QR code will appear above.',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateEncodedData(String field, String input) {
    switch (field) {
      case "Name":
        return encode('_a', input);
      case "Last Name":
        return encode('_b', input);
      case "Phone":
        return encode('_e', input);
      default:
        return "";
    }
  }
}
