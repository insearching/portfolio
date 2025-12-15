import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/main/di/service_locator.dart';
import 'package:portfolio/main/domain/usecases/add_blog_post.dart';
import 'package:portfolio/main/domain/usecases/add_education.dart';
import 'package:portfolio/main/domain/usecases/add_position.dart';
import 'package:portfolio/main/domain/usecases/add_project.dart';
import 'package:portfolio/main/domain/usecases/add_skill.dart';
import 'package:portfolio/main/domain/usecases/authenticate_admin.dart';
import 'package:portfolio/main/domain/usecases/check_authentication.dart';
import 'package:portfolio/main/ui/admin/admin_bloc.dart';
import 'package:portfolio/main/ui/admin/admin_event.dart';
import 'package:portfolio/main/ui/admin/admin_state.dart';
import 'package:portfolio/main/ui/admin/widgets/admin_content.dart';
import 'package:portfolio/utils/env_config.dart';

/// Admin page for managing portfolio content
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc(
        authenticateAdmin: locator<AuthenticateAdmin>(),
        checkAuthentication: locator<CheckAuthentication>(),
        addBlogPost: locator<AddBlogPost>(),
        addProject: locator<AddProject>(),
        addSkill: locator<AddSkill>(),
        addEducation: locator<AddEducation>(),
        addPosition: locator<AddPosition>(),
      )..add(const CheckAdminAuth()),
      child: const _AdminPageContent(),
    );
  }
}

class _AdminPageContent extends StatelessWidget {
  const _AdminPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          // Trigger background authentication if not authenticated
          if (state.authStatus == AuthStatus.unauthenticated) {
            try {
              final email = EnvConfig.firebaseEmail;
              final password = EnvConfig.firebasePassword;
              context.read<AdminBloc>().add(
                    AuthenticateAdminEvent(email: email, password: password),
                  );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Auth config error: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }

          // Show authentication error
          if (state.authStatus == AuthStatus.authenticationFailed &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isAuthenticating) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Authenticating...'),
                ],
              ),
            );
          }

          if (!state.isAuthenticated) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Authenticating in background...'),
                ],
              ),
            );
          }

          return const AdminContent();
        },
      ),
    );
  }
}
