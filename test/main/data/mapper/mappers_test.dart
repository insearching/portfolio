import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main/data/mapper/education_remote_model_mapper.dart';
import 'package:portfolio/main/data/mapper/personal_info_remote_model_mapper.dart';
import 'package:portfolio/main/data/mapper/position_remote_model_mapper.dart';
import 'package:portfolio/main/data/mapper/post_remote_model_mapper.dart';
import 'package:portfolio/main/data/mapper/project_remote_model_mapper.dart';
import 'package:portfolio/main/data/mapper/skill_remote_model_mapper.dart';
import 'package:portfolio/main/data/mapper/social_info_remote_model_mapper.dart';
import 'package:portfolio/main/data/remote/model/education_remote_model.dart';
import 'package:portfolio/main/data/remote/model/position_remote_model.dart';
import 'package:portfolio/main/data/remote/model/post_remote_model.dart';
import 'package:portfolio/main/data/remote/model/project_remote_model.dart';
import 'package:portfolio/main/data/remote/model/skill_remote_model.dart';
import 'package:portfolio/main/data/remote/model/social_info_remote_model.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/domain/model/social_info.dart';

void main() {
  group('Data mappers', () {
    test('postRemoteModelFromJson defaults to empty strings', () {
      final model = postRemoteModelFromJson({});
      expect(model.title, '');
      expect(model.description, '');
      expect(model.imageLink, '');
      expect(model.link, '');
    });

    test('PostRemoteModelJson.toDomain maps correctly', () {
      const model = PostRemoteModel(
        title: 't',
        description: 'd',
        imageLink: 'i',
        link: 'l',
      );

      final domain = model.toDomain();
      expect(domain.title, 't');
      expect(domain.description, 'd');
      expect(domain.imageLink, 'i');
      expect(domain.link, 'l');
    });

    test('positionRemoteModelFromJson uses default icon when blank', () {
      final model = positionRemoteModelFromJson({'icon': '   '});
      expect(model.icon, 'assets/img/android.png');
    });

    test('projectRemoteModelFromJson uses default image when blank', () {
      final model = projectRemoteModelFromJson({'image': '  '});
      expect(model.image, 'assets/img/default.png');
    });

    test('skillRemoteModelFromJson parses value num -> int and type', () {
      final model = skillRemoteModelFromJson(
          {'title': 't', 'value': 3.14, 'type': 'SOFT'});
      expect(model.value, 3);

      final domain = model.toDomain();
      expect(domain.type, SkillType.soft);
    });

    test('educationRemoteModelFromJson maps type string to enum', () {
      final model = educationRemoteModelFromJson({'type': 'college'});
      final domain = model.toDomain();
      expect(domain.type, EducationType.college);
    });

    test('socialInfoFromJsonMap matches exact url and heuristics', () {
      expect(
        socialInfoFromJsonMap({'url': SocialInfo.github.url}),
        SocialInfo.github,
      );

      expect(
        socialInfoFromJsonMap({'url': 'https://github.com/something'}),
        SocialInfo.github,
      );

      expect(
        socialInfoFromJsonMap({'url': 'unknown'}),
        SocialInfo.linkedin,
      );
    });

    test('personalInfoRemoteModelFromJson handles socials as map values', () {
      final model = personalInfoRemoteModelFromJson(
        {
          'image': 'img',
          'title': 't',
          'description': 'd',
          'email': 'e',
          'socials': {
            'a': {'url': SocialInfo.medium.url, 'icon': SocialInfo.medium.icon},
          },
        },
      );

      expect(model.socials.length, 1);
      expect(model.toDomain().socials, [SocialInfo.medium]);

      final backToJson = model.toJson();
      expect(backToJson['socials'], isA<List>());
    });

    test('Domain <-> DTO round-trip for PersonalInfo', () {
      const domain = PersonalInfo(
        image: 'i',
        title: 't',
        description: 'd',
        email: 'e',
        socials: [SocialInfo.github],
      );

      final dto = personalInfoRemoteModelFromDomain(domain);
      final rebuilt = dto.toDomain();

      expect(rebuilt.email, 'e');
      expect(rebuilt.socials, [SocialInfo.github]);
    });

    test('Explicit toJson mappers create stable maps', () {
      const post = PostRemoteModel(
          title: 't', description: 'd', imageLink: 'i', link: 'l');
      expect(postRemoteModelToJson(post)['title'], 't');

      const position = PositionRemoteModel(
          title: 't', position: 'p', description: 'd', icon: 'i');
      expect(positionRemoteModelToJson(position)['icon'], 'i');

      const project = ProjectRemoteModel(
          image: 'i', title: 't', role: 'r', description: 'd', link: null);
      expect(projectRemoteModelToJson(project)['image'], 'i');

      const skill = SkillRemoteModel(title: 't', value: 1, type: 'hard');
      expect(skillRemoteModelToJson(skill)['value'], 1);

      const edu = EducationRemoteModel(
          title: 't',
          description: 'd',
          type: 'college',
          text: null,
          link: null,
          imageUrl: null);
      expect(educationRemoteModelToJson(edu)['type'], 'college');

      const social = SocialInfoRemoteModel(url: 'u', icon: 'i');
      expect(socialInfoRemoteModelToJson(social)['url'], 'u');
    });
  });
}
