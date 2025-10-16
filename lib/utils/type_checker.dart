T checkIfValueExistInJson<T>(Map<String, dynamic> jsonData, String key) {
	// print("Type checking called with id: $key");
  if (!jsonData.containsKey(key)) {
    throw FormatException("$key is missing");
  } else if (jsonData[key] is! T) {
    throw FormatException("$key is not of type $T");
  }

  return (jsonData[key] as T);
}
