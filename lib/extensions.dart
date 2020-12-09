extension Extensions on String {
  bool get isBlank => this?.trim()?.isEmpty ?? true;
}
