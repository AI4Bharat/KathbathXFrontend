import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kathbath_lite/models/registration_items.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';
import 'package:kathbath_lite/services/worker_api.dart';
import 'package:kathbath_lite/utils/validator.dart';
import 'package:kathbath_lite/widgets/buttons/action_button.dart';
import 'package:kathbath_lite/widgets/dialogs/consent_dialog.dart';
import 'package:kathbath_lite/widgets/form_dropdown_widget.dart';
import 'package:kathbath_lite/widgets/dialogs/loading_dialog.dart';
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

  // Used to store the selections and inputs of the registration screen
  RegistrationItem registrationItem = RegistrationItem();
  // Used to store the corresponding error message for each input in the registration screen
  RegistrationErrorItem registrationErrorItem = RegistrationErrorItem();
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

  void _updateErrorMessageFromServer(Map<String, dynamic> errorMap) {
    RegistrationErrorItem tmpRegistrationErrorItem = RegistrationErrorItem();
    if (errorMap.containsKey("full_name")) {
      tmpRegistrationErrorItem.fullName = errorMap["full_name"];
    }
    if (errorMap.containsKey("phone_number")) {
      tmpRegistrationErrorItem.phoneNumber = errorMap["phone_number"];
    }
    if (errorMap.containsKey("age")) {
      tmpRegistrationErrorItem.age = errorMap["age"];
    }
    if (errorMap.containsKey("gender")) {
      tmpRegistrationErrorItem.gender = errorMap["gender"];
    }
    if (errorMap.containsKey("language")) {
      tmpRegistrationErrorItem.language = errorMap["language"];
    }
    if (errorMap.containsKey("native_place_state")) {
      tmpRegistrationErrorItem.nativePlaceState =
          errorMap["native_place_state"];
    }
    if (errorMap.containsKey("native_place_district")) {
      tmpRegistrationErrorItem.nativePlaceDistrict =
          errorMap["native_place_district"];
    }
    if (errorMap.containsKey("most_time_spend")) {
      tmpRegistrationErrorItem.mostTimeSpend = errorMap["most_time_spend"];
    }
    if (errorMap.containsKey("highest_qualification")) {
      tmpRegistrationErrorItem.highestQualification =
          errorMap["highest_qualification"];
    }
    if (errorMap.containsKey("job_type")) {
      tmpRegistrationErrorItem.jobType = errorMap["job_type"];
    }
    if (errorMap.containsKey("occupation")) {
      tmpRegistrationErrorItem.occupation = errorMap["occupation"];
    }

    setState(() {
      registrationErrorItem = tmpRegistrationErrorItem;
    });
  }

  Future<void> _submit() async {
    Map<String, dynamic> userMap = registrationItem.getUserMap();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!registrationItem.consentFormAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please accept the consent form"),
          duration: Duration(seconds: 1)));
      return;
    }

    final registrationFormData = FormData.fromMap(userMap);

    showLoadingDialog(
        "We’re preparing your account. Please don’t close the app.", context);
    RegistrationResponse response =
        await workerApiService.userRegistration(registrationFormData);

    if (context.mounted) {
      // Closing the loading dialog
      Navigator.of(context).pop();

      if (response.responseCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Success")));
        Navigator.of(context).pop();
        return;
      } else if (response.responseCode == 422) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));
        _updateErrorMessageFromServer(response.details);
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                        label: 'Name',
                        icon: Icons.person,
                        errorText: registrationErrorItem.fullName,
                        onSave: (value) => registrationItem.fullName = value!,
                        validator: (value) =>
                            validateRegistrationItem(value, "name")),
                    TextFieldWidget(
                      label: 'Phone number',
                      icon: Icons.call,
                      errorText: registrationErrorItem.phoneNumber,
                      onSave: (value) => registrationItem.phoneNumber = value,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        return validateRegistrationItem(value, "phone number");
                      },
                    ),
                    TextFieldWidget(
                      label: 'Age',
                      errorText: registrationErrorItem.age,
                      icon: Icons.calendar_today,
                      onSave: (value) => registrationItem.setAge(value),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return validateRegistrationItem(value, "age");
                      },
                    ),
                    FormDropdown<Gender>(
                      label: 'Gender',
                      errorText: registrationErrorItem.gender,
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
                        errorText: registrationErrorItem.language,
                        value: registrationItem.language,
                        items: language,
                        onChanged: (value) =>
                            registrationItem.setLanguage(value),
                        validator: (value) =>
                            validateRegistrationItem(value, "language")),
                    FormDropdown<String>(
                        label: 'Native State',
                        icon: Icons.map,
                        errorText: registrationErrorItem.nativePlaceState,
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
                        errorText: registrationErrorItem.nativePlaceDistrict,
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
                      errorText: registrationErrorItem.mostTimeSpend,
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
                        errorText: registrationErrorItem.jobType,
                        value: registrationItem.jobType,
                        items: jobType,
                        onChanged: (value) =>
                            registrationItem.setJobType(value),
                        validator: (value) =>
                            validateRegistrationItem(value, "job type")),
                    FormDropdown<HighestQualification>(
                        label: 'Highest Qualification',
                        icon: Icons.school,
                        errorText: registrationErrorItem.highestQualification,
                        value: registrationItem.highestQualification,
                        items: highestQualification,
                        onChanged: (value) =>
                            registrationItem.setHighestQualification(value),
                        validator: (value) => validateRegistrationItem(
                            value, "highest qualification")),
                    TextFieldWidget(
                        label: 'Occupation',
                        errorText: registrationErrorItem.occupation,
                        icon: Icons.business_center,
                        onSave: (value) => registrationItem.occupation = value!,
                        validator: (value) {
                          return validateRegistrationItem(value, "occupation");
                        }),
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
                    ActionButton(onPressed: () => _submit(), text: "Submit")
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
