import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/ui/admin/admin_bloc.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';
import 'package:portfolio/main/ui/components/input_field.dart';
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
        image: _image.isEmpty ? 'assets/img/default.png' : _image,
        title: _title,
        role: _role,
        description: _description,
        link: _link.isEmpty ? null : _link,
      );

      context.read<AdminBloc>().add(AddProjectEvent(project));
    }
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
              InputField(
                state: InputState(
                  text: 'Title',
                  onTextChanged: (value) => _title = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Role',
                  onTextChanged: (value) => _role = value,
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
                  text: 'Image URL (optional)',
                  onTextChanged: (value) => _image = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Project Link (optional)',
                  onTextChanged: (value) => _link = value,
                ),
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
