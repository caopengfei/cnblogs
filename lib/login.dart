import 'package:dio/dio.dart';
import 'application.dart';
import 'package:flutter/material.dart';
import 'package:prefs/prefs.dart';
import 'entity/user.dart';
import 'dart:convert';
import 'package:cnblogs/entity/accesstoken.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final String url =
      'https://oauth.cnblogs.com/connect/authorize?client_id=${Application.ClientId}&state=cnblogs&nonce=${DateTime.now()}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("登录")),
      body: WebView(
        initialUrl: url,
        onWebViewCreated: (_control) {
          print('加载url：' + url);
        },
        onPageFinished: (_url) {
          print('加载完成：' + _url);
          if(_url.startsWith('https://oauth.cnblogs.com/auth/callback')){
            //博客园登录后的回调
            var code = _url.split('?')[1].split('=')[1];
            print('博客园code：' + code);
            FormData formData = new FormData.from({
              "client_id": Application.ClientId,
              "client_secret": Application.ClientSecret,
              'grant_type': 'authorization_code',
              'code': code,
              'redirect_uri': 'https://oauth.cnblos.com/auth/callback'
            });
            new Dio()
                .post("https://oauth.cnblogs.com/connect/token ", data: formData)
                .then((response) {
              AccessToken at = AccessToken.fromJson(response.data);
              final ut = at.token_type + ' ' + at.access_token;
              print("用户Token: " + ut);
              Application.UserDio.get('https://api.cnblogs.com/api/users')
                  .then((_response) {
                if (_response == null || _response.statusCode != 200) {
                  print('获取用户信息失败');
                } else {
                  Application.User = UserEntity.fromJson(_response.data);
                  Application.User.Token = ut;
                  var _json = json.encode(Application.User);
                  print('用户信息json：' + _json);
                  Prefs.setString('user', _json).whenComplete(() {
//                Navigator.of(context).
                  });
                }
              });
            });
          }
        },
      ),
    );
  }
}
