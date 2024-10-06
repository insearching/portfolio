import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/data/repository.dart';
import 'package:url_launcher/url_launcher.dart';

class MainBloc extends Bloc<FormEvent, ContactFormState> {
  MainBloc() : super(FormInitial()) {
    on<SubmitFormEvent>((event, emit) async {
      final List<InputFormError> errors = _isFormValid(event);
      if (errors.isNotEmpty) {
        debugPrint("Form contains errors ${errors.join(", ")}");
        emit(FormError(errors: errors)); // Emit error state with list of errors
      } else {
        try {
          emit(FormLoading());
          debugPrint('loading');
          _sendEmail(event);
          emit(FormSuccess());
        } catch (e) {
          debugPrint('error while sending email');
          emit(FormError(errors: [InputFormError.FailedToSendEmail]));
        }
      }
    });
  }

  Future<void> _sendEmail(SubmitFormEvent form) async {
    final Uri url = Uri.parse(
        'mailto:${Repository.info.email}?subject=${form.subject}'
            '&body=${form.message}\n\n${form.email}\nPhone:${form.phone}');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  List<InputFormError> _isFormValid(SubmitFormEvent form) {
    List<InputFormError> states = List.empty(growable: true);
    if (form.name.isEmpty) states.add(InputFormError.EmptyName);
    if (form.subject.isEmpty) states.add(InputFormError.EmptySubject);
    if (form.message.isEmpty) states.add(InputFormError.EmptyMessage);
    final phoneState = _isPhoneNumberValid(form.phone);
    if (phoneState != null) {
      states.add(phoneState);
    }
    final emailState = _validateEmail(form.email);
    if (emailState != null) {
      states.add(emailState);
    }
    return states;
  }

  InputFormError? _isPhoneNumberValid(String? value) {
    String pattern = r'^\+?[0-9]{7,15}$';
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      // return 'Please enter a phone number';
      return InputFormError.EmptyPhone;
    } else if (!regExp.hasMatch(value)) {
      return InputFormError.NotValidPhone;
      // return 'Please enter a valid phone number';
    }
    return null;
  }

  InputFormError? _validateEmail(String? value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      // return 'Please enter an email address';
      return InputFormError.EmptyEmail;
    } else if (!regExp.hasMatch(value)) {
      // return 'Please enter a valid email address';
      return InputFormError.NotValidEmail;
    }
    return null; // Validation passed
  }
}

enum InputFormError {
  EmptyName,
  EmptySubject,
  EmptyMessage,
  EmptyPhone,
  NotValidPhone,
  EmptyEmail,
  NotValidEmail,
  FailedToSendEmail,
}

abstract class ContactFormState {}

class FormInitial extends ContactFormState {}

class FormLoading extends ContactFormState {}

class FormSuccess extends ContactFormState {}

class FormError extends ContactFormState {
  final List<InputFormError> errors;

  FormError({required this.errors});

  String? getErrorMessage(InputFormError? error) {
    switch (error) {
      case InputFormError.EmptyName:
        return "Please input name";
      case InputFormError.EmptySubject:
        return "Please input subject";
      case InputFormError.EmptyMessage:
        return "Please input message";
      case InputFormError.EmptyPhone:
        return "Please input phone";
      case InputFormError.EmptyEmail:
        return "Please input email";
      case InputFormError.NotValidPhone:
        return "Not a valid phone number";
      case InputFormError.NotValidEmail:
        return "Not a valid email";
      case InputFormError.FailedToSendEmail:
        return "Failed to send email, please try again...";
      case null:
        return null;
    }
  }
}

abstract class FormEvent {}

class SubmitFormEvent extends FormEvent {
  String name;
  String phone;
  String email;
  String subject;
  String message;

  SubmitFormEvent({
    this.name = "",
    this.phone = "",
    this.email = "",
    this.subject = "",
    this.message = "",
  });
}
