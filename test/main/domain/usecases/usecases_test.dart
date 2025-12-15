import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/model/position.dart';
import 'package:portfolio/main/domain/model/post.dart';
import 'package:portfolio/main/domain/model/project.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/model/social_info.dart';
import 'package:portfolio/main/domain/repositories/blog_repository.dart';
import 'package:portfolio/main/domain/repositories/education_repository.dart';
import 'package:portfolio/main/domain/repositories/personal_info_repository.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/domain/repositories/project_repository.dart';
import 'package:portfolio/main/domain/repositories/skill_repository.dart';
import 'package:portfolio/main/domain/usecases/get_education_stream.dart';
import 'package:portfolio/main/domain/usecases/get_personal_info_stream.dart';
import 'package:portfolio/main/domain/usecases/get_positions_stream.dart';
import 'package:portfolio/main/domain/usecases/get_posts_stream.dart';
import 'package:portfolio/main/domain/usecases/get_projects_stream.dart';
import 'package:portfolio/main/domain/usecases/get_skills_stream.dart';
import 'package:portfolio/main/domain/usecases/refresh_all.dart';

void main() {
  group('GetEducationStream', () {
    test('delegates to EducationRepository.educationUpdateStream', () {
      final stream = Stream<List<Education>>.value([
        const Education(
          title: 'T',
          description: 'D',
          type: EducationType.certification,
        )
      ]);
      final repo = _FakeEducationRepository(stream: stream);

      final usecase = GetEducationStream(educationRepository: repo);

      expect(usecase(), same(stream));
    });

    test('wraps stream getter errors with a descriptive exception', () {
      final repo = _FakeEducationRepository(throwOnStreamGet: true);
      final usecase = GetEducationStream(educationRepository: repo);

      expect(
        () => usecase(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Failed to load education stream'),
          ),
        ),
      );
    });
  });

  group('GetProjectsStream', () {
    test('delegates to ProjectRepository.projectsUpdateStream', () {
      final stream = Stream<List<Project>>.value([
        const Project(
          image: 'I',
          title: 'P',
          role: 'R',
          description: 'D',
          link: 'L',
        )
      ]);
      final repo = _FakeProjectRepository(stream: stream);

      final usecase = GetProjectsStream(projectRepository: repo);

      expect(usecase(), same(stream));
    });

    test('wraps stream getter errors with a descriptive exception', () {
      final repo = _FakeProjectRepository(throwOnStreamGet: true);
      final usecase = GetProjectsStream(projectRepository: repo);

      expect(
        () => usecase(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Failed to load projects stream'),
          ),
        ),
      );
    });
  });

  group('GetPostsStream', () {
    test('delegates to BlogRepository.postsUpdateStream', () {
      final stream = Stream<List<Post>>.value([
        const Post(
          title: 'P',
          description: 'D',
          imageLink: 'I',
          link: 'L',
        )
      ]);
      final repo = _FakeBlogRepository(stream: stream);

      final usecase = GetPostsStream(blogRepository: repo);

      expect(usecase(), same(stream));
    });

    test('wraps stream getter errors with a descriptive exception', () {
      final repo = _FakeBlogRepository(throwOnStreamGet: true);
      final usecase = GetPostsStream(blogRepository: repo);

      expect(
        () => usecase(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Failed to load posts stream'),
          ),
        ),
      );
    });
  });

  group('GetSkillsStream', () {
    test('delegates to SkillRepository.skillsUpdateStream', () {
      final stream = Stream<List<Skill>>.value([
        const Skill(
          title: 'Dart',
          value: 90,
          type: SkillType.hard,
        )
      ]);
      final repo = _FakeSkillRepository(stream: stream);

      final usecase = GetSkillsStream(skillRepository: repo);

      expect(usecase(), same(stream));
    });

    test('wraps stream getter errors with a descriptive exception', () {
      final repo = _FakeSkillRepository(throwOnStreamGet: true);
      final usecase = GetSkillsStream(skillRepository: repo);

      expect(
        () => usecase(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Failed to load skills stream'),
          ),
        ),
      );
    });
  });

  group('GetPersonalInfoStream', () {
    test('delegates to PersonalInfoRepository.personalInfoUpdateStream', () {
      final stream = Stream<PersonalInfo?>.value(const PersonalInfo(
        image: 'I',
        title: 'T',
        description: 'D',
        email: 'e@example.com',
        socials: [SocialInfo.github, SocialInfo.linkedin],
      ));
      final repo = _FakePersonalInfoRepository(stream: stream);

      final usecase = GetPersonalInfoStream(personalInfoRepository: repo);

      expect(usecase(), same(stream));
    });
  });

  group('GetPositionsStream', () {
    test('delegates to PositionRepository.positionsUpdateStream', () {
      final stream = Stream<List<Position>>.value([
        const Position(
          title: 'Company',
          position: 'Android',
          description: 'D',
          icon: 'I',
        )
      ]);
      final repo = _FakePositionRepository(stream: stream);

      final usecase = GetPositionsStream(positionRepository: repo);

      expect(usecase(), same(stream));
    });

    test('wraps stream getter errors with a descriptive exception', () {
      final repo = _FakePositionRepository(throwOnStreamGet: true);
      final usecase = GetPositionsStream(positionRepository: repo);

      expect(
        () => usecase(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Failed to load positions stream'),
          ),
        ),
      );
    });
  });

  group('RefreshAll', () {
    test('refreshes all repositories in parallel', () async {
      final blogRepo = _FakeBlogRepository();
      final positionRepo = _FakePositionRepository();
      final projectRepo = _FakeProjectRepository();
      final educationRepo = _FakeEducationRepository();
      final skillRepo = _FakeSkillRepository();
      final personalInfoRepo = _FakePersonalInfoRepository();

      final usecase = RefreshAll(
        blogRepository: blogRepo,
        positionRepository: positionRepo,
        projectRepository: projectRepo,
        educationRepository: educationRepo,
        skillRepository: skillRepo,
        personalInfoRepository: personalInfoRepo,
      );

      await usecase();

      expect(blogRepo.refreshCalled, 1);
      expect(positionRepo.refreshCalled, 1);
      expect(projectRepo.refreshCalled, 1);
      expect(educationRepo.refreshCalled, 1);
      expect(skillRepo.refreshCalled, 1);
      expect(personalInfoRepo.refreshCalled, 1);
    });

    test('wraps refresh errors with a descriptive exception', () async {
      final blogRepo = _FakeBlogRepository();
      final positionRepo = _FakePositionRepository();
      final projectRepo = _FakeProjectRepository();
      final educationRepo = _FakeEducationRepository();
      final skillRepo = _FakeSkillRepository(throwOnRefresh: true);
      final personalInfoRepo = _FakePersonalInfoRepository();

      final usecase = RefreshAll(
        blogRepository: blogRepo,
        positionRepository: positionRepo,
        projectRepository: projectRepo,
        educationRepository: educationRepo,
        skillRepository: skillRepo,
        personalInfoRepository: personalInfoRepo,
      );

      expect(
        () => usecase(),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Failed to refresh repositories'),
          ),
        ),
      );
    });
  });
}

