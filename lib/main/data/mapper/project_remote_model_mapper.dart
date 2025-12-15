import 'package:portfolio/main/data/remote/model/project_remote_model.dart';
import 'package:portfolio/main/domain/model/project.dart';

const _defaultProjectImage = 'assets/img/default.png';

ProjectRemoteModel projectRemoteModelFromJson(Map<String, dynamic> json) {
  final image = (json['image']?.toString() ?? _defaultProjectImage).trim();
  return ProjectRemoteModel(
    image: image.isEmpty ? _defaultProjectImage : image,
    title: json['title']?.toString() ?? '',
    role: json['role']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    link: json['link']?.toString(),
  );
}

Map<String, dynamic> projectRemoteModelToJson(ProjectRemoteModel model) {
  return {
    'image': model.image,
    'title': model.title,
    'role': model.role,
    'description': model.description,
    'link': model.link,
  };
}

extension ProjectRemoteModelJson on ProjectRemoteModel {
  Map<String, dynamic> toJson() => projectRemoteModelToJson(this);

  Project toDomain() {
    return Project(
      image: image,
      title: title,
      role: role,
      description: description,
      link: link,
    );
  }
}

ProjectRemoteModel projectRemoteModelFromDomain(Project project) {
  return ProjectRemoteModel(
    image: project.image,
    title: project.title,
    role: project.role,
    description: project.description,
    link: project.link,
  );
}
