
import 'package:flutter/material.dart';

//시작화면
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2),() //2초 딜레이
    {
      Navigator.pushNamed(context, '/main'); // homescreen으로 넘어가기
    }
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/idea.png',
              width: 180,
              height: 180,
            ),
            Container(
              margin: EdgeInsets.only(top:32),
              child: Text(
                'Archive Idea',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color:Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
