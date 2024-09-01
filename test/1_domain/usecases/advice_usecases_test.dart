import 'package:advicer/0_data/repositories/advice_repo_impl.dart';
import 'package:advicer/1_domain/entities/advice_entity.dart';
import 'package:advicer/1_domain/failures/failures.dart';
import 'package:advicer/1_domain/usecases/advice_usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'advice_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AdviceRepoImpl>()])
void main() {
  group('AdviceUsescases', () {
    group('should return AdviceEntity', () {
      test('when AdviceRepoImpl returns an AdviceModel', () async {
        final mockAdviceRepoImpl = MockAdviceRepoImpl();
        final adviceuseCaseUnderTest =
            AdviceUseCases(adviceRepo: mockAdviceRepoImpl);

        when(mockAdviceRepoImpl.getAdviceFromDatasource()).thenAnswer(
            (realInvocation) =>
                Future.value(const Right(AdviceEntity(advice: 'test', id: 42))));

        final result = await adviceuseCaseUnderTest.getAdvice();

        expect(result.isLeft(), false);
        expect(result.isRight(), true);
        expect(
            result,
            const Right<Failure, AdviceEntity>(
                AdviceEntity(advice: 'test', id: 42)));
        verify(mockAdviceRepoImpl.getAdviceFromDatasource()).called(
            1); // when yo want to check if a method wast not call use verifyNever(mock.methodCall) instead .called(0)
        verifyNoMoreInteractions(mockAdviceRepoImpl);
      });
    });

    group('should return left with', ()  {
      test('a ServerFailure', () async {
        final mockAdviceRepoImpl = MockAdviceRepoImpl();
        final adviceuseCaseUnderTest =
        AdviceUseCases(adviceRepo: mockAdviceRepoImpl);

        when(mockAdviceRepoImpl.getAdviceFromDatasource())
        .thenAnswer((realInvocation) => Future.value(Left(ServerFailure())));

        final result = await adviceuseCaseUnderTest.getAdvice();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(ServerFailure()));
        verify(mockAdviceRepoImpl.getAdviceFromDatasource()).called(1);
        verifyNoMoreInteractions(mockAdviceRepoImpl);
      });
    });

    group('should return left with', ()  {
      test('a GeneralFailure', () async {
        final mockAdviceRepoImpl = MockAdviceRepoImpl();
        final adviceuseCaseUnderTest =
        AdviceUseCases(adviceRepo: mockAdviceRepoImpl);

        when(mockAdviceRepoImpl.getAdviceFromDatasource())
            .thenAnswer((realInvocation) => Future.value(Left(GeneralFailure())));

        final result = await adviceuseCaseUnderTest.getAdvice();

        expect(result.isLeft(), true);
        expect(result.isRight(), false);
        expect(result, Left<Failure, AdviceEntity>(GeneralFailure()));
        verify(mockAdviceRepoImpl.getAdviceFromDatasource()).called(1);
        verifyNoMoreInteractions(mockAdviceRepoImpl);
      });
    });
  });
}
