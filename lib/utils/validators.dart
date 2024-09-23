class ValidatorUtils {
  static const String _doublesOnlyError = 'Only numbers';
  static const String _requiredFieldError = 'Required field';
  static final RegExp _doubleOnlyRegExp = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');

  static String? mandatoryFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return _requiredFieldError;
    }
    return null;
  }

  static String? doubleOnlyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return _requiredFieldError;
    } else if (!_doubleOnlyRegExp.hasMatch(value)) {
      return _doublesOnlyError;
    }
    return null;
  }

  static String? canBeEmptyValidator(String? value) {
    return null;
  }
}