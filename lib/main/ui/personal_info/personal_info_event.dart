import 'package:equatable/equatable.dart';

/// Base class for personal info events
/// Using sealed class pattern for exhaustive event handling
sealed class PersonalInfoEvent extends Equatable {
  const PersonalInfoEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load positions
class GetPositions extends PersonalInfoEvent {
  const GetPositions();
}
