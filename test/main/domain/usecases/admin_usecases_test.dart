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

void main() {
  group('AuthenticateAdmin', () {
    test('returns true when authentication succeeds', () async {
      final repo = _FakeAuthRepository(authenticateResult: true);
      final usecase = AuthenticateAdmin(authRepository: repo);

      final result = await usecase('test@example.com', 'password123');

      expect(result, true);
      expect(repo.lastEmail, 'test@example.com');
      expect(repo.lastPassword, 'password123');
    });

    test('returns false when authentication fails', () async {
      final repo = _FakeAuthRepository(authenticateResult: false);
      final usecase = AuthenticateAdmin(authRepository: repo);

      final result = await usecase('test@example.com', 'wrong');

      expect(result, false);
    });

    test('throws exception when repository throws', () async {
      final repo = _FakeAuthRepository(throwOnAuthenticate: true);
      final usecase = AuthenticateAdmin(authRepository: repo);

      expect(
        () => usecase('test@example.com', 'password'),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Authentication failed'),
          ),
        ),
      );
    });
  });

  group('CheckAuthentication', () {
    test('returns true when user is authenticated', () async {
      final repo = _FakeAuthRepository(isAuthenticatedResult: true);
      final usecase = CheckAuthentication(authRepository: repo);

      final result = await usecase();

      expect(result, true);
    });

    test('returns false when user is not authenticated', () async {
      final repo = _FakeAuthRepository(isAuthenticatedResult: false);
      final usecase = CheckAuthentication(authRepository: repo);

      final result = await usecase();

      expect(result, false);
    });

    test('returns false when repository throws', () async {
      final repo = _FakeAuthRepository(throwOnIsAuthenticated: true);
      final usecase = CheckAuthentication(authRepository: repo);

      final result = await usecase();

      expect(result, false);
    });
  });

  group('AddBlogPost', () {
    test('successfully adds a blog post', () async {
      final repo = _FakeBlogRepository();
      final usecase = AddBlogPost(blogRepository: repo);

      const post = Post(
        title: 'Test Post',
        description: 'Test Description',
        imageLink: 'https://example.com/image.jpg',
        link: 'https://example.com/post',
      );

      await usecase(post);

      expect(repo.addedPost, post);
    });

    test('throws exception when repository fails', () async {
      final repo = _FakeBlogRepository(throwOnAdd: true);
      final usecase = AddBlogPost(blogRepository: repo);

      const post = Post(
        title: 'Test',
        description: 'Test',
        imageLink: 'https://example.com/image.jpg',
        link: 'https://example.com/post',
      );

      expect(
        () => usecase(post),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('Failed to add'),
          ),
        ),
      );
    });

    test('throws ArgumentError when title is empty', () async {
      final repo = _FakeBlogRepository();
      final usecase = AddBlogPost(blogRepository: repo);

      const post = Post(
        title: '',
        description: 'Test Description',
        imageLink: 'https://example.com/image.jpg',
        link: 'https://example.com/post',
      );

      expect(
        () => usecase(post),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Title cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when description is empty', () async {
      final repo = _FakeBlogRepository();
      final usecase = AddBlogPost(blogRepository: repo);

      const post = Post(
        title: 'Test Title',
        description: '',
        imageLink: 'https://example.com/image.jpg',
        link: 'https://example.com/post',
      );

      expect(
        () => usecase(post),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Description cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when image link is empty', () async {
      final repo = _FakeBlogRepository();
      final usecase = AddBlogPost(blogRepository: repo);

      const post = Post(
        title: 'Test Title',
        description: 'Test Description',
        imageLink: '',
        link: 'https://example.com/post',
      );

      expect(
        () => usecase(post),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Image link cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when image link is invalid URL', () async {
      final repo = _FakeBlogRepository();
      final usecase = AddBlogPost(blogRepository: repo);

      const post = Post(
        title: 'Test Title',
        description: 'Test Description',
        imageLink: 'not-a-valid-url',
        link: 'https://example.com/post',
      );

      expect(
        () => usecase(post),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Image link must be a valid URL'),
          ),
        ),
      );
    });

    test('throws ArgumentError when post link is empty', () async {
      final repo = _FakeBlogRepository();
      final usecase = AddBlogPost(blogRepository: repo);

      const post = Post(
        title: 'Test Title',
        description: 'Test Description',
        imageLink: 'https://example.com/image.jpg',
        link: '',
      );

      expect(
        () => usecase(post),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Post link cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when post link is invalid URL', () async {
      final repo = _FakeBlogRepository();
      final usecase = AddBlogPost(blogRepository: repo);

      const post = Post(
        title: 'Test Title',
        description: 'Test Description',
        imageLink: 'https://example.com/image.jpg',
        link: 'invalid-url',
      );

      expect(
        () => usecase(post),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Post link must be a valid URL'),
          ),
        ),
      );
    });

    test('trims whitespace from fields before validation', () async {
      final repo = _FakeBlogRepository();
      final usecase = AddBlogPost(blogRepository: repo);

      const post = Post(
        title: '  ',
        description: '  Test Description  ',
        imageLink: 'https://example.com/image.jpg',
        link: 'https://example.com/post',
      );

      expect(
        () => usecase(post),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Title cannot be empty'),
          ),
        ),
      );
    });
  });

  group('AddProject', () {
    test('successfully adds a project', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'https://example.com/image.jpg',
        title: 'Test Project',
        role: 'Developer',
        description: 'Test Description',
      );

      await usecase(project);

      expect(repo.addedProject, project);
    });

    test('throws exception when repository fails', () async {
      final repo = _FakeProjectRepository(throwOnAdd: true);
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'https://example.com/image.jpg',
        title: 'Test',
        role: 'Dev',
        description: 'Desc',
      );

      expect(
        () => usecase(project),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('Failed to add'),
          ),
        ),
      );
    });

    test('throws ArgumentError when title is empty', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'https://example.com/image.jpg',
        title: '',
        role: 'Developer',
        description: 'Test Description',
      );

      expect(
        () => usecase(project),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Title cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when role is empty', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'https://example.com/image.jpg',
        title: 'Test Project',
        role: '',
        description: 'Test Description',
      );

      expect(
        () => usecase(project),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Role cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when description is empty', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'https://example.com/image.jpg',
        title: 'Test Project',
        role: 'Developer',
        description: '',
      );

      expect(
        () => usecase(project),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Description cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when image URL is empty', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: '',
        title: 'Test Project',
        role: 'Developer',
        description: 'Test Description',
      );

      expect(
        () => usecase(project),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Image URL cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when image URL is invalid', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'not-a-valid-url',
        title: 'Test Project',
        role: 'Developer',
        description: 'Test Description',
      );

      expect(
        () => usecase(project),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Image URL must be a valid URL'),
          ),
        ),
      );
    });

    test('throws ArgumentError when project link is invalid', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'https://example.com/image.jpg',
        title: 'Test Project',
        role: 'Developer',
        description: 'Test Description',
        link: 'invalid-url',
      );

      expect(
        () => usecase(project),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Project link must be a valid URL'),
          ),
        ),
      );
    });

    test('allows null project link', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'https://example.com/image.jpg',
        title: 'Test Project',
        role: 'Developer',
        description: 'Test Description',
        link: null,
      );

      await usecase(project);

      expect(repo.addedProject, project);
    });

    test('allows valid project link', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'https://example.com/image.jpg',
        title: 'Test Project',
        role: 'Developer',
        description: 'Test Description',
        link: 'https://github.com/user/project',
      );

      await usecase(project);

      expect(repo.addedProject, project);
    });

    test('trims whitespace from fields before validation', () async {
      final repo = _FakeProjectRepository();
      final usecase = AddProject(projectRepository: repo);

      const project = Project(
        image: 'https://example.com/image.jpg',
        title: '  ',
        role: 'Developer',
        description: 'Test Description',
      );

      expect(
        () => usecase(project),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Title cannot be empty'),
          ),
        ),
      );
    });
  });

  group('AddSkill', () {
    test('successfully adds a skill', () async {
      final repo = _FakeSkillRepository();
      final usecase = AddSkill(skillRepository: repo);

      const skill = Skill(
        title: 'Flutter',
        value: 90,
        type: SkillType.hard,
      );

      await usecase(skill);

      expect(repo.addedSkill, skill);
    });

    test('throws exception when repository fails', () async {
      final repo = _FakeSkillRepository(throwOnAdd: true);
      final usecase = AddSkill(skillRepository: repo);

      const skill = Skill(title: 'Test', value: 50, type: SkillType.soft);

      expect(
        () => usecase(skill),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('Failed to add'),
          ),
        ),
      );
    });
  });

  group('AddEducation', () {
    test('successfully adds education', () async {
      final repo = _FakeEducationRepository();
      final usecase = AddEducation(educationRepository: repo);

      const education = Education(
        title: 'Computer Science',
        description: 'University Degree',
        type: EducationType.college,
      );

      await usecase(education);

      expect(repo.addedEducation, education);
    });

    test('throws exception when repository fails', () async {
      final repo = _FakeEducationRepository(throwOnAdd: true);
      final usecase = AddEducation(educationRepository: repo);

      const education = Education(
        title: 'Test',
        description: 'Desc',
        type: EducationType.certification,
      );

      expect(
        () => usecase(education),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('Failed to add'),
          ),
        ),
      );
    });

    test('throws ArgumentError when title is empty', () async {
      final repo = _FakeEducationRepository();
      final usecase = AddEducation(educationRepository: repo);

      const education = Education(
        title: '',
        description: 'Test Description',
        type: EducationType.college,
      );

      expect(
        () => usecase(education),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Title cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when description is empty', () async {
      final repo = _FakeEducationRepository();
      final usecase = AddEducation(educationRepository: repo);

      const education = Education(
        title: 'Computer Science',
        description: '',
        type: EducationType.college,
      );

      expect(
        () => usecase(education),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Description cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when link is invalid URL', () async {
      final repo = _FakeEducationRepository();
      final usecase = AddEducation(educationRepository: repo);

      const education = Education(
        title: 'Computer Science',
        description: 'University Degree',
        type: EducationType.college,
        link: 'invalid-url',
      );

      expect(
        () => usecase(education),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Link must be a valid URL'),
          ),
        ),
      );
    });

    test('throws ArgumentError when image URL is invalid', () async {
      final repo = _FakeEducationRepository();
      final usecase = AddEducation(educationRepository: repo);

      const education = Education(
        title: 'Computer Science',
        description: 'University Degree',
        type: EducationType.college,
        imageUrl: 'not-a-valid-url',
      );

      expect(
        () => usecase(education),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Image URL must be a valid URL'),
          ),
        ),
      );
    });

    test('allows null optional fields', () async {
      final repo = _FakeEducationRepository();
      final usecase = AddEducation(educationRepository: repo);

      const education = Education(
        title: 'Computer Science',
        description: 'University Degree',
        type: EducationType.college,
        text: null,
        link: null,
        imageUrl: null,
      );

      await usecase(education);

      expect(repo.addedEducation, education);
    });

    test('allows valid optional link and image URL', () async {
      final repo = _FakeEducationRepository();
      final usecase = AddEducation(educationRepository: repo);

      const education = Education(
        title: 'Computer Science',
        description: 'University Degree',
        type: EducationType.college,
        link: 'https://university.edu/cs',
        imageUrl: 'https://example.com/logo.png',
      );

      await usecase(education);

      expect(repo.addedEducation, education);
    });

    test('trims whitespace from fields before validation', () async {
      final repo = _FakeEducationRepository();
      final usecase = AddEducation(educationRepository: repo);

      const education = Education(
        title: '  ',
        description: 'Test Description',
        type: EducationType.certification,
      );

      expect(
        () => usecase(education),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Title cannot be empty'),
          ),
        ),
      );
    });
  });

  group('AddPosition', () {
    test('successfully adds a position', () async {
      final repo = _FakePositionRepository();
      final usecase = AddPosition(positionRepository: repo);

      const position = Position(
        title: 'Tech Company',
        position: 'Senior Developer',
        description: 'Working on mobile apps',
        icon: 'https://example.com/icon.png',
      );

      await usecase(position);

      expect(repo.addedPosition, position);
    });

    test('throws exception when repository fails', () async {
      final repo = _FakePositionRepository(throwOnAdd: true);
      final usecase = AddPosition(positionRepository: repo);

      const position = Position(
        title: 'Company',
        position: 'Dev',
        description: 'Desc',
        icon: 'https://example.com/icon.png',
      );

      expect(
        () => usecase(position),
        throwsA(
          predicate(
            (e) => e is Exception && e.toString().contains('Failed to add'),
          ),
        ),
      );
    });

    test('throws ArgumentError when title is empty', () async {
      final repo = _FakePositionRepository();
      final usecase = AddPosition(positionRepository: repo);

      const position = Position(
        title: '',
        position: 'Senior Developer',
        description: 'Working on mobile apps',
        icon: 'https://example.com/icon.png',
      );

      expect(
        () => usecase(position),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Title cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when position is empty', () async {
      final repo = _FakePositionRepository();
      final usecase = AddPosition(positionRepository: repo);

      const position = Position(
        title: 'Tech Company',
        position: '',
        description: 'Working on mobile apps',
        icon: 'https://example.com/icon.png',
      );

      expect(
        () => usecase(position),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Position cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when description is empty', () async {
      final repo = _FakePositionRepository();
      final usecase = AddPosition(positionRepository: repo);

      const position = Position(
        title: 'Tech Company',
        position: 'Senior Developer',
        description: '',
        icon: 'https://example.com/icon.png',
      );

      expect(
        () => usecase(position),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Description cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when icon URL is empty', () async {
      final repo = _FakePositionRepository();
      final usecase = AddPosition(positionRepository: repo);

      const position = Position(
        title: 'Tech Company',
        position: 'Senior Developer',
        description: 'Working on mobile apps',
        icon: '',
      );

      expect(
        () => usecase(position),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Icon URL cannot be empty'),
          ),
        ),
      );
    });

    test('throws ArgumentError when icon URL is invalid', () async {
      final repo = _FakePositionRepository();
      final usecase = AddPosition(positionRepository: repo);

      const position = Position(
        title: 'Tech Company',
        position: 'Senior Developer',
        description: 'Working on mobile apps',
        icon: 'not-a-valid-url',
      );

      expect(
        () => usecase(position),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Icon URL must be a valid URL'),
          ),
        ),
      );
    });

    test('trims whitespace from fields before validation', () async {
      final repo = _FakePositionRepository();
      final usecase = AddPosition(positionRepository: repo);

      const position = Position(
        title: '  ',
        position: 'Senior Developer',
        description: 'Working on mobile apps',
        icon: 'https://example.com/icon.png',
      );

      expect(
        () => usecase(position),
        throwsA(
          predicate(
            (e) =>
                e is ArgumentError &&
                e.toString().contains('Title cannot be empty'),
          ),
        ),
      );
    });
  });
}

