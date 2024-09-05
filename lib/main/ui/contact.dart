import 'package:flutter/material.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/ui/components/container_title.dart';
import 'package:portfolio/main/ui/components/input_field.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';
import 'package:portfolio/main/ui/socials.dart';

import 'components/elevated_container.dart';

class Contact extends StatefulWidget {
  const Contact({
    required this.info,
    required this.onMessageSend,
    super.key,
  });

  final PersonalInfo info;
  final ValueChanged<InputForm> onMessageSend;

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0, bottom: 64.0),
      child: Column(
        children: [
          const ContainerTitle(
            title: 'Contact with me ',
            subtitle: 'Contact',
          ),
          const SizedBox(height: 32.0),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _ContactInfoContainer(info: widget.info)),
                const SizedBox(width: 32.0),
                Expanded(child: _ContactForm(
                  onMessageSend: widget.onMessageSend,
                ))
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
      child: Padding(
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
            const Socials()
          ],
        ),
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
  _ContactForm({
    required this.onMessageSend,
    Key? key,
  }) : super(key: key);

  final ValueChanged<InputForm> onMessageSend;

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  @override
  Widget build(BuildContext context) {
    var state = InputForm();
    return ElevatedContainer(
      child: Padding(
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
                            onTextChanged: (text) {
                              state.name = text;
                            }),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: InputField(
                        state: InputState(
                            text: 'Your phone',
                            textInputType: TextInputType.phone,
                            onTextChanged: (text) {
                              state.phone = text;
                            }),
                      ),
                    ),
                  ],
                ),
                InputField(
                  state: InputState(
                    text: 'Your email',
                    onTextChanged: (text) {
                      state.email = text;
                    },
                  ),
                ), //email
                InputField(
                  state: InputState(
                    text: 'Your subject',
                    onTextChanged: (text) {
                      state.subject = text;
                    },
                  ),
                ), //subject
                InputField(
                  state: InputState(
                    text: 'Your message',
                    maxLines: 10,
                    onTextChanged: (text) {
                      state.subject = text;
                    },
                  ),
                ), //message
              ],
            ),
            RippleButton(
              text: 'Send message',
              onTap: () => widget.onMessageSend(state),
            )
          ],
        ),
      ),
    );
  }
}
