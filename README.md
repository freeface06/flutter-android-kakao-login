# 카카오톡 로그인

1. flutter, android 스튜디오 설치

2. 터미널 열고 sdk 설치

- 설치 명령어
flutter pub add kakao_flutter_sdk

- pub get 실행
flutter pub get

3. 키 해시 확인

* cmd창에서 명령어를 실행한다.
* 실행전에 openssl 설치 및 환경변수 적용 필요.
* 환경변수를 적용하지 않고 설치만 하고 키 해시 확인을 할 경우, 설치한 openssl폴더에 bin 폴더로 이동하여 명령어 실행
예) C:\openssl-0.9.8k_X64\bin

- 디버그키 확인 명령어
keytool -exportcert -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore -storepass android -keypass android | openssl sha1 -binary | openssl base64

- 릴리즈키 확인 명령어
keytool -exportcert -alias <RELEASE_KEY_ALIAS> -keystore <RELEASE_KEY_PATH> | openssl sha1 -binary | PATH_TO_OPENSSL_LIBRARY\bin\openssl base64

4. kakao developer에서 적용할 것!

1) 애플리케이션 생성
2) 플랫폼에 안드로이드 플랫폼 등록 패키지명, 키해시 추가(패키지명은 프로젝트의 android > app > src > main > AndroidManifest.xml 상단에서 패키지명 확인 )

5. android > app > src > main > AndroidManifest.xml 수정

AndroidManifest.xml의 <application>...</application> 태그안에 아래 내용 삽입

    <!-- 카카오 로그인 커스텀 URL 스킴 설정 -->
    <activity 
        android:name="com.kakao.sdk.flutter.AuthCodeCustomTabsActivity"
        android:exported="true">
        <intent-filter android:label="flutter_web_auth">
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />

            <!-- "kakao${YOUR_NATIVE_APP_KEY}://oauth" 형식의 앱 실행 스킴 설정 -->
            <!-- 카카오 로그인 Redirect URI -->
            <data android:scheme="kakao${YOUR_NATIVE_APP_KEY}" android:host="oauth"/>
        </intent-filter>
    </activity>

6. main.dart 수정

- sdk import

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

- main.dart 안의 main() 함수에 아래 내용 추가

    // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
    WidgetsFlutterBinding.ensureInitialized();

    KakaoSdk.init(
        nativeAppKey: '${YOUR_NATIVE_APP_KEY}',
        javaScriptAppKey: '${YOUR_JAVASCRIPT_APP_KEY}',
    );
    
7. 카카오 로그인 구현 예제

// 카카오 로그인 구현 예제

// 카카오톡 실행 가능 여부 확인
// 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
if (await isKakaoTalkInstalled()) {
  try {
      await UserApi.instance.loginWithKakaoTalk();
      print('카카오톡으로 로그인 성공');
  } catch (error) {
    print('카카오톡으로 로그인 실패 $error');

    // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
    // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
    if (error is PlatformException && error.code == 'CANCELED') {
        return;
    }
    try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
    } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
    }
  }
} else {
  try {
    await UserApi.instance.loginWithKakaoAccount();
    print('카카오계정으로 로그인 성공');
  } catch (error) {
    print('카카오계정으로 로그인 실패 $error');
  }
}

