import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:advicer/1_domain/usecases/advice_usecases.dart';
import 'package:advicer/2_application/pages/advice/cubit/advicer_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdviceUseCases extends Mock implements AdviceUseCases {}

void main() {
  group('AdvicerCubit', () {
    group('sholud emit', () {
      MockAdviceUseCases mockAdviceUseCases = MockAdviceUseCases();

      blocTest(
        'nothing when no event is added',
        build: () => AdvicerCubit(adviceUseCases: mockAdviceUseCases),
        expect: () => const <AdvicerCubitState>[],
      );

      blocTest(
        '[AdvicerStateLoading, AdvicerStateLoaded] when adviceRequested() is called',
        setUp: () => when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
          (invocation) => Future.value(
            const Right<Failure, AdviceEntity>(
              AdviceEntity(advice: 'advice', id: 1),
            ),
          ),
        ),
        build: () => AdvicerCubit(adviceUseCases: mockAdviceUseCases),
        act: (cubit) => cubit.adviceRequest(),
        expect: () => const <AdvicerCubitState>[
          AdvicerStateLoading(),
          AdvicerStateLoaded(advice: 'advice')
        ],
      );

      blocTest(
        '[AdvicerStateLoading, AdvicerStateError] when adviceRequested() is called',
        setUp: () => when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
            (invocation) =>
                Future.value(Left<Failure, AdviceEntity>(ServerFailure()))),
        build: () => AdvicerCubit(adviceUseCases: mockAdviceUseCases),
        act: (cubit) => cubit.adviceRequest(),
        expect: () => const <AdvicerCubitState>[
          AdvicerStateLoading(),
          AdvicerStateError(message: serverFailureMessage)
        ],
      );

      blocTest(
        '[AdvicerStateLoading, AdvicerStateError] when adviceRequested() is called',
        setUp: () => when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
                (invocation) =>
                Future.value(Left<Failure, AdviceEntity>(CacheFailure()))),
        build: () => AdvicerCubit(adviceUseCases: mockAdviceUseCases),
        act: (cubit) => cubit.adviceRequest(),
        expect: () => const <AdvicerCubitState>[
          AdvicerStateLoading(),
          AdvicerStateError(message: cacheFailureMessage)
        ],
      );

      blocTest(
        '[AdvicerStateLoading, AdvicerStateError] when adviceRequested() is called',
        setUp: () => when(() => mockAdviceUseCases.getAdvice()).thenAnswer(
                (invocation) =>
                Future.value(Left<Failure, AdviceEntity>(GeneralFailure()))),
        build: () => AdvicerCubit(adviceUseCases: mockAdviceUseCases),
        act: (cubit) => cubit.adviceRequest(),
        expect: () => const <AdvicerCubitState>[
          AdvicerStateLoading(),
          AdvicerStateError(message: generalFailureMessage)
        ],
      );
    });
  });
}