class _FakeEducationRepository implements EducationRepository {
  _FakeEducationRepository({
    Stream<List<Education>>? stream,
    this.throwOnStreamGet = false,
    this.throwOnRefresh = false,
  }) : _stream = stream ?? const Stream<List<Education>>.empty();

  final Stream<List<Education>> _stream;
  final bool throwOnStreamGet;
  final bool throwOnRefresh;

  int refreshCalled = 0;

  @override
  Stream<List<Education>> get educationUpdateStream {
    if (throwOnStreamGet) throw StateError('education stream boom');
    return _stream;
  }

  @override
  Future<List<Education>> refreshEducation() async {
    refreshCalled++;
    if (throwOnRefresh) throw StateError('education refresh boom');
    return const <Education>[];
  }

  @override
  Future<void> addEducation(Education education) async {}
}

class _FakeProjectRepository implements ProjectRepository {
  _FakeProjectRepository({
    Stream<List<Project>>? stream,
    this.throwOnStreamGet = false,
    this.throwOnRefresh = false,
  }) : _stream = stream ?? const Stream<List<Project>>.empty();

  final Stream<List<Project>> _stream;
  final bool throwOnStreamGet;
  final bool throwOnRefresh;

  int refreshCalled = 0;

  @override
  Stream<List<Project>> get projectsUpdateStream {
    if (throwOnStreamGet) throw StateError('projects stream boom');
    return _stream;
  }

