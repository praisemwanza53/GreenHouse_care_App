import 'package:flutter/material.dart';

class ActuatorScreen extends StatefulWidget {
  const ActuatorScreen({Key? key}) : super(key: key);

  @override
  _ActuatorScreenState createState() => _ActuatorScreenState();
}

class _ActuatorScreenState extends State<ActuatorScreen> {
  double fanValue = 25.0;
  double pumpValue = 60.0;
  double ledValue = 800.0;

  bool fanAutoMode = false;
  bool pumpAutoMode = false;
  bool ledAutoMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actuators'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSlider('Fan', fanValue, fanAutoMode, (value) {
              setState(() {
                fanValue = value;
              });
            }, (value) {
              setState(() {
                fanAutoMode = value;
              });
            }),
            const SizedBox(height: 8),
            _buildSlider('Pump', pumpValue, pumpAutoMode, (value) {
              setState(() {
                pumpValue = value;
              });
            }, (value) {
              setState(() {
                pumpAutoMode = value;
              });
            }),
            const SizedBox(height: 8),
            _buildSlider('LED', ledValue, ledAutoMode, (value) {
              setState(() {
                ledValue = value;
              });
            }, (value) {
              setState(() {
                ledAutoMode = value;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String title, double value, bool autoMode, ValueChanged<double> onValueChanged, ValueChanged<bool> onAutoModeChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Text('Auto'),
                Switch(
                  value: autoMode,
                  onChanged: onAutoModeChanged,
                  activeColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Slider(
          value: value,
          min: 0.0,
          max: 1000.0,
          divisions: 20,
          onChanged: onValueChanged,
          label: '$value',
          activeColor: Colors.green, // Change color to green
        ),
      ],
    );
  }
}