// Fake repositories for testing

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    this.authenticateResult = true,
    this.isAuthenticatedResult = true,
    this.throwOnAuthenticate = false,
    this.throwOnIsAuthenticated = false,
  });

  final bool authenticateResult;
  final bool isAuthenticatedResult;
  final bool throwOnAuthenticate;
  final bool throwOnIsAuthenticated;

  String? lastEmail;
  String? lastPassword;

  @override
  Future<bool> authenticate(String email, String password) async {
    if (throwOnAuthenticate) {
      throw Exception('Auth error');
    }
    lastEmail = email;
    lastPassword = password;
    return authenticateResult;
  }

  @override
  Future<bool> isAuthenticated() async {
    if (throwOnIsAuthenticated) {
      throw Exception('Check auth error');
    }
    return isAuthenticatedResult;
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<String?> getCurrentUserEmail() async => 'test@example.com';
}

class _FakeBlogRepository implements BlogRepository {
  _FakeBlogRepository({this.throwOnAdd = false});

  final bool throwOnAdd;
  Post? addedPost;

  @override
  Future<void> addPost(Post post) async {
    if (throwOnAdd) {
      throw Exception('Add post failed');
    }
    addedPost = post;
  }

  @override
  Future<List<Post>> refreshPosts() async => [];

  @override
  Stream<List<Post>> get postsUpdateStream => Stream.value([]);
}