  @override
  Future<List<Project>> refreshProjects() async {
    refreshCalled++;
    if (throwOnRefresh) throw StateError('projects refresh boom');
    return const <Project>[];
  }

  @override
  Future<void> addProject(Project project) async {}
}

class _FakeBlogRepository implements BlogRepository {
  _FakeBlogRepository({
    Stream<List<Post>>? stream,
    this.throwOnStreamGet = false,
    this.throwOnRefresh = false,
  }) : _stream = stream ?? const Stream<List<Post>>.empty();

  final Stream<List<Post>> _stream;
  final bool throwOnStreamGet;
  final bool throwOnRefresh;

  int refreshCalled = 0;

  @override
  Stream<List<Post>> get postsUpdateStream {
    if (throwOnStreamGet) throw StateError('posts stream boom');
    return _stream;
  }

  @override
  Future<List<Post>> refreshPosts() async {
    refreshCalled++;
    if (throwOnRefresh) throw StateError('posts refresh boom');
    return const <Post>[];
  }

  @override
  Future<void> addPost(Post post) async {}
}

class _FakeSkillRepository implements SkillRepository {
  _FakeSkillRepository({
    Stream<List<Skill>>? stream,
    this.throwOnStreamGet = false,
    this.throwOnRefresh = false,
  }) : _stream = stream ?? const Stream<List<Skill>>.empty();

  final Stream<List<Skill>> _stream;
  final bool throwOnStreamGet;
  final bool throwOnRefresh;

  int refreshCalled = 0;

  @override
  Stream<List<Skill>> get skillsUpdateStream {
    if (throwOnStreamGet) throw StateError('skills stream boom');
    return _stream;
  }

  @override
  Future<List<Skill>> refreshSkills() async {
    refreshCalled++;
    if (throwOnRefresh) throw StateError('skills refresh boom');
    return const <Skill>[];
  }

  @override
  Future<void> addSkill(Skill skill) async {}
}

class _FakePersonalInfoRepository implements PersonalInfoRepository {
  _FakePersonalInfoRepository({
    Stream<PersonalInfo?>? stream,
    this.throwOnRefresh = false,
  }) : _stream = stream ?? const Stream<PersonalInfo?>.empty();

  final Stream<PersonalInfo?> _stream;
  final bool throwOnRefresh;

  int refreshCalled = 0;

  @override
  Stream<PersonalInfo?> get personalInfoUpdateStream => _stream;

  @override
  Future<PersonalInfo?> refreshPersonalInfo() async {
    refreshCalled++;
    if (throwOnRefresh) throw StateError('personal info refresh boom');
    return null;
  }
}

class _FakePositionRepository implements PositionRepository {
  _FakePositionRepository({
    Stream<List<Position>>? stream,
    this.throwOnStreamGet = false,
    this.throwOnRefresh = false,
  }) : _stream = stream ?? const Stream<List<Position>>.empty();

  final Stream<List<Position>> _stream;
  final bool throwOnStreamGet;
  final bool throwOnRefresh;

  int refreshCalled = 0;

  @override
  Stream<List<Position>> get positionsUpdateStream {
    if (throwOnStreamGet) throw StateError('positions stream boom');
    return _stream;
  }

  @override
  Future<List<Position>> refreshPositions() async {
    refreshCalled++;
    if (throwOnRefresh) throw StateError('positions refresh boom');
    return const <Position>[];
  }

  @override
  Future<void> addPosition(Position position) async {}
}
