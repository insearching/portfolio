import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/repositories/auth_repository.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';
import 'package:portfolio/main/domain/repositories/skill_repository.dart';
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

void main() {
  group('AdminBloc - Authentication', () {
    late _FakeAuthenticateAdmin authenticateAdmin;
    late _FakeCheckAuthentication checkAuthentication;
    late _FakeAddBlogPost addBlogPost;
    late _FakeAddProject addProject;
    late _FakeAddSkill addSkill;
    late _FakeAddEducation addEducation;
    late _FakeAddPosition addPosition;

    setUp(() {
      authenticateAdmin = _FakeAuthenticateAdmin();
      checkAuthentication = _FakeCheckAuthentication();
      addBlogPost = _FakeAddBlogPost();
      addProject = _FakeAddProject();
      addSkill = _FakeAddSkill();
      addEducation = _FakeAddEducation();
      addPosition = _FakeAddPosition();
    });

    AdminBloc createBloc() => AdminBloc(
          authenticateAdmin: authenticateAdmin,
          checkAuthentication: checkAuthentication,
          addBlogPost: addBlogPost,
          addProject: addProject,
          addSkill: addSkill,
          addEducation: addEducation,
          addPosition: addPosition,
        );

    blocTest<AdminBloc, AdminState>(
      'CheckAdminAuth emits authenticated when check succeeds',
      build: createBloc,
      setUp: () {
        checkAuthentication.result = true;
      },
      act: (bloc) => bloc.add(const CheckAdminAuth()),
      expect: () => [
        const AdminState(authStatus: AuthStatus.authenticating),
        const AdminState(authStatus: AuthStatus.authenticated),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'CheckAdminAuth emits unauthenticated when check fails',
      build: createBloc,
      setUp: () {
        checkAuthentication.result = false;
      },
      act: (bloc) => bloc.add(const CheckAdminAuth()),
      expect: () => [
        const AdminState(authStatus: AuthStatus.authenticating),
        const AdminState(authStatus: AuthStatus.unauthenticated),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'AuthenticateAdminEvent emits authenticated on success',
      build: createBloc,
      setUp: () {
        authenticateAdmin.result = true;
      },
      act: (bloc) => bloc.add(
        const AuthenticateAdminEvent(
          email: 'test@example.com',
          password: 'password123',
        ),
      ),
      expect: () => [
        const AdminState(authStatus: AuthStatus.authenticating),
        const AdminState(authStatus: AuthStatus.authenticated),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'AuthenticateAdminEvent emits authenticationFailed on invalid credentials',
      build: createBloc,
      setUp: () {
        authenticateAdmin.result = false;
      },
      act: (bloc) => bloc.add(
        const AuthenticateAdminEvent(
          email: 'test@example.com',
          password: 'wrong',
        ),
      ),
      expect: () => [
        const AdminState(authStatus: AuthStatus.authenticating),
        const AdminState(
          authStatus: AuthStatus.authenticationFailed,
          errorMessage: 'Invalid credentials',
        ),
      ],
    );
  });

  group('AdminBloc - Add Operations', () {
    late _FakeAuthenticateAdmin authenticateAdmin;
    late _FakeCheckAuthentication checkAuthentication;
    late _FakeAddBlogPost addBlogPost;
    late _FakeAddProject addProject;
    late _FakeAddSkill addSkill;
    late _FakeAddEducation addEducation;
    late _FakeAddPosition addPosition;

    setUp(() {
      authenticateAdmin = _FakeAuthenticateAdmin();
      checkAuthentication = _FakeCheckAuthentication();
      addBlogPost = _FakeAddBlogPost();
      addProject = _FakeAddProject();
      addSkill = _FakeAddSkill();
      addEducation = _FakeAddEducation();
      addPosition = _FakeAddPosition();
    });

    AdminBloc createBloc() => AdminBloc(
          authenticateAdmin: authenticateAdmin,
          checkAuthentication: checkAuthentication,
          addBlogPost: addBlogPost,
          addProject: addProject,
          addSkill: addSkill,
          addEducation: addEducation,
          addPosition: addPosition,
        );

    blocTest<AdminBloc, AdminState>(
      'AddBlogPostEvent succeeds',
      build: createBloc,
      act: (bloc) => bloc.add(
        const AddBlogPostEvent(
          Post(
            title: 'Test',
            description: 'Desc',
            imageLink: 'link',
            link: 'link',
          ),
        ),
      ),
      expect: () => [
        const AdminState(addOperationStatus: AddOperationStatus.loading),
        const AdminState(
          addOperationStatus: AddOperationStatus.success,
          successMessage: 'Blog post added successfully',
        ),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'AddProjectEvent succeeds',
      build: createBloc,
      act: (bloc) => bloc.add(
        const AddProjectEvent(
          Project(
            image: 'img',
            title: 'Test',
            role: 'Dev',
            description: 'Desc',
          ),
        ),
      ),
      expect: () => [
        const AdminState(addOperationStatus: AddOperationStatus.loading),
        const AdminState(
          addOperationStatus: AddOperationStatus.success,
          successMessage: 'Project added successfully',
        ),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'AddSkillEvent succeeds',
      build: createBloc,
      act: (bloc) => bloc.add(
        const AddSkillEvent(
          Skill(title: 'Flutter', value: 90, type: SkillType.hard),
        ),
      ),
      expect: () => [
        const AdminState(addOperationStatus: AddOperationStatus.loading),
        const AdminState(
          addOperationStatus: AddOperationStatus.success,
          successMessage: 'Skill added successfully',
        ),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'AddEducationEvent succeeds',
      build: createBloc,
      act: (bloc) => bloc.add(
        const AddEducationEvent(
          Education(
            title: 'CS',
            description: 'Degree',
            type: EducationType.college,
          ),
        ),
      ),
      expect: () => [
        const AdminState(addOperationStatus: AddOperationStatus.loading),
        const AdminState(
          addOperationStatus: AddOperationStatus.success,
          successMessage: 'Education added successfully',
        ),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'AddPositionEvent succeeds',
      build: createBloc,
      act: (bloc) => bloc.add(
        const AddPositionEvent(
          Position(
            title: 'Company',
            position: 'Dev',
            description: 'Desc',
            icon: 'icon',
          ),
        ),
      ),
      expect: () => [
        const AdminState(addOperationStatus: AddOperationStatus.loading),
        const AdminState(
          addOperationStatus: AddOperationStatus.success,
          successMessage: 'Position added successfully',
        ),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'AddBlogPostEvent fails and emits error',
      build: createBloc,
      setUp: () {
        addBlogPost.shouldThrow = true;
      },
      act: (bloc) => bloc.add(
        const AddBlogPostEvent(
          Post(title: 'T', description: 'D', imageLink: 'L', link: 'L'),
        ),
      ),
      expect: () => [
        const AdminState(addOperationStatus: AddOperationStatus.loading),
        predicate<AdminState>((state) {
          return state.addOperationStatus == AddOperationStatus.failure &&
              state.errorMessage != null &&
              state.errorMessage!.contains('Failed to add blog post');
        }),
      ],
    );

    blocTest<AdminBloc, AdminState>(
      'ResetAddOperationState resets the state',
      build: createBloc,
      seed: () => const AdminState(
        addOperationStatus: AddOperationStatus.success,
        successMessage: 'Success',
      ),
      act: (bloc) => bloc.add(const ResetAddOperationState()),
      expect: () => [
        const AdminState(addOperationStatus: AddOperationStatus.initial),
      ],
    );
  });
}

// Fake use cases for testing

class _FakeAuthenticateAdmin extends AuthenticateAdmin {
  _FakeAuthenticateAdmin()
      : super(
          authRepository: _FakeAuthRepository(),
        );

  bool result = true;

  @override
  Future<bool> call(String email, String password) async {
    return result;
  }
}

class _FakeCheckAuthentication extends CheckAuthentication {
  _FakeCheckAuthentication()
      : super(
          authRepository: _FakeAuthRepository(),
        );

  bool result = true;

  @override
  Future<bool> call() async {
    return result;
  }
}

class _FakeAddBlogPost extends AddBlogPost {
  _FakeAddBlogPost() : super(blogRepository: _FakeBlogRepo());

  bool shouldThrow = false;

  @override
  Future<void> call(Post post) async {
    if (shouldThrow) {
      throw Exception('Add failed');
    }
  }
}

class _FakeAddProject extends AddProject {
  _FakeAddProject() : super(projectRepository: _FakeProjectRepo());

  @override
  Future<void> call(Project project) async {}
}

class _FakeAddSkill extends AddSkill {
  _FakeAddSkill() : super(skillRepository: _FakeSkillRepo());

  @override
  Future<void> call(Skill skill) async {}
}

class _FakeAddEducation extends AddEducation {
  _FakeAddEducation() : super(educationRepository: _FakeEducationRepo());

  @override
  Future<void> call(Education education) async {}
}

class _FakeAddPosition extends AddPosition {
  _FakeAddPosition() : super(positionRepository: _FakePositionRepo());

  @override
  Future<void> call(Position position) async {}
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<bool> authenticate(String email, String password) async => true;

  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<void> signOut() async {}

  @override
  Future<String?> getCurrentUserEmail() async => null;
}

class _FakeBlogRepo implements BlogRepository {
  @override
  Future<void> addPost(Post post) async {}

  @override
  Stream<List<Post>> getPosts() => Stream.value([]);

  @override
  Future<List<Post>> refreshPosts() async => [];

  @override
  Stream<List<Post>> get postsUpdateStream => Stream.value([]);
}

class _FakeProjectRepo implements ProjectRepository {
  @override
  Future<void> addProject(Project project) async {}

  @override
  Stream<List<Project>> getProjects() => Stream.value([]);

  @override
  Future<List<Project>> refreshProjects() async => [];

  @override
  Stream<List<Project>> get projectsUpdateStream => Stream.value([]);
}

class _FakeSkillRepo implements SkillRepository {
  @override
  Future<void> addSkill(Skill skill) async {}

  @override
  Stream<List<Skill>> getSkills() => Stream.value([]);

  @override
  Future<List<Skill>> refreshSkills() async => [];

  @override
  Stream<List<Skill>> get skillsUpdateStream => Stream.value([]);
}

class _FakeEducationRepo implements EducationRepository {
  @override
  Future<void> addEducation(Education education) async {}

  @override
  Stream<List<Education>> getEducation() => Stream.value([]);

  @override
  Future<List<Education>> refreshEducation() async => [];

  @override
  Stream<List<Education>> get educationUpdateStream => Stream.value([]);
}

class _FakePositionRepo implements PositionRepository {
  @override
  Future<void> addPosition(Position position) async {}

  @override
  Stream<List<Position>> getPositions() => Stream.value([]);

  @override
  Future<List<Position>> refreshPositions() async => [];

  @override
  Stream<List<Position>> get positionsUpdateStream => Stream.value([]);
}
