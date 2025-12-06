import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          MainScreen(),
        ]),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1440,
          height: 3310,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 164,
                top: 36,
                child: Container(
                  width: 280,
                  height: 70,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 280,
                          height: 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/1.jpeg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 192,
                top: 172,
                child: Container(
                  width: 184,
                  height: 22,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          'StudyShare',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 27,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.69,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 496,
                top: 172,
                child: Container(
                  width: 89,
                  height: 22,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          '북마크',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 27,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.69,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 695,
                top: 172,
                child: Container(
                  width: 126,
                  height: 22,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          '노트 작성',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 27,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.69,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 931,
                top: 172,
                child: Container(
                  width: 118,
                  height: 22,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          '커뮤니티',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 27,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.69,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 1159,
                top: 172,
                child: Container(
                  width: 89,
                  height: 22,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          '프로필',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 27,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.69,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 0,
                top: 224,
                child: Container(
                  width: 1440,
                  height: 519,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/2.jpeg'),
                      //image: NetworkImage("https://placehold.co/1440x519"),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFE4E4E4),
                      ),
                    ),
                  ),
                ),

              ),

              Positioned(
                left: 994,
                top: 90,
                child: Container(
                  width: 37,
                  height: 22,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 37,
                          height: 22,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Text(
                                  '검색',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 1089,
                top: 90,
                child: Container(
                  width: 56,
                  height: 22,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 56,
                          height: 22,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Text(
                                  '로그인',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 1202,
                top: 90,
                child: Container(
                  width: 74,
                  height: 22,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 74,
                          height: 22,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Text(
                                  '회원가입',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 193,
                top: 1964,
                child: Container(
                  width: 15,
                  height: 45,
                  decoration: BoxDecoration(color: const Color(0xFFD9D9D9)),
                ),
              ),
              Positioned(
                left: 193,
                top: 843,
                child: Container(
                  width: 15,
                  height: 45,
                  decoration: BoxDecoration(color: const Color(0xFFD9D9D9)),
                ),
              ),
              Positioned(
                left: 223,
                top: 1977,
                child: Text(
                  '내 공부 내용을 작성하고 공유해 보세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 0.61,
                  ),
                ),
              ),
              Positioned(
                left: 223,
                top: 855,
                child: Text(
                  '실시간 노트를 확인해 보세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 0.61,
                  ),
                ),
              ),
              Positioned(
                left: 237,
                top: 2248,
                child: Text(
                  '나만의 공부 노트를\n작성하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.04,
                  ),
                ),
              ),
              Positioned(
                left: 592,
                top: 2248,
                child: Text(
                  '공부한 내용을 커뮤니티에\n공유 해보아요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.04,
                  ),
                ),
              ),
              Positioned(
                left: 1002,
                top: 2248,
                child: Text(
                  '자유롭게 이야기하고 \n질문해 보세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.04,
                  ),
                ),
              ),
              Positioned(
                left: 250,
                top: 2334,
                child: Container(
                  width: 164,
                  height: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 164,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFCB30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 38,
                        top: 14,
                        child: Text(
                          '작성하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.92,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 638,
                top: 2334,
                child: Container(
                  width: 164,
                  height: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 164,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFCB30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 38,
                        top: 14,
                        child: Text(
                          '공유하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.92,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 1026,
                top: 2334,
                child: Container(
                  width: 164,
                  height: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 164,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFCB30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 38,
                        top: 14,
                        child: Text(
                          '둘러보기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.92,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 652,
                top: 2063,
                child: Container(
                  width: 135,
                  height: 149,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/135x149"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 264,
                top: 2078,
                child: Container(
                  width: 136,
                  height: 134,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/136x134"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),

              //센터 그림에 원 3개
              Positioned(
                left: 615,
                top: 638,
                child: Container(
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE4E4E4),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 690,
                top: 638,
                child: Container(
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 765,
                top: 638,
                child: Container(
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE4E4E4),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //여기까지

              Positioned(
                left: 0,
                top: 2526,
                child: Container(
                  width: 1440,
                  height: 784,
                  decoration: BoxDecoration(color: const Color(0xFF9780A9)),

                ),
              ),
              Positioned(
                left: 193,
                top: 2594,
                child: Container(
                  width: 15,
                  height: 45,
                  decoration: BoxDecoration(color: const Color(0xFFD9D9D9)),
                ),
              ),
              Positioned(
                left: 223,
                top: 2593,
                child: Text(
                  '다른 사용자들이 추천하는 \n학습 자료를 확인하세요!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 223,
                top: 2703,
                child: Text(
                  '다른 사용자들이 추천하는 \n학습 자료를 확인하세요!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              Positioned(
                left: 189,
                top: 2822,
                child: Container(
                  width: 503,
                  height: 398,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 643,
                top: 2923,
                child: Container(
                  width: 230,
                  height: 320,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 230,
                          height: 320,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 55,
                        child: Text(
                          '수학 시험 \n100점 맞는 법',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.04,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 31,
                        top: 120,
                        child: Text(
                          '수학',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 76,
                        top: 120,
                        child: Text(
                          '기타',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 169,
                        child: Text(
                          '수학 시험 비법 공개',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.56,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 199,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '수학 공부 100분하고\n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                              TextSpan(
                                text: '      시험점수 100점 오르는 법',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Text(
                          '4',
                          style: TextStyle(
                            color: const Color(0xFFFF0000),
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.78,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 883,
                top: 2923,
                child: Container(
                  width: 230,
                  height: 320,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 230,
                          height: 320,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 55,
                        child: Text(
                          '수학 시험 \n100점 맞는 법',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.04,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 31,
                        top: 120,
                        child: Text(
                          '수학',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 76,
                        top: 120,
                        child: Text(
                          '기타',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 169,
                        child: Text(
                          '수학 시험 비법 공개',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.56,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 199,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '수학 공부 100분하고\n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                              TextSpan(
                                text: '      시험점수 100점 오르는 법',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Text(
                          '5',
                          style: TextStyle(
                            color: const Color(0xFFFF0000),
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.78,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 883,
                top: 2593,
                child: Container(
                  width: 230,
                  height: 320,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 230,
                          height: 320,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 55,
                        child: Text(
                          '수학 시험 \n100점 맞는 법',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.04,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 31,
                        top: 120,
                        child: Text(
                          '수학',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 76,
                        top: 120,
                        child: Text(
                          '기타',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 169,
                        child: Text(
                          '수학 시험 비법 공개',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.56,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 199,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '수학 공부 100분하고\n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                              TextSpan(
                                text: '      시험점수 100점 오르는 법',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: const Color(0xFFFF0000),
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.78,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 1123,
                top: 2593,
                child: Container(
                  width: 230,
                  height: 320,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 230,
                          height: 320,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 55,
                        child: Text(
                          '수학 시험 \n100점 맞는 법',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.04,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 31,
                        top: 120,
                        child: Text(
                          '수학',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 76,
                        top: 120,
                        child: Text(
                          '기타',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 169,
                        child: Text(
                          '수학 시험 비법 공개',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.56,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 199,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '수학 공부 100분하고\n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                              TextSpan(
                                text: '      시험점수 100점 오르는 법',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Text(
                          '3',
                          style: TextStyle(
                            color: const Color(0xFFFF0000),
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.78,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 643,
                top: 2593,
                child: Container(
                  width: 230,
                  height: 320,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 230,
                          height: 320,
                          decoration: BoxDecoration(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 55,
                        child: Text(
                          '수학 시험 \n100점 맞는 법',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.04,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: const Color(0xFFFF0000),
                            fontSize: 32,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.78,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 31,
                        top: 120,
                        child: Text(
                          '수학',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 65,
                        top: 121,
                        child: Container(
                          width: 40,
                          height: 23,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEFEFEF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 76,
                        top: 120,
                        child: Text(
                          '기타',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 2.50,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 169,
                        child: Text(
                          '수학 시험 비법 공개',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.56,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 199,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '수학 공부 100분하고\n',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                              TextSpan(
                                text: '      시험점수 100점 오르는 법',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 1040,
                top: 2068,
                child: Container(
                  width: 136,
                  height: 144,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/1.jpeg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 962.68,
                top: 86.68,
                child: Container(
                  width: 26.49,
                  height: 26.01,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 1057.86,
                top: 88.83,
                child: Container(
                  width: 23.31,
                  height: 23.33,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 1167.46,
                top: 88.83,
                child: Container(
                  width: 32.08,
                  height: 23.33,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 711.25,
                top: 657.79,
                child: Container(
                  width: 17.50,
                  height: 20.42,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 639.06,
                top: 657.62,
                child: Container(
                  width: 10.88,
                  height: 21.75,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 790.06,
                top: 657.62,
                child: Container(
                  width: 10.88,
                  height: 21.75,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 223,
                top: 912,
                child: Container(
                  width: 991,
                  height: 294,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFCFCFCF),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 223,
                top: 1241,
                child: Container(
                  width: 991,
                  height: 294,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFCFCFCF),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 223,
                top: 1570,
                child: Container(
                  width: 991,
                  height: 294,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFCFCFCF),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 256,
                top: 1021,
                child: Text(
                  '수학',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 256,
                top: 1350,
                child: Text(
                  '수학',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 256,
                top: 1679,
                child: Text(
                  '수학',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 328,
                top: 1021,
                child: Text(
                  '김학생',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 328,
                top: 1350,
                child: Text(
                  '김학생',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 328,
                top: 1679,
                child: Text(
                  '김학생',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 276,
                top: 1164,
                child: Text(
                  '25',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 276,
                top: 1486,
                child: Text(
                  '25',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 276,
                top: 1815,
                child: Text(
                  '25',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 352,
                top: 1164,
                child: Text(
                  '9',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 352,
                top: 1486,
                child: Text(
                  '9',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 352,
                top: 1815,
                child: Text(
                  '9',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 403,
                top: 1021,
                child: Text(
                  '2025 - 09 - 15',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 403,
                top: 1350,
                child: Text(
                  '2025 - 09 - 15',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 403,
                top: 1679,
                child: Text(
                  '2025 - 09 - 15',
                  style: TextStyle(
                    color: const Color(0xFFCFCFCF),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.22,
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 987,
                child: Text(
                  '미적분학 기본 개념 정리',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 0.85,
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 1316,
                child: Text(
                  '미적분학 기본 개념 정리',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 0.85,
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 1645,
                child: Text(
                  '미적분학 기본 개념 정리',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 0.85,
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 1064,
                child: Text(
                  '극한, 연솟성, 미분의 기본 개념들을 정리했습니다. 함수의 극한값을 구하는 \n방법과 연속함수의 조건들을 상세히 성명했습니다',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.14,
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 1393,
                child: Text(
                  '극한, 연솟성, 미분의 기본 개념들을 정리했습니다. 함수의 극한값을 구하는 \n방법과 연속함수의 조건들을 상세히 성명했습니다',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.14,
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 1722,
                child: Text(
                  '극한, 연솟성, 미분의 기본 개념들을 정리했습니다. 함수의 극한값을 구하는 \n방법과 연속함수의 조건들을 상세히 성명했습니다',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.14,
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 927,
                child: Container(
                  width: 45,
                  height: 45,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 243,
                top: 1256,
                child: Container(
                  width: 45,
                  height: 45,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 243,
                top: 1585,
                child: Container(
                  width: 45,
                  height: 45,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 243,
                top: 1161,
                child: Container(
                  width: 30,
                  height: 30,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 243,
                top: 1017,
                child: Container(
                  width: 60,
                  height: 30,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFE5E5E5),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 1346,
                child: Container(
                  width: 60,
                  height: 30,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFE5E5E5),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 1675,
                child: Container(
                  width: 60,
                  height: 30,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFE5E5E5),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 313,
                top: 1029,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 313,
                top: 1358,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 313,
                top: 1687,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 388,
                top: 1029,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 388,
                top: 1358,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 388,
                top: 1687,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 324,
                top: 1166,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 324,
                top: 1485,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 324,
                top: 1814,
                child: Container(
                  width: 25,
                  height: 25,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 243,
                top: 1482,
                child: Container(
                  width: 30,
                  height: 30,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 1164,
                top: 1485,
                child: Container(
                  width: 30,
                  height: 30,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 1164,
                top: 1814,
                child: Container(
                  width: 30,
                  height: 30,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 1164,
                top: 1161,
                child: Container(
                  width: 30,
                  height: 30,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}