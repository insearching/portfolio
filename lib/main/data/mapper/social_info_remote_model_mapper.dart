import 'package:portfolio/main/data/remote/model/social_info_remote_model.dart';
import 'package:portfolio/main/domain/model/social_info.dart';

/// ---------- Domain JSON mapping ----------

SocialInfo socialInfoFromJsonMap(Map<String, dynamic> json) {
  final url = json['url']?.toString() ?? '';

  for (final social in SocialInfo.values) {
    if (social.url == url) return social;
  }

  final normalized = url.toLowerCase();
  if (normalized.contains('linkedin')) return SocialInfo.linkedin;
  if (normalized.contains('github')) return SocialInfo.github;
  if (normalized.contains('medium')) return SocialInfo.medium;

  return SocialInfo.linkedin;
}

Map<String, dynamic> socialInfoToJsonMap(SocialInfo social) {
  return {
    'url': social.url,
    'icon': social.icon,
  };
}

/// ---------- Remote DTO JSON mapping + conversions ----------

SocialInfoRemoteModel socialInfoRemoteModelFromJson(Map<String, dynamic> json) {
  return SocialInfoRemoteModel(
    url: json['url']?.toString() ?? '',
    icon: json['icon']?.toString() ?? '',
  );
}

Map<String, dynamic> socialInfoRemoteModelToJson(SocialInfoRemoteModel model) {
  return {
    'url': model.url,
    'icon': model.icon,
  };
}

extension SocialInfoRemoteModelJson on SocialInfoRemoteModel {
  Map<String, dynamic> toJson() => socialInfoRemoteModelToJson(this);

  SocialInfo toDomain() {
    return socialInfoFromJsonMap({'url': url, 'icon': icon});
  }
}

SocialInfoRemoteModel socialInfoRemoteModelFromDomain(SocialInfo social) {
  return SocialInfoRemoteModel(
    url: social.url,
    icon: social.icon,
  );
}
