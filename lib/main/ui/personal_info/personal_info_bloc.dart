import 'package:bloc/bloc.dart';
import 'package:portfolio/core/logger/app_logger.dart';
import 'package:portfolio/main/domain/repositories/position_repository.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_event.dart';
import 'package:portfolio/main/ui/personal_info/personal_info_state.dart';

class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  PersonalInfoBloc({
    required this.positionRepo,
    required this.logger,
  }) : super(const PersonalInfoState()) {
    on<GetPositions>(_mapGetPositionsEventToState);
  }

  final PositionRepository positionRepo;
  final AppLogger logger;

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
      logger.error(
          'Error fetching positions', error, stacktrace, 'PersonalInfoBloc');
      emit(state.copyWith(status: PersonalInfoStatus.error));
    }
  }
}
