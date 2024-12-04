import 'dart:convert';
// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ConsentDialog extends StatefulWidget {
  final VoidCallback onAgree;
  final VoidCallback onDisagree;

  ConsentDialog({required this.onAgree, required this.onDisagree});

  @override
  _ConsentDialogState createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  String _selectedLanguage = 'english'; // Default language
  Map<String, dynamic> _consentTexts = {};
  String _heading = '';
  String _paragraph = '';

  @override
  void initState() {
    super.initState();
    _loadConsentTexts();
  }

  Future<void> _loadConsentTexts() async {
    String data =
        await rootBundle.loadString('assets/mappings_json/consent_lang.json');
    final jsonResult = json.decode(data);
    //log("Json data: $jsonResult");
    setState(() {
      _consentTexts = jsonResult;
      _updateConsentText(_selectedLanguage);
    });
  }

  void _updateConsentText(String languageCode) {
    setState(() {
      _heading = _consentTexts[languageCode]["heading"] ?? '';
      _paragraph = _consentTexts[languageCode]["paragraph"] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _heading.isNotEmpty ? _heading : 'Loading...',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _paragraph.isNotEmpty
                  ? _paragraph
                  : 'Please wait while the content is loading...',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: _consentTexts.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key.toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                  _updateConsentText(_selectedLanguage);
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onDisagree,
          child: const Text('Disagree'),
        ),
        ElevatedButton(
          onPressed: widget.onAgree,
          child: const Text('Agree'),
        ),
      ],
    );
  }
}
