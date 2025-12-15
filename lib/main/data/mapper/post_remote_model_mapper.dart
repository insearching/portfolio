import 'package:portfolio/main/data/remote/model/post_remote_model.dart';
import 'package:portfolio/main/domain/model/post.dart';

PostRemoteModel postRemoteModelFromJson(Map<String, dynamic> json) {
  return PostRemoteModel(
    title: json['title']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    imageLink: json['imageLink']?.toString() ?? '',
    link: json['link']?.toString() ?? '',
  );
}

Map<String, dynamic> postRemoteModelToJson(PostRemoteModel model) {
  return {
    'title': model.title,
    'description': model.description,
    'imageLink': model.imageLink,
    'link': model.link,
  };
}

extension PostRemoteModelJson on PostRemoteModel {
  Map<String, dynamic> toJson() => postRemoteModelToJson(this);

  Post toDomain() {
    return Post(
      title: title,
      description: description,
      imageLink: imageLink,
      link: link,
    );
  }
}

PostRemoteModel postRemoteModelFromDomain(Post post) {
  return PostRemoteModel(
    title: post.title,
    description: post.description,
    imageLink: post.imageLink,
    link: post.link,
  );
}
