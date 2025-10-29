String convertDurationToString(Duration duration) {
  final hours =
      duration.inHours > 9 ? "${duration.inHours}" : "0${duration.inHours}";
  final minutes = duration.inMinutes > 9
      ? "${duration.inMinutes}"
      : "0${duration.inMinutes}";
  final seconds = duration.inSeconds > 9
      ? "${duration.inSeconds}"
      : "0${duration.inSeconds}";
  return "$hours:$minutes:$seconds";
}
