import 'package:portfolio/main/data/remote/model/social_info_remote_model.dart';

class PersonalInfoRemoteModel {
  const PersonalInfoRemoteModel({
    required this.image,
    required this.title,
    required this.description,
    required this.email,
    required this.socials,
  });

  final String image;
  final String title;
  final String description;
  final String email;
  final List<SocialInfoRemoteModel> socials;
}
