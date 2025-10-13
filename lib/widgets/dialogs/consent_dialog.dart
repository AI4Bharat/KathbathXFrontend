import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class ConsentDialog extends StatefulWidget {
  final VoidCallback onAgree;
  final VoidCallback onDisagree;

  ConsentDialog({required this.onAgree, required this.onDisagree});

  @override
  _ConsentDialogState createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  String _selectedLanguage = 'english'; // Default language
  List<String> _languageList = [];
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
    _languageList = jsonResult.keys.toList();
    _languageList.sort();
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

  String capitalizeString(String text) {
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<void> _launchPrivacyPolicy() async {
    final Uri url =
        Uri.parse("https://ai4bharat.iitm.ac.in/tools/Kathbath-Lite/policy");
    if (!await launchUrl(url)) {
      throw Exception("Could not launch the url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _heading.isNotEmpty ? _heading : 'Loading...',
        textAlign: TextAlign.start,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _paragraph.isNotEmpty
                  ? _paragraph
                  : 'Please wait while the content is loading...',
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: _languageList.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(capitalizeString(key)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                  _updateConsentText(_selectedLanguage);
                });
              },
            ),
            Row(
              children: [
                // Text("Please read our privacy policy at"),
                TextButton(
                    onPressed: _launchPrivacyPolicy,
                    child: const Text("Read privacy policy"))
              ],
            )
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
