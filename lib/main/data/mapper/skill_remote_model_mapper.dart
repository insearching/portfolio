import 'package:portfolio/main/data/remote/model/skill_remote_model.dart';
import 'package:portfolio/main/domain/model/skill.dart';

SkillRemoteModel skillRemoteModelFromJson(Map<String, dynamic> json) {
  return SkillRemoteModel(
    title: json['title']?.toString() ?? '',
    value: (json['value'] as num?)?.toInt() ?? 0,
    type: (json['type']?.toString() ?? 'hard').toLowerCase(),
  );
}

Map<String, dynamic> skillRemoteModelToJson(SkillRemoteModel model) {
  return {
    'title': model.title,
    'value': model.value,
    'type': model.type,
  };
}

SkillType _skillTypeFromString(String type) {
  return type.toLowerCase() == 'soft' ? SkillType.soft : SkillType.hard;
}

extension SkillRemoteModelJson on SkillRemoteModel {
  Map<String, dynamic> toJson() => skillRemoteModelToJson(this);

  Skill toDomain() {
    return Skill(
      title: title,
      value: value,
      type: _skillTypeFromString(type),
    );
  }
}

SkillRemoteModel skillRemoteModelFromDomain(Skill skill) {
  return SkillRemoteModel(
    title: skill.title,
    value: skill.value,
    type: skill.type.name,
  );
}
