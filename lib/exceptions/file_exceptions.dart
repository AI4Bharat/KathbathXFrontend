class WavFileNotFoundException implements Exception {
  final BigInt assignmentId;
  WavFileNotFoundException(this.assignmentId);

  @override
  String toString() {
    return "File for assignment $assignmentId was missing/corrupt.";
  }
}
