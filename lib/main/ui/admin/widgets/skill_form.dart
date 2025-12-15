import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/ui/admin/admin_bloc.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';
import 'package:portfolio/main/ui/components/input_field.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';

/// Form for adding skills
class SkillForm extends StatefulWidget {
  const SkillForm({super.key});

  @override
  State<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends State<SkillForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  int _value = 0;
  SkillType _type = SkillType.hard;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_title.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a skill title'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (_value <= 0 || _value > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Skill value must be between 1 and 100'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final skill = Skill(
        title: _title,
        value: _value,
        type: _type,
      );

      context.read<AdminBloc>().add(AddSkillEvent(skill));
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _title = '';
      _value = 0;
      _type = SkillType.hard;
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
              content: Text(state.successMessage ?? 'Skill added'),
              backgroundColor: Colors.green,
            ),
          );
          _resetForm();
        } else if (state.addOperationStatus == AddOperationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to add skill'),
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
                'Add New Skill',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              InputField(
                state: InputState(
                  text: 'Skill Title',
                  onTextChanged: (value) => _title = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Skill Value (1-100)',
                  textInputType: TextInputType.number,
                  onTextChanged: (value) {
                    _value = int.tryParse(value) ?? 0;
                  },
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<SkillType>(
                value: _type,
                decoration: const InputDecoration(
                  labelText: 'Skill Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: SkillType.hard,
                    child: Text('Hard Skill'),
                  ),
                  DropdownMenuItem(
                    value: SkillType.soft,
                    child: Text('Soft Skill'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _type = value ?? SkillType.hard;
                  });
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  return RippleButton(
                    text: state.isAddingItem ? 'Adding...' : 'Add Skill',
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
