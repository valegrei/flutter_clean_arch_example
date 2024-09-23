import 'package:advicer/2_application/core/services/theme_service.dart';
import 'package:advicer/2_application/pages/advice/advice_page.dart';
import 'package:advicer/2_application/pages/advice/cubit/advicer_cubit.dart';
import 'package:advicer/2_application/pages/advice/widgets/advice_field.dart';
import 'package:advicer/2_application/pages/advice/widgets/error_message.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class MockAdvicerCubit extends MockCubit<AdvicerCubitState>
    implements AdvicerCubit {}

void main() {
  Widget widgetUnderTest({required AdvicerCubit cubit}) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => ThemeService(),
        child: BlocProvider(
          create: (context) => cubit,
          child: const AdvicerPage(),
        ),
      ),
    );
  }

  group('AdvicerPage', () {
    late AdvicerCubit mockAdvicerCubit;

    setUp(() {
      mockAdvicerCubit = MockAdvicerCubit();
    });

    testWidgets(
      'Initial when cubits Emits AdvicerInitial()',
      (widgetTester) async {
        whenListen(
          mockAdvicerCubit,
          Stream.fromIterable(const [AdvicerInitial()]),
          initialState: const AdvicerInitial(),
        );

        await widgetTester.pumpWidget(widgetUnderTest(cubit: mockAdvicerCubit));
      
        final advicerInitialTextFinder = find.text('Your Advice is waiting for you!');

        expect(advicerInitialTextFinder, findsOneWidget);
        },
    );

    testWidgets(
      'Initial when cubits Emits AdvicerStateLoading()',
          (widgetTester) async {
        whenListen(
          mockAdvicerCubit,
          Stream.fromIterable(const [AdvicerStateLoading()]),
          initialState: const AdvicerInitial(),
        );

        await widgetTester.pumpWidget(widgetUnderTest(cubit: mockAdvicerCubit));
        await widgetTester.pump();

        final advicerLoadingFinder = find.byType(CircularProgressIndicator);

        expect(advicerLoadingFinder, findsOneWidget);
      },
    );

    testWidgets(
      'Advice text when cubits emits AdvicerStateLoaded()',
          (widgetTester) async {
        whenListen(
          mockAdvicerCubit,
          Stream.fromIterable(const [AdvicerStateLoaded(advice: '42')]),
          initialState: const AdvicerInitial(),
        );

        await widgetTester.pumpWidget(widgetUnderTest(cubit: mockAdvicerCubit));
        await widgetTester.pump();

        final advicerLoadedFinder = find.byType(AdviceField);
        final adviceText = widgetTester.widget<AdviceField>(find.byType(AdviceField)).advice;

        expect(advicerLoadedFinder, findsOneWidget);
        expect(adviceText, '42');
      },
    );

    testWidgets(
      'Error when cubits emits AdvicerStateError()',
          (widgetTester) async {
        whenListen(
          mockAdvicerCubit,
          Stream.fromIterable(const [AdvicerStateError(message: 'error')]),
          initialState: const AdvicerInitial(),
        );

        await widgetTester.pumpWidget(widgetUnderTest(cubit: mockAdvicerCubit));
        await widgetTester.pump();

        final advicerErrorFinder = find.byType(ErrorMessage);

        expect(advicerErrorFinder, findsOneWidget);
      },
    );
  });
}
