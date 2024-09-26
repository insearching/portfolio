import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/utils/colors.dart';

class InputState {
  InputState({
    required this.text,
    this.errorText,
    this.maxLines = 1,
    this.textInputType = TextInputType.text,
    this.onTextChanged,
  });

  final String text;
  final String? errorText;
  final int maxLines;
  final TextInputType textInputType;
  final ValueChanged<String>? onTextChanged;
}

class InputField extends StatefulWidget {
  const InputField({
    required this.state,
    key,
  }) : super(key: key);

  final InputState state;

  @override
  State<InputField> createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: UIColors.darkGrey, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: UIColors.accent, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: widget.state.text,
                labelStyle: const TextStyle(
                  fontSize: 18.0,
                  color: UIColors.lightGrey,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: UIColors.black,
              ),
              maxLines: widget.state.maxLines,
              validator: (value) {
                return widget.state.errorText;
              },
              style: const TextStyle(
                fontSize: 18.0,
                color: UIColors.lightGrey,
              ),
              keyboardType: widget.state.textInputType,
              inputFormatters: <TextInputFormatter>[
                if (widget.state.textInputType == TextInputType.phone)
                  FilteringTextInputFormatter.digitsOnly
                else
                  FilteringTextInputFormatter.singleLineFormatter
              ],
              onChanged: (text) {
                widget.state.onTextChanged?.call(text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
