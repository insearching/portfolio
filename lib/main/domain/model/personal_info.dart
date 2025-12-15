import 'package:portfolio/main/domain/model/social_info.dart';

class PersonalInfo {
  final String image;
  final String title;
  final String description;
  final String email;
  final List<SocialInfo> socials;

  const PersonalInfo({
    required this.image,
    required this.title,
    required this.description,
    required this.email,
    required this.socials,
  });
}
