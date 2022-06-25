import 'package:bloc/bloc.dart';

import '../../services/feedback_service/feedback_service.dart';
import './feedback_event.dart';
import './feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackService service;

  FeedbackBloc({required this.service}) : super(FeedbackInitial()) {
    on<FeedbackSent>((event, emit) async {
      emit(FeedbackSendInProgress());
      try {
        await service.sendFeedback(event.email, event.feedback);
        // if (Feedbacks != null) {
        //   Feedbacks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        // }
        emit(FeedbackSendSuccess());
      } catch (e) {
        emit(FeedbackSendFailure(errorMessage: e.toString()));
      }
    });
  }
}
