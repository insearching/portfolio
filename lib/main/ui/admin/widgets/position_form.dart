import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/ui/admin/admin_bloc.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';
import 'package:portfolio/main/ui/components/input_field.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';

/// Form for adding positions
class PositionForm extends StatefulWidget {
  const PositionForm({super.key});

  @override
  State<PositionForm> createState() => _PositionFormState();
}

class _PositionFormState extends State<PositionForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _position = '';
  String _description = '';
  String _icon = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_title.isEmpty || _position.isEmpty || _description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Title, position, and description are required'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final positionObj = Position(
        title: _title,
        position: _position,
        description: _description,
        icon: _icon.isEmpty ? 'assets/img/android.png' : _icon,
      );

      context.read<AdminBloc>().add(AddPositionEvent(positionObj));
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _title = '';
      _position = '';
      _description = '';
      _icon = '';
    });
    context.read<AdminBloc>().add(const ResetAddOperationState());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state.addOperationStatus == AddOperationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? 'Position added'),
              backgroundColor: Colors.green,
            ),
          );
          _resetForm();
        } else if (state.addOperationStatus == AddOperationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to add position'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add New Position',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              InputField(
                state: InputState(
                  text: 'Company/Organization Title',
                  onTextChanged: (value) => _title = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Position/Role',
                  onTextChanged: (value) => _position = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Description',
                  maxLines: 5,
                  onTextChanged: (value) => _description = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Icon URL (optional)',
                  onTextChanged: (value) => _icon = value,
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  return RippleButton(
                    text: state.isAddingItem ? 'Adding...' : 'Add Position',
                    onTap: state.isAddingItem ? () {} : _submitForm,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
