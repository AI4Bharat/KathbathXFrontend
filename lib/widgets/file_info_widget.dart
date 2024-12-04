import 'package:flutter/material.dart';

class FileInfoWidget extends StatelessWidget {
  final String fValue;
  final String gValue;
  final String agValue;
  final String pValue;
  final String pSubValue;

  const FileInfoWidget({
    super.key,
    required this.fValue,
    required this.gValue,
    required this.agValue,
    required this.pValue,
    required this.pSubValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // First TextView
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.redAccent,
            child: Text(
              'F: $fValue',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        // Second TextView
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.redAccent,
            child: Text(
              'G: $gValue',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        // Third TextView
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.redAccent,
            child: Text(
              'AG: $agValue',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.redAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'P: $pValue',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  pSubValue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
