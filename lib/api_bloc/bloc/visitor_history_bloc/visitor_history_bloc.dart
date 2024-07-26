import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:guard_property_management/api_bloc/repository/VisitorHistoryRepository.dart';

import '../../../model/visitor_history_model.dart';

part 'visitor_history_event.dart';
part 'visitor_history_state.dart';

class VisitorHistoryBloc extends Bloc<VisitorHistoryEvent, VisitorHistoryState> {
  VisitorHistoryBloc() : super(VisitorHistoryInitial()) {
    final VisitorHistoryRepository _apiRepository = VisitorHistoryRepository();

    on<VisitorHistoryEvent>((event, emit) async {
      try {
        emit(VisitorHistoryLoading());
        final mList = await _apiRepository.visitorListingData();
        emit(VisitorHistoryLoaded(mList));
        if (mList.error != null) {
          emit(VisitorHistoryError(mList.error));
        }
      } on NetworkError {
        emit(VisitorHistoryError(
            "Failed to fetch data. is your device online?"));
      }    });
  }
}
