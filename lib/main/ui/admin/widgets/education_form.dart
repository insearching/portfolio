import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/ui/admin/admin_bloc.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';
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
      final education = Education(
        title: _title.trim(),
        description: _description.trim(),
        type: _type,
        text: _text.trim().isEmpty ? null : _text.trim(),
        link: _link.trim().isEmpty ? null : _link.trim(),
        imageUrl: _imageUrl.trim().isEmpty ? null : _imageUrl.trim(),
      );

      context.read<AdminBloc>().add(AddEducationEvent(education));
    }
  }

  /// Validates if a string is a valid URL with http/https scheme
  String? _validateUrl(String? value, String fieldName,
      {bool optional = false}) {
    if (value == null || value.trim().isEmpty) {
      if (optional) return null;
      return '$fieldName cannot be empty';
    }

    try {
      final uri = Uri.parse(value.trim());
      if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
        return '$fieldName must start with http:// or https://';
      }
      if (!uri.hasAuthority) {
        return '$fieldName must be a valid URL';
      }
    } catch (e) {
      return '$fieldName is not a valid URL';
    }

    return null;
  }

  /// Validates non-empty text fields
  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) => _title = value,
                validator: (value) => _validateNotEmpty(value, 'Title'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                onChanged: (value) => _description = value,
                validator: (value) => _validateNotEmpty(value, 'Description'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<EducationType>(
                initialValue: _type,
                decoration: InputDecoration(
                  labelText: 'Education Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Text (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                onChanged: (value) => _text = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Link (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'https://example.com/certificate',
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => _link = value,
                validator: (value) =>
                    _validateUrl(value, 'Link', optional: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Image URL (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'https://example.com/image.jpg',
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => _imageUrl = value,
                validator: (value) =>
                    _validateUrl(value, 'Image URL', optional: true),
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
