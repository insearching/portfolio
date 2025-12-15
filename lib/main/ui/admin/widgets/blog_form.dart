import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/ui/admin/admin_bloc.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';
import 'package:portfolio/main/ui/components/input_field.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';

/// Form for adding blog posts
class BlogForm extends StatefulWidget {
  const BlogForm({super.key});

  @override
  State<BlogForm> createState() => _BlogFormState();
}

class _BlogFormState extends State<BlogForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _imageLink = '';
  String _link = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final post = Post(
        title: _title,
        description: _description,
        imageLink: _imageLink,
        link: _link,
      );

      context.read<AdminBloc>().add(AddBlogPostEvent(post));
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _title = '';
      _description = '';
      _imageLink = '';
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
              content: Text(state.successMessage ?? 'Blog post added'),
              backgroundColor: Colors.green,
            ),
          );
          _resetForm();
        } else if (state.addOperationStatus == AddOperationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to add blog post'),
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
                'Add New Blog Post',
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
                  maxLines: 5,
                  onTextChanged: (value) => _description = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Image Link (URL)',
                  onTextChanged: (value) => _imageLink = value,
                ),
              ),
              const SizedBox(height: 16),
              InputField(
                state: InputState(
                  text: 'Post Link (URL)',
                  onTextChanged: (value) => _link = value,
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<AdminBloc, AdminState>(
                builder: (context, state) {
                  return RippleButton(
                    text: state.isAddingItem ? 'Adding...' : 'Add Blog Post',
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
