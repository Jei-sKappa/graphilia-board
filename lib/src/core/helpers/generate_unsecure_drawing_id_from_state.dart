int generateUnsecureDrawingId() {
  final initial = DateTime.now().microsecondsSinceEpoch;
  while (true) {
    final now = DateTime.now().microsecondsSinceEpoch;
    if (initial != now) return now;
  }
}
