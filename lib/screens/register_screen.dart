import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/services/worker_api.dart';
import 'package:karya_flutter/widgets/consent_dialog_widget.dart';
import 'package:karya_flutter/widgets/form_dropdown_widget.dart';
import 'package:karya_flutter/widgets/phone_num_textbox_widget.dart';
import 'package:karya_flutter/widgets/textfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  late Dio dio;
  late ApiService apiService;
  late WorkerApiService workerApiService;

  late Map<String, dynamic> genderData;
  late Map<String, dynamic> languageData;
  late Map<String, dynamic> locationData;
  late Map<String, dynamic> mostTimeSpendData;
  late Map<String, dynamic> jobTypeData;
  late Map<String, dynamic> educationData;
  final Map<String, dynamic> _formData = {
    'full_name': '',
    'phone_number': '',
    'box_id': dotenv.env['BOX_ID'],
    'language': null,
    'age': '',
    'year_of_birth': '',
    'most_time_spent': null,
    'occupation': null,
    'gender': null,
    'native_place_state': null,
    'native_place_district': null,
    'job_type': null,
    'highest_qualification': null,
    'acceptConsent': true,
    'referralCode': '',
  };
  bool _isConsentAccepted = false;

  List<dynamic> _languages = [];
  List<dynamic> _states = [];
  List<dynamic> _genders = [];
  List<dynamic> _districts = [];
  List<dynamic> _mostTimeSpend = [];
  List<dynamic> _jobTypes = [];
  List<dynamic> _educationLevels = [];

  Map<String, List<String>> _stateToDistricts = {};
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio);
    workerApiService = WorkerApiService(apiService);
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/mappings_json/metadata.json');
      var jsonData = jsonDecode(jsonString);
      //To load language data
      genderData = jsonData['gender'];
      languageData = jsonData['languages'];
      locationData = jsonData["location"];
      mostTimeSpendData = jsonData['mostTimeSpend'];
      jobTypeData = jsonData['jobType'];
      educationData = jsonData['highestQualification'];
      setState(() {
        _genders = genderData.values.toList();
        _languages = languageData.keys.toList();
        _states = locationData.entries.map((e) {
          return e.value['name'];
        }).toList();

        _stateToDistricts = locationData.map((key, value) {
          String stateName = value['name'] as String;
          var districts = (value['district'] as Map<String, dynamic>)
              .values
              .map((d) => d['name'] as String)
              .toList();
          return MapEntry(stateName, districts);
        });

        if (_stateToDistricts.isNotEmpty) {
          _selectedState = _stateToDistricts.keys.first;
          _districts = _stateToDistricts[_selectedState!]!;
        }

        _mostTimeSpend = mostTimeSpendData.values.toList();
        _jobTypes = jobTypeData.values.toList();
        _educationLevels = educationData.values.toList();
      });
    } catch (e) {
      log('Error loading or parsing JSON: $e');
    }
  }

  String? getKeyFromValue(Map<String, dynamic> map, dynamic value) {
    for (var entry in map.entries) {
      if (entry.value == value) {
        return entry.key; // Return the key if value matches
      }
    }
    return null; // Return null if value is not found
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        // _formData['photo'] = _selectedImage; // optional if you're sending it
      });
    }
  }

  Future<void> _submit() async {
    _formData['phone_number'] = _phoneNumberController.text;
    print("Form data when submitting:  $_formData");
    Map<String, dynamic> userJson = Map<String, dynamic>.from(_formData);
    if (_formKey.currentState!.validate() && _isConsentAccepted) {
      _formKey.currentState!.save();
      userJson['gender'] = userJson['gender'].toLowerCase();
      userJson['job_type'] = getKeyFromValue(jobTypeData, userJson['job_type']);
      userJson['highest_qualification'] =
          getKeyFromValue(educationData, userJson['highest_qualification']);
      userJson['language'] = languageData[userJson['language']];
      userJson['most_time_spent'] =
          getKeyFromValue(mostTimeSpendData, userJson['most_time_spent']);
      userJson['native_place_state'] =
          userJson['native_place_state'].toLowerCase().replaceAll(' ', '_');
      userJson['native_place_district'] =
          userJson['native_place_district'].toLowerCase().replaceAll(' ', '_');

      MultipartFile? imageFile;
      if (_selectedImage != null) {
        imageFile = await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: _selectedImage!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap({
        ...userJson,
        if (imageFile != null) 'consent': imageFile,
      });
      Response response;
      try {
        response = await workerApiService.userRegistration(formData);
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User registereed successfully.')),
          );
          Navigator.pop(context);
        }
      } on DioException catch (e) {
        if (e.response != null) {
          if (e.response?.statusCode == 409) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User already exist')),
            );
          } else if (e.response?.statusCode == 422) {
            Map<String, dynamic> jsonData = e.response?.data is String
                ? json.decode(e.response?.data)
                : e.response?.data;
            List<String> messages = jsonData['messages']
                .map<String>((item) => item['msg'] as String)
                .toList();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'User registration failed. Please check $messages & try again')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Registration failed. Please check you network and try again.')),
            );
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please complete the form and accept consent.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Initial formdata: $_formData");
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      label: 'Name',
                      icon: Icons.person,
                      onSave: (value) => _formData['full_name'] = value!,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 10),
                    PhoneNumberInput(controller: _phoneNumberController),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      label: 'Age',
                      icon: Icons.calendar_today,
                      onSave: (value) => _formData['age'] = value!,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age!';
                        }

                        final age = int.tryParse(value);
                        if (age == null || age < 10 || age > 130) {
                          return 'Please enter a valid age.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    FormDropdown(
                      label: 'Gender',
                      icon: Icons.person_outline,
                      value: _formData['gender'],
                      items: _genders,
                      onChanged: (value) => setState(() {
                        _formData['gender'] = value!;
                      }),
                      validator: (value) =>
                          value == null ? 'Please select a gender' : null,
                    ),
                    const SizedBox(height: 10),
                    FormDropdown(
                      label: 'Language',
                      icon: Icons.language,
                      value: _formData['language'],
                      items: _languages,
                      onChanged: (value) => setState(() {
                        _formData['language'] = value!;
                      }),
                      validator: (value) =>
                          value == null ? 'Please select a language' : null,
                    ),
                    const SizedBox(height: 10),
                    FormDropdown(
                      label: 'Native State',
                      icon: Icons.map,
                      value: _formData['native_place_state'],
                      items: _states,
                      onChanged: (value) => setState(() {
                        _selectedState = value;
                        _districts = _stateToDistricts[_selectedState!] ?? [];
                        _formData['native_place_state'] = value!;
                        _formData['native_place_district'] = null;
                      }),
                      validator: (value) =>
                          value == null ? 'Please select a native state' : null,
                    ),
                    const SizedBox(height: 10),
                    FormDropdown(
                      label: 'Native District',
                      icon: Icons.location_city,
                      value: _formData['native_place_district'],
                      items: _districts,
                      onChanged: (value) => setState(() {
                        _formData['native_place_district'] = value!;
                      }),
                      validator: (value) => value == null
                          ? 'Please select a native district'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    FormDropdown(
                      label: 'Spent most of your life in',
                      icon: Icons.home_work,
                      value: _formData['most_time_spent'],
                      items: _mostTimeSpend,
                      onChanged: (value) => setState(() {
                        _formData['most_time_spent'] = value!;
                      }),
                      validator: (value) => value == null
                          ? 'Please select where you spent most of your life'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    FormDropdown(
                      label: 'Job Type',
                      icon: Icons.work,
                      value: _formData['job_type'],
                      items: _jobTypes,
                      onChanged: (value) => setState(() {
                        _formData['job_type'] = value!;
                      }),
                      validator: (value) =>
                          value == null ? 'Please select a job type' : null,
                    ),
                    const SizedBox(height: 10),
                    FormDropdown(
                      label: 'Highest Qualification',
                      icon: Icons.school,
                      value: _formData['highest_qualification'],
                      items: _educationLevels,
                      onChanged: (value) => setState(() {
                        _formData['highest_qualification'] = value!;
                      }),
                      validator: (value) => value == null
                          ? 'Please select education level'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                        label: 'Occupation',
                        icon: Icons.business_center,
                        onSave: (value) => _formData['occupation'] = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your occupation';
                          }
                          // Check if the value contains only letters
                          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return 'Please enter letters only';
                          }
                          return null;
                        }),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _isConsentAccepted,
                          onChanged: (value) {
                            if (value == true) {
                              _showConsentDialog();
                            } else {
                              setState(() {
                                _isConsentAccepted = false;
                              });
                            }
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'Please click, read and accept the consent form.',
                          ),
                        ),
                      ],
                    ),
                    if (_selectedImage != null)
                      Column(
                        children: [
                          Image.file(_selectedImage!, height: 150),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload),
                      label: const Text('Upload Photo'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showConsentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ConsentDialog(
        onAgree: () {
          setState(() {
            _isConsentAccepted = true;
          });
          Navigator.of(ctx).pop();
        },
        onDisagree: () {
          setState(() {
            _isConsentAccepted = false;
          });
          Navigator.of(ctx).pop();
        },
      ),
    );
  }
}
