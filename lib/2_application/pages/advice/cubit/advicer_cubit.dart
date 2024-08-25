import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:advicer/1_domain/usecases/advice_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advicer_state.dart';

const generalFailureMessage = "Ups, somethinh gone wrong. Please try again!";
const serverFailureMessage = "Ups, API Error. please try again!";
const cacheFailureMessage = "Ups, cache failed. Please try again!";

class AdvicerCubit extends Cubit<AdvicerCubitState> {
  AdvicerCubit() : super(AdvicerInitial());

  final AdviceUseCases adviceUseCases = AdviceUseCases();

  //could also use other usecases

  void adviceRequest() async {
    emit(AdvicerStateLoading());
    final failureOrAdvice = await adviceUseCases.getAdvice();
    failureOrAdvice.fold(
        (failure) => emit(AdvicerStateError(message: _mapFailureToMessage(failure))),
        (advice) => emit(AdvicerStateLoaded(advice: advice.advice))
    );
  }
}

String _mapFailureToMessage(Failure failure){
  switch(failure.runtimeType){
    case ServerFailure:
      return serverFailureMessage;
    case CacheFailure:
      return cacheFailureMessage;
    default:
      return generalFailureMessage;
  }
}