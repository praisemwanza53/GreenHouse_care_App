//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class SensorsScreen extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize Firestore
//
//   final double temperature;
//   final double moisture;
//   final double lightIntensity;
//
//   SensorsScreen({
//     Key? key,
//     required this.temperature,
//     required this.moisture,
//     required this.lightIntensity,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sensors'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             _buildSensorCard('Temperature', temperature, '°C', context),
//             const SizedBox(height: 8),
//             _buildSensorCard('Moisture', moisture, '%', context),
//             const SizedBox(height: 8),
//             _buildSensorCard('Light Intensity', lightIntensity, 'Lux', context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSensorCard(String title, double value, String unit, BuildContext context) {
//     return Card(
//       elevation: 2.0,
//       child: Padding(
//         padding: const EdgeInsets.all(2.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     _setSetPoint(context, title, value); // Pass current value to the set point function
//                   },
//                   child: const Text('Set Point'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8.0),
//             SizedBox(
//               height: 150, // Adjust the height of the chart container
//               child: FutureBuilder(
//                 future: _getSetPoint(title), // Get set point from Firestore
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const LinearProgressIndicator(); // Show loading indicator while waiting for data
//                   } else {
//                     double setPoint = snapshot.data ?? 0; // Get set point value, default to 0
//                     return LineChart(
//                       LineChartData(
//                         gridData: const FlGridData(show: false),
//                         titlesData: const FlTitlesData(show: false),
//                         borderData: FlBorderData(show: false),
//                         lineBarsData: [
//                           LineChartBarData(
//                             spots: [
//                               FlSpot(0, value),
//                               FlSpot(1, setPoint), // Add set point to the chart
//                             ],
//                             isCurved: true,
//                             //color: [Colors.blue], // Adjust colors as needed
//                             belowBarData: BarAreaData(show: false),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 4.0),
//             Text(
//               '$value $unit',
//               style: const TextStyle(
//                 fontSize: 12.0,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _setSetPoint(BuildContext context, String sensorType, double currentValue) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Set $sensorType Set Point'),
//           content: TextFormField(
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(labelText: 'Enter set point'),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter a value';
//               }
//               return null;
//             },
//             onSaved: (value) {
//               double setPoint = double.parse(value!);
//               _updateSetPoint(sensorType, setPoint); // Update set point in Firestore
//             },
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Perform set point update here
//                 Form.of(context)!.save(); // Save form data
//               },
//               child: const Text('Set'),
//             ), // Remove extra comma here
//           ],
//         );
//       },
//     );
//   }
//
//   // Future<double> _getSetPoint(String sensorType) async {
//   //   // Retrieve set point from Firestore
//   //   DocumentSnapshot doc = await _firestore.collection('set_points').doc(sensorType).get();
//   //   return doc.exists ? doc.data()!['value'] : 0; // Return set point value if exists, otherwise return 0
//   // }
//
//   Future<double> _getSetPoint(String sensorType) async {
//     try {
//       // Retrieve set point from Firestore
//       DocumentSnapshot doc = await _firestore.collection('set_points').doc(sensorType).get();
//
//       if (doc.exists) {
//         // If document exists, extract the value and return it
//         Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
//         if (data != null && data.containsKey('value')) {
//           return data['value'] as double;
//         }
//       }
//     } catch (e) {
//       print('Error retrieving set point: $e');
//     }
//
//     // Return 0 if set point does not exist or error occurred
//     return 0;
//   }
//
//   void _updateSetPoint(String sensorType, double setPoint) {
//     // Update set point in Firestore
//     _firestore.collection('set_points').doc(sensorType).set({'value': setPoint});
//   }
// }

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class SensorsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize Firestore

  final double temperature;
  final double moisture;
  final double lightIntensity;

  SensorsScreen({
    Key? key,
    required this.temperature,
    required this.moisture,
    required this.lightIntensity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSensorCard('Temperature', temperature, '°C', context),
            const SizedBox(height: 8),
            _buildSensorCard('Moisture', moisture, '%', context),
            const SizedBox(height: 8),
            _buildSensorCard('Light Intensity', lightIntensity, 'Lux', context),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(String title, double value, String unit, BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
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
                ElevatedButton(
                  onPressed: () {
                    _setSetPoint(context, title, value); // Pass current value to the set point function
                  },
                  child: const Text('Set Point'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 150, // Adjust the height of the chart container
              child: FutureBuilder(
                future: _getSetPoint(title), // Get set point from Firestore
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return DottedBorder(
                      color: Colors.green, // Set color to green
                      strokeWidth: 1,
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: 150,
                      ),
                    ); // Show dotted progress indicator while waiting for data
                  } else {
                    double setPoint = snapshot.data ?? 0; // Get set point value, default to 0
                    return LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, value),
                              FlSpot(1, setPoint), // Add set point to the chart
                            ],
                            isCurved: true,
                            //color: [Colors.blue], // Adjust colors as needed
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              '$value $unit',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
   

  }

  void _setSetPoint(BuildContext context, String sensorType, double currentValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set $sensorType Set Point'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter set point'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              return null;
            },
            onSaved: (value) {
              double setPoint = double.parse(value!);
              _updateSetPoint(sensorType, setPoint); // Update set point in Firestore
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {

                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Perform set point update here

                Form.of(context).save(); // Save form data
              },
              child: const Text('Set'),
            ), // Remove extra comma here
          ],
        );
      },
    );
  }

  Future<double> _getSetPoint(String sensorType) async {
    try {
      // Retrieve set point from Firestore
      DocumentSnapshot doc = await _firestore.collection('set_points').doc(sensorType).get();

      if (doc.exists) {
        // If document exists, extract the value and return it
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('value')) {
          return data['value'] as double;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving set point: $e');
      }
    }

    // Return 0 if set point does not exist or error occurred
    return 0;
  }

  void _updateSetPoint(String sensorType, double setPoint) {
    // Update set point in Firestore
    _firestore.collection('set_points').doc(sensorType).set({'value': setPoint});
  }
}
