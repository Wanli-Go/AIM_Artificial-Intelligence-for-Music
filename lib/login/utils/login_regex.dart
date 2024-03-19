class AppRegex {
  const AppRegex._();

  static final RegExp phoneRegex = RegExp(
      r"^1\d{10}$");
  static final RegExp passwordRegex = RegExp(
      r'^(?=.*[A-Z]).{8,}$');
}
