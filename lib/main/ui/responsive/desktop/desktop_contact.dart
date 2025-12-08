import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/bloc/contact_form_bloc.dart';
import 'package:portfolio/main/bloc/contact_form_event.dart';
import 'package:portfolio/main/bloc/contact_form_state.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/repository/portfolio_repository.dart';
import 'package:portfolio/main/service_locator.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/main/ui/components/input_field.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';
import 'package:portfolio/main/ui/socials.dart';

class DesktopContact extends StatelessWidget {
  const DesktopContact({
    required this.info,
    required this.onMessageSend,
    super.key,
  });

  final PersonalInfo info;
  final ValueChanged<SubmitContactForm> onMessageSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0, bottom: 64.0),
      child: Column(
        children: [
          Text(
            'Contact with me',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32.0),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _ContactInfoContainer(info: info)),
                const SizedBox(width: 32.0),
                Expanded(
                  child: _ContactForm(
                    onMessageSend: onMessageSend,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ContactInfoContainer extends StatefulWidget {
  const _ContactInfoContainer({
    required this.info,
    Key? key,
  }) : super(key: key);

  final PersonalInfo info;

  @override
  State<_ContactInfoContainer> createState() => _ContactInfoContainerState();
}

class _ContactInfoContainerState extends State<_ContactInfoContainer> {
  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              widget.info.image,
            ),
          ),
          const SizedBox(height: 32.0),
          Text(
            widget.info.title,
            style: Theme.of(context).textTheme.bodyLarge,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16.0),
          Text(
            widget.info.description,
            style: Theme.of(context).textTheme.bodyMedium,
            softWrap: true,
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16.0),
          Socials(socials: widget.info.socials)
        ],
      ),
    );
  }
}

class InputForm {
  String name;
  String phone;
  String email;
  String subject;
  String message;

  InputForm({
    this.name = "",
    this.phone = "",
    this.email = "",
    this.subject = "",
    this.message = "",
  });
}

class _ContactForm extends StatefulWidget {
  const _ContactForm({
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final ValueChanged<SubmitContactForm> onMessageSend;

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  String name = "";
  String phone = "";
  String email = "";
  String subject = "";
  String message = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactFormBloc(
        portfolioRepository: locator<PortfolioRepository>(),
      ),
      child: BlocBuilder<ContactFormBloc, ContactFormState>(
        // listener: (context, state) {
        //   if (state is FormSuccess) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(content: Text('Email sent successfully!')),
        //     );
        //   }
        // },
        builder: (context, state) {
          return ElevatedContainer(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            state: InputState(
                              text: 'Your name',
                              errorText: state.status.isError
                                  ? state.getErrorMessage(
                                      state.errors.firstWhereOrNull(
                                        (error) =>
                                            error ==
                                            FormValidationError.emptyName,
                                      ),
                                    )
                                  : null,
                              onTextChanged: (text) {
                                name = text;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: InputField(
                            state: InputState(
                              text: 'Your phone',
                              errorText: state.status.isError
                                  ? state.getErrorMessage(state.errors
                                      .firstWhereOrNull((error) =>
                                          error ==
                                              FormValidationError.emptyPhone ||
                                          error ==
                                              FormValidationError.invalidPhone))
                                  : null,
                              textInputType: TextInputType.phone,
                              onTextChanged: (text) {
                                phone = text;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    InputField(
                      state: InputState(
                        text: 'Your email',
                        errorText: state.status.isError
                            ? state.getErrorMessage(state.errors
                                .firstWhereOrNull((error) =>
                                    error == FormValidationError.emptyEmail ||
                                    error == FormValidationError.invalidEmail))
                            : null,
                        onTextChanged: (text) {
                          email = text;
                        },
                      ),
                    ), //email
                    InputField(
                      state: InputState(
                        text: 'Your subject',
                        errorText: state.status.isError
                            ? state.getErrorMessage(state.errors
                                .firstWhereOrNull((error) =>
                                    error == FormValidationError.emptySubject))
                            : null,
                        onTextChanged: (text) {
                          subject = text;
                        },
                      ),
                    ), //subject
                    InputField(
                      state: InputState(
                        text: 'Your message',
                        errorText: state.status.isError
                            ? state.getErrorMessage(state.errors
                                .firstWhereOrNull((error) =>
                                    error == FormValidationError.emptyMessage))
                            : null,
                        maxLines: 10,
                        onTextChanged: (text) {
                          message = text;
                        },
                      ),
                    ), //message
                  ],
                ),
                RippleButton(
                    text: 'Send message',
                    onTap: () {
                      final event = SubmitContactForm(
                        name: name,
                        phone: phone,
                        email: email,
                        subject: subject,
                        message: message,
                      );
                      context.read<ContactFormBloc>().add(event);
                    })
              ],
            ),
          );
        },
      ),
    );
  }
}
