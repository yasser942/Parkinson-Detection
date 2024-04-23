import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class VoiceInputs extends StatefulWidget {
  const VoiceInputs({super.key});

  @override
  VoiceInputsState createState() => VoiceInputsState();
}

class VoiceInputsState extends State<VoiceInputs> {
  final _formKey = GlobalKey<FormState>();
  static List<String> labels = [
    'MDVP:Fo(Hz)',
    'MDVP:Fhi(Hz)',
    'MDVP:Flo(Hz)',
    'MDVP:Jitter(%)',
    'MDVP:Jitter(Abs)',
    'MDVP:RAP',
    'MDVP:PPQ',
    'Jitter:DDP',
    'MDVP:Shimmer',
    'MDVP:Shimmer(dB)',
    'Shimmer:APQ3',
    'Shimmer:APQ5',
    'MDVP:APQ',
    'Shimmer:DDA',
    'NHR',
    'HNR',
    'RPDE',
    'DFA',
    'spread1',
    'spread2',
    'D2',
    'PPE'
  ];
  // Add a controller for each text field to capture its value
  final List<TextEditingController> _controllers =
  List.generate(labels.length, (index) => TextEditingController());

  Future<void> submitData() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        List<double> data = [];
        for (int i = 0; i < labels.length; i++) {
          data.add(double.parse(_controllers[i].text));
        }

        var body = jsonEncode(data); // Encode as JSON

        var request = http.Request(
          'POST',
          Uri.parse('http://192.168.1.113:5001/predict/voice'),
        );
        request.body = body;
        request.headers.addAll({'Content-Type': 'application/json'});
        print(request.body);

        final response = await request.send();

        if (response.statusCode == 200) {
          // If the server returns an OK response, parse the JSON
          final value = await response.stream.transform(utf8.decoder).join();
          var jsonResponse = jsonDecode(value);
          int prediction = jsonResponse['prediction'];
          Navigator.pop(context); // Hide progress indicator

          AwesomeDialog(
              context: context,
              dialogType: prediction == 0 ? DialogType.success : DialogType.warning,
              animType: AnimType.scale,
              title: prediction == 0 ? 'Healthy' : 'Parkinson\'s Disease',
              desc: 'The model predicts that the voice is ${prediction == 0 ? 'Healthy' : 'Parkinson\'s Disease'} ',
              btnOk: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
              btnCancel: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )


          ).show();

        } else {
          Navigator.pop(context); // Hide progress indicator

          // Handle error as you did previously
          print(response.statusCode);
          // ...
        }
      } catch (error) {
        // Handle other potential errors gracefully
        // ...
        Navigator.pop(context); // Hide progress indicator

        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(

      key: _formKey,
      child: Column(

        children: [
          for (int i = 0; i < labels.length; i += 2)
            Row(

              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controllers[i],
                      decoration: InputDecoration(
                        labelText: labels[i],
                        errorStyle: const TextStyle(
                          fontSize: 10.0,
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ${labels[i]}';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                if (i + 1 < labels.length)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controllers[i + 1],
                        decoration: InputDecoration(
                          labelText: labels[i + 1],
                          errorStyle: const TextStyle(
                            fontSize: 10.0,
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ${labels[i + 1]}';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                 EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: MediaQuery.of(context).size.width / 3.5,
                ),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),

            onPressed: ()async {
              if (_formKey.currentState!.validate()) {

                await submitData();
              }
            },
            child: const Text('Submit'),
          ),
          const SizedBox(height: 20.0)
        ],
      ),
    );
  }
}
