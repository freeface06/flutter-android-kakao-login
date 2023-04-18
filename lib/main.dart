import 'package:blue/kakao_login.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() {
// 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

// runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: '72638c4bc8ae6fdd899769b98b3982ff',
    javaScriptAppKey: '3351bd3264cc0262200943029e406aa4',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "kakao",
      home: Scaffold(
        appBar: null,
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          onPressed: (){
            KakaoLogin().login();
          },
          child: Image.network(
            'https://developers.kakao.com/tool/resource/static/img/button/login/full/ko/kakao_login_medium_narrow.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