class _FakeProjectRepository implements ProjectRepository {
  _FakeProjectRepository({this.throwOnAdd = false});

  final bool throwOnAdd;
  Project? addedProject;

  @override
  Future<void> addProject(Project project) async {
    if (throwOnAdd) {
      throw Exception('Add project failed');
    }
    addedProject = project;
  }

  @override
  Future<List<Project>> refreshProjects() async => [];

  @override
  Stream<List<Project>> get projectsUpdateStream => Stream.value([]);
}

class _FakeSkillRepository implements SkillRepository {
  _FakeSkillRepository({this.throwOnAdd = false});

  final bool throwOnAdd;
  Skill? addedSkill;

  @override
  Future<void> addSkill(Skill skill) async {
    if (throwOnAdd) {
      throw Exception('Add skill failed');
    }
    addedSkill = skill;
  }

  @override
  Future<List<Skill>> refreshSkills() async => [];

  @override
  Stream<List<Skill>> get skillsUpdateStream => Stream.value([]);
}

class _FakeEducationRepository implements EducationRepository {
  _FakeEducationRepository({this.throwOnAdd = false});

  final bool throwOnAdd;
  Education? addedEducation;

  @override
  Future<void> addEducation(Education education) async {
    if (throwOnAdd) {
      throw Exception('Add education failed');
    }
    addedEducation = education;
  }

  @override
  Future<List<Education>> refreshEducation() async => [];

  @override
  Stream<List<Education>> get educationUpdateStream => Stream.value([]);
}

class _FakePositionRepository implements PositionRepository {
  _FakePositionRepository({this.throwOnAdd = false});

  final bool throwOnAdd;
  Position? addedPosition;

  @override
  Future<void> addPosition(Position position) async {
    if (throwOnAdd) {
      throw Exception('Add position failed');
    }
    addedPosition = position;
  }

  @override
  Future<List<Position>> refreshPositions() async => [];

  @override
  Stream<List<Position>> get positionsUpdateStream => Stream.value([]);
}
