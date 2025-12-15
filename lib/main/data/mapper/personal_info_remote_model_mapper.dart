import 'package:portfolio/main/data/mapper/social_info_remote_model_mapper.dart';
import 'package:portfolio/main/data/remote/model/personal_info_remote_model.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';

PersonalInfoRemoteModel personalInfoRemoteModelFromJson(
  Map<String, dynamic> json,
) {
  final rawSocials = json['socials'];

  Iterable<dynamic> socialsIterable;
  if (rawSocials is List) {
    socialsIterable = rawSocials;
  } else if (rawSocials is Map) {
    socialsIterable = rawSocials.values;
  } else {
    socialsIterable = const [];
  }

  final socials = socialsIterable
      .whereType<Map>()
      .map((s) => socialInfoRemoteModelFromJson(Map<String, dynamic>.from(s)))
      .toList();

  return PersonalInfoRemoteModel(
    image: json['image'] as String? ?? '',
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    email: json['email'] as String? ?? '',
    socials: socials,
  );
}

Map<String, dynamic> personalInfoRemoteModelToJson(
    PersonalInfoRemoteModel model) {
  return {
    'image': model.image,
    'title': model.title,
    'description': model.description,
    'email': model.email,
    'socials': model.socials.map((s) => s.toJson()).toList(),
  };
}

extension PersonalInfoRemoteModelJson on PersonalInfoRemoteModel {
  Map<String, dynamic> toJson() => personalInfoRemoteModelToJson(this);

  PersonalInfo toDomain() {
    return PersonalInfo(
      image: image,
      title: title,
      description: description,
      email: email,
      socials: socials.map((s) => s.toDomain()).toList(),
    );
  }
}

PersonalInfoRemoteModel personalInfoRemoteModelFromDomain(PersonalInfo info) {
  return PersonalInfoRemoteModel(
    image: info.image,
    title: info.title,
    description: info.description,
    email: info.email,
    socials: info.socials.map(socialInfoRemoteModelFromDomain).toList(),
  );
}
