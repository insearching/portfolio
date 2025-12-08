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
                  borderSide: BorderSide(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: UIColors.accent, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: widget.state.text,
                errorText: widget.state.errorText,
                labelStyle: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              maxLines: widget.state.maxLines,
              style: TextStyle(
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
