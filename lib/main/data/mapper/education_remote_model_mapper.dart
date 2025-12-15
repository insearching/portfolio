import 'package:portfolio/main/data/remote/model/education_remote_model.dart';
import 'package:portfolio/main/domain/model/education.dart';

EducationRemoteModel educationRemoteModelFromJson(Map<String, dynamic> json) {
  return EducationRemoteModel(
    title: json['title']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    type: (json['type']?.toString() ?? 'certification').toLowerCase(),
    text: json['text']?.toString(),
    link: json['link']?.toString(),
    imageUrl: json['imageUrl']?.toString(),
  );
}

Map<String, dynamic> educationRemoteModelToJson(EducationRemoteModel model) {
  return {
    'title': model.title,
    'description': model.description,
    'type': model.type,
    'text': model.text,
    'link': model.link,
    'imageUrl': model.imageUrl,
  };
}

EducationType _educationTypeFromString(String type) {
  final normalized = type.toLowerCase();
  if (normalized == 'college') return EducationType.college;
  return EducationType.certification;
}

extension EducationRemoteModelJson on EducationRemoteModel {
  Map<String, dynamic> toJson() => educationRemoteModelToJson(this);

  Education toDomain() {
    return Education(
      title: title,
      description: description,
      type: _educationTypeFromString(type),
      text: text,
      link: link,
      imageUrl: imageUrl,
    );
  }
}

EducationRemoteModel educationRemoteModelFromDomain(Education education) {
  return EducationRemoteModel(
    title: education.title,
    description: education.description,
    type: education.type.name,
    text: education.text,
    link: education.link,
    imageUrl: education.imageUrl,
  );
}
