import 'package:archive_idea/data/idea_info.dart';
import 'package:archive_idea/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var dbHelper = DatabaseHelper(); // 데이터베이스 접근 유틸 객체
  List<IdeaInfo> lstIdeaInfo = []; // 아이디어 목록 데이터들

  @override
  void initState() {
    super.initState();
    // 아이디어 목록 가져오기
    getIdeaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: SizedBox(),
        title: Text(
          'Archive Idea',
          style: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: lstIdeaInfo.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: listItem(index),
              onTap: () async {
                var result = await Navigator.pushNamed(context, '/detail',
                    arguments: lstIdeaInfo[index]);
                if (result != null) {
                  String msg = "";
                  if (result == 'update') {
                    // 수정 완료
                    msg = '아이디어가 수정되었습니다.';
                  } else if (result == 'delete') {
                    // 삭제 완료
                    msg = '아이디어가 삭제되었습니다.';
                  }

                  getIdeaInfo();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(msg),
                      ),
                    );
                  }
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 새 아이디어 작성 화면으로 이동
          var result = await Navigator.pushNamed(context, '/edit');
          // A->B->A 화면으로 돌아왔을 때 (B로부터 결과 값을 전달 받았을 때)
          if (result != null) {
            getIdeaInfo();
            // 아이디어 작성 완료 메시지
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('새로운 아이디어가 추가되었습니다.'),
                ),
              );
            }
          }
        },
        child: Image.asset(
          'assets/idea.png',
          width: 48,
          height: 48,
        ),
        backgroundColor: Color(0xff7f52fd).withOpacity(0.7),
      ),
    );
  }

  Widget listItem(int index) {
    return Container(
      height: 82,
      margin: EdgeInsets.only(top: 16),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0xffd9d9d9), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // 아이디어 제목
          Container(
            margin: EdgeInsets.only(left: 16, bottom: 16),
            child: Text(
              lstIdeaInfo[index].title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 16, bottom: 16),
              child: Text(
                DateFormat("yyyy.MM.dd HH:mm").format(
                    DateTime.fromMillisecondsSinceEpoch(
                        lstIdeaInfo[index].createdAt)),
                style: TextStyle(color: Color(0xffaeaeae), fontSize: 10),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 16, bottom: 8),
              child: RatingBar.builder(
                initialRating: lstIdeaInfo[index].priority.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 16,
                itemPadding: EdgeInsets.symmetric(horizontal: 0),
                itemBuilder: (context, index) {
                  return Icon(
                    Icons.star,
                    color: Colors.amber,
                  );
                },
                ignoreGestures: true,
                updateOnDrag: false,
                onRatingUpdate: (value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getIdeaInfo() async {
    // 아이디어 목록 조회
    await dbHelper.initDatabase();
    // 아이디어 정보들을 리스트 객체에 담기
    lstIdeaInfo = await dbHelper.getAllIdeaInfo();
    // 리스트 객체 역순으로 정렬
    lstIdeaInfo.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    setState(() {}); // UI 업데이트
  }
}
