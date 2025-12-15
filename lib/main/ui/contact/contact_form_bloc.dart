import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/data/repository/portfolio_repository.dart';
import 'package:portfolio/main/ui/contact/contact_form_event.dart';
import 'package:portfolio/main/ui/contact/contact_form_state.dart';
import 'package:url_launcher/url_launcher.dart';

/// BLoC for managing contact form state and submission
/// Handles form validation and email sending
class ContactFormBloc extends Bloc<ContactFormEvent, ContactFormState> {
  ContactFormBloc({
    required this.portfolioRepository,
  }) : super(const ContactFormState()) {
    // Register event handlers
    on<SubmitContactForm>(_onSubmitContactForm);
    on<ResetContactForm>(_onResetContactForm);
  }

  final PortfolioRepository portfolioRepository;

  /// Handler for form submission
  Future<void> _onSubmitContactForm(
    SubmitContactForm event,
    Emitter<ContactFormState> emit,
  ) async {
    // Validate form
    final errors = _validateForm(event);

    if (errors.isNotEmpty) {
      debugPrint(
          "Form contains errors: ${errors.map((e) => e.message).join(", ")}");
      emit(
        state.copyWith(
          status: ContactFormStatus.error,
          errors: errors,
        ),
      );
      return;
    }

    // Form is valid, proceed with submission
    try {
      emit(state.copyWith(
        status: ContactFormStatus.loading,
        errors: [],
      ));

      debugPrint('Sending email...');
      await _sendEmail(event);

      emit(state.copyWith(
        status: ContactFormStatus.success,
        errors: [],
      ));
    } catch (e) {
      debugPrint('Error while sending email: $e');
      emit(
        state.copyWith(
          status: ContactFormStatus.error,
          errors: [FormValidationError.failedToSend],
        ),
      );
    }
  }

  /// Handler for form reset
  void _onResetContactForm(
    ResetContactForm event,
    Emitter<ContactFormState> emit,
  ) {
    emit(const ContactFormState());
  }

  /// Validate form inputs
  List<FormValidationError> _validateForm(SubmitContactForm form) {
    final errors = <FormValidationError>[];

    if (form.name.isEmpty) {
      errors.add(FormValidationError.emptyName);
    }

    if (form.subject.isEmpty) {
      errors.add(FormValidationError.emptySubject);
    }

    if (form.message.isEmpty) {
      errors.add(FormValidationError.emptyMessage);
    }

    final phoneError = _validatePhone(form.phone);
    if (phoneError != null) {
      errors.add(phoneError);
    }

    final emailError = _validateEmail(form.email);
    if (emailError != null) {
      errors.add(emailError);
    }

    return errors;
  }

  /// Validate phone number
  FormValidationError? _validatePhone(String? value) {
    const pattern = r'^\+?[0-9]{7,15}$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return FormValidationError.emptyPhone;
    } else if (!regExp.hasMatch(value)) {
      return FormValidationError.invalidPhone;
    }
    return null;
  }

  /// Validate email address
  FormValidationError? _validateEmail(String? value) {
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return FormValidationError.emptyEmail;
    } else if (!regExp.hasMatch(value)) {
      return FormValidationError.invalidEmail;
    }
    return null;
  }

  /// Send email using mailto URL
  Future<void> _sendEmail(SubmitContactForm form) async {
    // Default email - this could be configured via environment or fetched from PersonalInfo
    const userEmail = 'hrabas.serhii@gmail.com';
    final Uri url = Uri.parse(
      'mailto:$userEmail?subject=${form.subject}'
      '&body=${form.message}\n\n${form.email}\nPhone:${form.phone}',
    );

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
