import 'package:portfolio/main/data/remote/model/position_remote_model.dart';
import 'package:portfolio/main/domain/model/position.dart';

const _defaultPositionIcon = 'assets/img/android.png';

PositionRemoteModel positionRemoteModelFromJson(Map<String, dynamic> json) {
  final icon = (json['icon']?.toString() ?? _defaultPositionIcon).trim();
  return PositionRemoteModel(
    title: json['title']?.toString() ?? '',
    position: json['position']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    icon: icon.isEmpty ? _defaultPositionIcon : icon,
  );
}

Map<String, dynamic> positionRemoteModelToJson(PositionRemoteModel model) {
  return {
    'title': model.title,
    'position': model.position,
    'description': model.description,
    'icon': model.icon,
  };
}

extension PositionRemoteModelJson on PositionRemoteModel {
  Map<String, dynamic> toJson() => positionRemoteModelToJson(this);

  Position toDomain() {
    return Position(
      title: title,
      position: position,
      description: description,
      icon: icon,
    );
  }
}

PositionRemoteModel positionRemoteModelFromDomain(Position position) {
  return PositionRemoteModel(
    title: position.title,
    position: position.position,
    description: position.description,
    icon: position.icon,
  );
}
