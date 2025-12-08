import 'package:equatable/equatable.dart';

/// Base class for contact form events
/// Using sealed class pattern for exhaustive event handling
sealed class ContactFormEvent extends Equatable {
  const ContactFormEvent();

  @override
  List<Object?> get props => [];
}

/// Event to submit the contact form
class SubmitContactForm extends ContactFormEvent {
  const SubmitContactForm({
    required this.name,
    required this.phone,
    required this.email,
    required this.subject,
    required this.message,
  });

  final String name;
  final String phone;
  final String email;
  final String subject;
  final String message;

  @override
  List<Object?> get props => [name, phone, email, subject, message];
}

/// Event to reset the form
class ResetContactForm extends ContactFormEvent {
  const ResetContactForm();
}
