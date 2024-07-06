// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedOption = 'Bad';
  double _rating = 1.0;

  void _submitFeedback() {
    if (_formKey.currentState?.validate() ?? false) {
      // Submit feedback to the backend or local storage
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Feedback',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 107, 100, 237),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Select an option:',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cursive',
                                color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            title: const Text(
                              'Bad',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            leading: Radio<String>(
                              value: 'Bad',
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value!;
                                  _rating =
                                      1.0; // Set rating to 1.0 when 'Bad' is selected
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Average',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            leading: Radio<String>(
                              value: 'Average',
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value!;
                                  _rating =
                                      3.0; // Set rating to 3.0 when 'Average' is selected
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'Good',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            leading: Radio<String>(
                              value: 'Good',
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value!;
                                  _rating =
                                      5.0; // Set rating to 5.0 when 'Good' is selected
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Rate the app:',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Slider(
                            value: _rating,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: _rating.toString(),
                            onChanged: (value) {
                              setState(() {
                                _rating = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitFeedback,
                            child: const Text('Submit Feedback'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
