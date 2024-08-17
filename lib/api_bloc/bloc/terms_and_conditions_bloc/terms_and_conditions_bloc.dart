import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/termsandconditionsmodel.dart';
import '../../repository/TermsAndConditionsRepository.dart';


part 'terms_and_conditions_event.dart';
part 'terms_and_conditions_state.dart';

class TermsAndConditionsBloc extends Bloc<TermsAndConditionsEvent, TermsAndConditionsState> {
  TermsAndConditionsBloc() : super(TermsAndConditionsInitial()) {
    final TermsAndConditionsRepository _apiRepository = TermsAndConditionsRepository();

    on<TermsAndConditionsData>((event, emit) async {
      try {
        emit(TermsAndConditionsLoading());
        final mList = await _apiRepository.termsAndConditionData();
        emit(TermsAndConditionsLoaded(mList));
        if (mList.error != null) {
          emit(TermsAndConditionsError(mList.error));
        }
      } on NetworkError {
        emit(TermsAndConditionsError(
            "Failed to fetch data. is your device online?"));
      }       });
  }
}
