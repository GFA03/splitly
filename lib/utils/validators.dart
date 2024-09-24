class ValidatorUtils {
  static const String _doublesOnlyError = 'Only numbers';
  static const String _requiredFieldError = 'Required field';

  static String? mandatoryFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return _requiredFieldError;
    }
    return null;
  }

  static String? doubleOnlyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return _requiredFieldError;
    } else if (double.tryParse(value) == null) {
      return _doublesOnlyError;
    }
    return null;
  }

  static String? canBeEmptyValidator(String? value) {
    return null;
  }
}