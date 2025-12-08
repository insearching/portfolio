import 'package:equatable/equatable.dart';

/// Status enumeration for form states
enum ContactFormStatus {
  initial,
  loading,
  success,
  error,
}

/// Extension for convenient status checks
extension ContactFormStatusX on ContactFormStatus {
  bool get isInitial => this == ContactFormStatus.initial;

  bool get isLoading => this == ContactFormStatus.loading;

  bool get isSuccess => this == ContactFormStatus.success;

  bool get isError => this == ContactFormStatus.error;
}

/// Error types for form validation
enum FormValidationError {
  emptyName,
  emptySubject,
  emptyMessage,
  emptyPhone,
  invalidPhone,
  emptyEmail,
  invalidEmail,
  failedToSend,
}

/// Extension to get error messages
extension FormValidationErrorX on FormValidationError {
  String get message {
    switch (this) {
      case FormValidationError.emptyName:
        return "Please input name";
      case FormValidationError.emptySubject:
        return "Please input subject";
      case FormValidationError.emptyMessage:
        return "Please input message";
      case FormValidationError.emptyPhone:
        return "Please input phone";
      case FormValidationError.emptyEmail:
        return "Please input email";
      case FormValidationError.invalidPhone:
        return "Not a valid phone number";
      case FormValidationError.invalidEmail:
        return "Not a valid email";
      case FormValidationError.failedToSend:
        return "Failed to send email, please try again...";
    }
  }
}

/// State for contact form
class ContactFormState extends Equatable {
  const ContactFormState({
    this.status = ContactFormStatus.initial,
    this.errors = const [],
  });

  final ContactFormStatus status;
  final List<FormValidationError> errors;

  @override
  List<Object?> get props => [status, errors];

  ContactFormState copyWith({
    ContactFormStatus? status,
    List<FormValidationError>? errors,
  }) {
    return ContactFormState(
      status: status ?? this.status,
      errors: errors ?? this.errors,
    );
  }

  /// Get error message for a specific error type
  String? getErrorMessage(FormValidationError? error) {
    return error?.message;
  }

  /// Check if a specific error exists
  bool hasError(FormValidationError error) {
    return errors.contains(error);
  }
}
