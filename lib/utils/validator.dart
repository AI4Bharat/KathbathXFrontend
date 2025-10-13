String? validateRegistrationItem(dynamic value, String itemName) {
  if (value == null || value!.isEmpty || value!.toString().trim() == "") {
    return "Please select a $itemName";
  }

  switch (itemName) {
    case "name":
      return _validateStringInputs(value, "Name");
    case "occupation":
      return _validateStringInputs(value, "Occupation");
    case "phone number":
      return _validatePhonenumber(value, itemName);
    case "age":
      return _validateAge(value, itemName);
    default:
      return null;
  }
}

String? _validateAge(String value, String itemName) {
  value = value.trim();
  int age = -1;
  try {
    age = int.parse(value);
  } catch (e) {
    return "Age can only contain digits";
  }

  if (age >= 120) {
    return "Age value is invalid";
  } else if (age < 18) {
    return "Only adults(18+) can participate create account";
  }

  return null;
}

String? _validatePhonenumber(String value, String itemName) {
  RegExp regExp = RegExp(r'^[0-9]{10}$');
  value = value.trim();

  var match = regExp.hasMatch(value);
  if (value.length != 10) {
    return "Phone number should be 10 digit";
  } else if (!match) {
    return "Phone number can only contain numbers";
  }

  return null;
}

String? _validateStringInputs(String value, String itemName) {
  RegExp regExp = RegExp(r'^[A-Za-z ]+$');
  value = value.trim();

  var match = regExp.hasMatch(value);
  if (!match) {
    return "$itemName can only contain alphabets";
  }

  return null;
}

String? validateOTP(String otp) {
  RegExp regExp = RegExp(r'^[0-9]{6}$');
  otp = otp.trim();

  var match = regExp.hasMatch(otp);
  if (otp.length != 6) {
    return "OTP/Passcode should be 6 digits";
  } else if (!match) {
    return "Only digits can be used";
  }
	return null;
}
