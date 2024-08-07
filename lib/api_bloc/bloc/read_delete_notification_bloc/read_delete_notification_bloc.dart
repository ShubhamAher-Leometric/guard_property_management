import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../model/readnotificationmodel.dart';
import '../../repository/ReadDeleteNotificationRepository.dart';

part 'read_delete_notification_event.dart';
part 'read_delete_notification_state.dart';

class ReadDeleteNotificationBloc extends Bloc<ReadDeleteNotificationEvent, ReadDeleteNotificationState> {
  ReadDeleteNotificationBloc() : super(ReadDeleteNotificationInitial()) {
    final ReadDeleteNotificationRepository _apiRepository = ReadDeleteNotificationRepository();

    on<SubmitReadDeleteNotificationData>((event, emit) async {
      try {
        emit(ReadDeleteNotificationLoading());
        final userData = await _apiRepository.sendreadNotification(event.ReadDeleteData);
        emit(ReadDeleteNotificationLoaded(userData));
        if (userData.error != null) {
          print(userData.error);
          emit(ReadDeleteNotificationError(userData.error));
        }
      } on NetworkError {
        emit(ReadDeleteNotificationError("Failed to fetch data. is your device online?"));
      }      });
  }
}
