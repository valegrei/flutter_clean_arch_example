import 'package:advicer/2_application/core/services/theme_service.dart';
import 'package:advicer/2_application/pages/advice/widget/custom_button.dart';
import 'package:advicer/2_application/pages/advice/widget/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvicePage extends StatelessWidget {
  const AdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Advicer",
          style: themeData.textTheme.headlineLarge,
        ),
        centerTitle: true,
        actions: [
          Switch(
              value: Provider.of<ThemeService>(context).isDarkModeOn,
              onChanged: (_) {
                Provider.of<ThemeService>(context, listen: false).toggleTheme();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: const [
            Expanded(
                child: Center(
              child: Center(
                  child: ErrorMessage(message: 'uuups something gone wrong!')
                  //AdviceField(advice: "Example advice - your day will be good!",),
                  ),
              /*CircularProgressIndicator(
                color: themeData.colorScheme.secondary,
              )*/
              /*Text("Your Advice is waiting for you!", style: themeData.textTheme.headlineLarge,),*/
            )),
            SizedBox(height: 200, child: Center(child: CustomButton())),
          ],
        ),
      ),
    );
  }
}
