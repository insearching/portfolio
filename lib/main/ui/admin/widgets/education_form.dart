import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/ui/admin/admin_bloc.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';
import 'package:portfolio/main/ui/components/input_field.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';

/// Form for adding education records
class EducationForm extends StatefulWidget {
  const EducationForm({super.key});

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  EducationType _type = EducationType.certification;
  String _text = '';
  String _link = '';
  String _imageUrl = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_title.isEmpty || _description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Title and description are required'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final education = Education(
        title: _title,
        description: _description,
        type: _type,
        text: _text.isEmpty ? null : _text,
        link: _link.isEmpty ? null : _link,
        imageUrl: _imageUrl.isEmpty ? null : _imageUrl,
      );

      context.read<AdminBloc>().add(AddEducationEvent(education));
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _title = '';
      _description = '';
      _type = EducationType.certification;
      _text = '';
      _link = '';
      _imageUrl = '';
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
              content: Text(state.successMessage ?? 'Education added'),
              backgroundColor: Colors.green,
            ),
          );
          _resetForm();
        } else if (state.addOperationStatus == AddOperationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to add education'),
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
                'Add New Education',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              InputField(
                state: InputState(
                  text: 'Title',
                  onTextChanged: (value) => _title = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Description',
                  maxLines: 3,
                  onTextChanged: (value) => _description = value,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EducationType>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Education Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: EducationType.college,
                    child: Text('College'),
                  ),
                  DropdownMenuItem(
                    value: EducationType.certification,
                    child: Text('Certification'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _type = value ?? EducationType.certification;
                  });
                },
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Text (optional)',
                  maxLines: 3,
                  onTextChanged: (value) => _text = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Link (optional)',
                  onTextChanged: (value) => _link = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Image URL (optional)',
                  onTextChanged: (value) => _imageUrl = value,
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  return RippleButton(
                    text: state.isAddingItem ? 'Adding...' : 'Add Education',
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
