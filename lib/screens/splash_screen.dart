import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/launcher_icon.png',
              width: 300,
              height: 300,
            ),
            const SizedBox(
              height: 50,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
