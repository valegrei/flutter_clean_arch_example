import 'package:advicer/2_application/pages/advice/bloc/advicer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkResponse(
      onTap: () {
        BlocProvider.of<AdvicerBloc>(context).add(AdviceRequestEvent());
      },
      child: Material(
        elevation: 20,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: themeData.colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              'Get advice',
              style: themeData.textTheme.headlineLarge,
            ),
          ),
        ),
      ),
    );
  }
}
