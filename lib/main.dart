import 'package:archive_idea/data/idea_info.dart';
import 'package:archive_idea/screen/detail_screen.dart';
import 'package:archive_idea/screen/edit_screen.dart';
import 'package:archive_idea/screen/homescreen.dart';
import 'package:archive_idea/screen/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archive Idea',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      // 경로 초기화면 설정
      routes: {
        '/': (context) => const SplashScreen(),
        // 앱이 처음 시작할때 뜨는 화면
        '/main': (context) => const Homescreen(),
        //앱 내에서 다른 화면으로 움직일때 =>homescreen으로
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          //1.아이디어 기록값을 넘기지 못한다면 작성 시나리오
          // 2.아이디어 기록값을 넘길 수 있다면 수정 시나리오
          final IdeaInfo? ideaInfo = settings.arguments as IdeaInfo?;
          return MaterialPageRoute(
            builder: (context) {
              return EditScreen(
                ideaInfo: ideaInfo,
              );
            },
          );
        }
        else if(settings.name=='/detail')
          {
            final IdeaInfo? ideaInfo = settings.arguments as IdeaInfo?;
            return MaterialPageRoute(
              builder: (context) {
                return DetailScreen(
                  ideaInfo: ideaInfo,
                );
              },
            );
          }
      },
    );
  }
}
