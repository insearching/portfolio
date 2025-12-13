import 'package:bloc/bloc.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_event.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_state.dart';

class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  PersonalInfoBloc({
    required this.positionRepo,
  }) : super(const PersonalInfoState()) {
    on<GetPositions>(_mapGetPositionsEventToState);
  }

  final PositionRepository positionRepo;

  void _mapGetPositionsEventToState(
      GetPositions event, Emitter<PersonalInfoState> emit) async {
    if (state.status.isSuccess) {
      emit(state);
      return;
    }
    emit(state.copyWith(status: PersonalInfoStatus.loading));
    try {
      final positions = await positionRepo.positionsUpdateStream.last;
      emit(
        state.copyWith(
          status: PersonalInfoStatus.success,
          positions: positions,
        ),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: PersonalInfoStatus.error));
    }
  }
}
