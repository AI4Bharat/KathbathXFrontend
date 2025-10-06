import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kathbath_lite/models/registration_items.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';
import 'package:kathbath_lite/services/worker_api.dart';
import 'package:kathbath_lite/utils/validator.dart';
import 'package:kathbath_lite/widgets/consent_dialog_widget.dart';
import 'package:kathbath_lite/widgets/form_dropdown_widget.dart';
import 'package:kathbath_lite/widgets/textfield_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _states = locations.map(
      (String stateKey, Location location) =>
          MapEntry(stateKey, location.name));

  File? _selectedImage;

  RegistrationItem registrationItem = RegistrationItem();
  late Dio dio;
  late ApiService apiService;
  late WorkerApiService workerApiService;
  Map<String, String> _districts = {};

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio);
    workerApiService = WorkerApiService(apiService);
  }

  Future<void> _submit() async {
    Map<String, dynamic> userJson =
        registrationItem.getUserJson(); // Map<String, dynamic>.from(_formData);
    print("The  final data is $userJson");
    if (_formKey.currentState!.validate() &&
        registrationItem.consentFormAccepted) {
      _formKey.currentState!.save();

      final formData = FormData.fromMap({
        ...userJson,
      });

      Response response;
      try {
        response = await workerApiService.userRegistration(formData);
        log("response: $response");
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User registered successfully.')),
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
              SnackBar(
                  content: Text(
                      'Registration failed. Please check you network and try again.${e.response?.data ?? e.message ?? e.response?.statusCode}')),
            );
            log("error ${e.response?.data ?? e.message ?? e.response?.statusCode} ");
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
    // log("Initial formdata: $_formData");
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
                  spacing: 10.0,
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
                    const SizedBox(height: 10),
                    TextFieldWidget(
                        label: 'Name',
                        icon: Icons.person,
                        onSave: (value) => registrationItem.fullName = value!,
                        validator: (value) =>
                            validateRegistrationItem(value, "name")),
                    TextFieldWidget(
                      label: 'Phone number',
                      icon: Icons.call,
                      onSave: (value) => registrationItem.phoneNumber = value,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        return validateRegistrationItem(value, "phone number");
                      },
                    ),
                    TextFieldWidget(
                      label: 'Age',
                      icon: Icons.calendar_today,
                      onSave: (value) => registrationItem.setAge(value),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return validateRegistrationItem(value, "age");
                      },
                    ),
                    FormDropdown<Gender>(
                      label: 'Gender',
                      icon: Icons.person_outline,
                      value: registrationItem.gender,
                      items: gender,
                      onChanged: (value) => registrationItem.setGender(value),
                      validator: (value) =>
                          value == null ? 'Please select a gender' : null,
                    ),
                    FormDropdown<Language>(
                        label: 'Language',
                        icon: Icons.language,
                        value: registrationItem.language,
                        items: language,
                        onChanged: (value) =>
                            registrationItem.setLanguage(value),
                        validator: (value) =>
                            validateRegistrationItem(value, "language")),
                    FormDropdown<String>(
                        label: 'Native State',
                        icon: Icons.map,
                        value: registrationItem.nativePlaceState,
                        items: _states,
                        onChanged: (value) {
                          setState(() {
                            registrationItem.nativePlaceState = value;
                            registrationItem.nativePlaceDistrict = null;
                            _districts = locations[value]!.district;
                          });
                        },
                        validator: (value) => validateRegistrationItem(
                            value, "native place state")),
                    FormDropdown<String>(
                        label: 'Native District',
                        icon: Icons.location_city,
                        value: registrationItem.nativePlaceDistrict,
                        items: _districts,
                        onChanged: (value) {
                          setState(() {
                            registrationItem.nativePlaceDistrict = value!;
                          });
                        },
                        validator: (value) => validateRegistrationItem(
                            value, "native place district")),
                    FormDropdown<MostTimeSpend>(
                      label: 'Spent most of your life in',
                      icon: Icons.home_work,
                      value: registrationItem.mostTimeSpend,
                      items: mostTimeSpend,
                      onChanged: (value) =>
                          registrationItem.setMostTimeSpend(value),
                      validator: (value) =>
                          validateRegistrationItem(value, "most time spend"),
                    ),
                    FormDropdown<JobType>(
                        label: 'Job Type',
                        icon: Icons.work,
                        value: registrationItem.jobType,
                        items: jobType,
                        onChanged: (value) =>
                            registrationItem.setJobType(value),
                        validator: (value) =>
                            validateRegistrationItem(value, "job type")),
                    FormDropdown<HighestQualification>(
                        label: 'Highest Qualification',
                        icon: Icons.school,
                        value: registrationItem.highestQualification,
                        items: highestQualification,
                        onChanged: (value) =>
                            registrationItem.setHighestQualification(value),
                        validator: (value) => validateRegistrationItem(
                            value, "highest qualification")),
                    TextFieldWidget(
                        label: 'Occupation',
                        icon: Icons.business_center,
                        onSave: (value) => registrationItem.occupation = value!,
                        validator: (value) {
                          return validateRegistrationItem(value, "occupation");
                        }),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: registrationItem.consentFormAccepted,
                          onChanged: (value) {
                            if (value == true) {
                              _showConsentDialog();
                            } else {
                              setState(() {
                                registrationItem.consentFormAccepted = false;
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
            registrationItem.consentFormAccepted = true;
          });
          Navigator.of(ctx).pop();
        },
        onDisagree: () {
          setState(() {
            registrationItem.consentFormAccepted = false;
          });
          Navigator.of(ctx).pop();
        },
      ),
    );
  }
}
