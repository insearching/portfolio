import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/ui/admin/admin_bloc.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';
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
        title: _title.trim(),
        description: _description.trim(),
        imageLink: _imageLink.trim(),
        link: _link.trim(),
      );

      context.read<AdminBloc>().add(AddBlogPostEvent(post));
    }
  }

  /// Validates if a string is a valid URL with http/https scheme
  String? _validateUrl(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
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
                maxLines: 5,
                onChanged: (value) => _description = value,
                validator: (value) => _validateNotEmpty(value, 'Description'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Image Link (URL)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'https://example.com/image.jpg',
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => _imageLink = value,
                validator: (value) => _validateUrl(value, 'Image link'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Post Link (URL)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'https://example.com/post',
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => _link = value,
                validator: (value) => _validateUrl(value, 'Post link'),
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
