class WavFileNotFoundException implements Exception {
  final String assignmentId;
  WavFileNotFoundException(this.assignmentId);

  @override
  String toString() {
    return "File for assignment $assignmentId was missing/corrupt.";
  }
}
