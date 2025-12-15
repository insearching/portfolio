import 'package:equatable/equatable.dart';
import 'package:portfolio/main/domain/model/position.dart';

enum PersonalInfoStatus { success, error, loading }

extension PersonalInfoStatusX on PersonalInfoStatus {
  bool get isSuccess => this == PersonalInfoStatus.success;
  bool get isError => this == PersonalInfoStatus.error;
  bool get isLoading => this == PersonalInfoStatus.loading;
}

class PersonalInfoState extends Equatable {
  const PersonalInfoState({
    this.status = PersonalInfoStatus.loading,
    List<Position>? positions,
  }) : positions = positions ?? const [];

  final List<Position> positions;
  final PersonalInfoStatus status;

  @override
  List<Object?> get props => [status, positions];

  PersonalInfoState copyWith({
    List<Position>? positions,
    PersonalInfoStatus? status,
  }) {
    return PersonalInfoState(
      positions: positions ?? this.positions,
      status: status ?? this.status,
    );
  }
}
