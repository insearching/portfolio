import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/ui/admin/admin_bloc.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';

/// Form for adding projects
class ProjectForm extends StatefulWidget {
  const ProjectForm({super.key});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  String _image = '';
  String _title = '';
  String _role = '';
  String _description = '';
  String _link = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final project = Project(
        image: _image.trim(),
        title: _title.trim(),
        role: _role.trim(),
        description: _description.trim(),
        link: _link.trim().isEmpty ? null : _link.trim(),
      );

      context.read<AdminBloc>().add(AddProjectEvent(project));
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
      _image = '';
      _title = '';
      _role = '';
      _description = '';
      _link = '';
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
              content: Text(state.successMessage ?? 'Project added'),
              backgroundColor: Colors.green,
            ),
          );
          _resetForm();
        } else if (state.addOperationStatus == AddOperationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to add project'),
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
                'Add New Project',
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
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) => _role = value,
                validator: (value) => _validateNotEmpty(value, 'Role'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 5,
                onChanged: (value) => _description = value,
                validator: (value) => _validateNotEmpty(value, 'Description'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'https://example.com/image.jpg',
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => _image = value,
                validator: (value) => _validateUrl(value, 'Image URL'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Project Link (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'https://example.com/project',
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => _link = value,
                validator: (value) =>
                    _validateUrl(value, 'Project link', optional: true),
              ),
              const SizedBox(height: 32),
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  return RippleButton(
                    text: state.isAddingItem ? 'Adding...' : 'Add Project',
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
