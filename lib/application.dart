import 'package:dio/dio.dart';
import 'package:cnblogs/entity/accesstoken.dart';
import 'package:prefs/prefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:intl/intl.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'entity/user.dart';
import 'dart:convert';

class Application {
  static Router router;
  static String Token = '';
  static UserEntity User;
  static final String ClientId = 'd6c6987a-a73d-4309-8d74-d6027d9732b5';
  static final String ClientSecret = 'TqtsJT13U6m2u3v7QEHQXWRlx8XdZ8tGxv81VCQ-XxTY3nVXYBKHSXPthveAaGm95eNVMPS91XJRLBT4';
  static final Dio SystemDio = new Dio();
  static final Dio UserDio = new Dio();

  static init() {
    Prefs.getStringF('user','').then((_json) {
      if (_json.isNotEmpty) {
        User = UserEntity.fromJson(json.decode(_json));
      }
    });
    UserDio.interceptors.add(InterceptorsWrapper(onRequest: (Options options){
      if(User!=null){
        options.headers["Authorization"] =User.Token;
        return options;
      }
    }));
    SystemDio.interceptors.add(InterceptorsWrapper(onRequest: (Options options) {
      if (Token.isEmpty) {
        SystemDio.lock();
        Prefs.init();
        Prefs.getStringF('token', '').then((token) {
          Token = token;
          if (Token.isEmpty) {
            print('获取AccessToken');
            FormData formData = new FormData.from({
              "client_id": Application.ClientId,
              "client_secret": Application.ClientSecret,
              'grant_type': 'client_credentials'
            });
            return new Dio()
                .post("https://api.cnblogs.com/token", data: formData)
                .then((response) {
              AccessToken at = AccessToken.fromJson(response.data);
              options.headers["Authorization"] =
                  Token = at.token_type + ' ' + at.access_token;
              print("Token: " + Token);
              Prefs.setString('token', Token).then((b) {
                Prefs.dispose();
              });
              return options;
            }).whenComplete(() => SystemDio.unlock()); // unlock the dio
          } else {
            options.headers["Authorization"] = Token;
            SystemDio.unlock();
            print('从本地提取出Token:' + Token);
            return options;
          }
        }).whenComplete(() => SystemDio.unlock());
      } else {
        options.headers["Authorization"] = Token;
        return options;
      }
    }, onError: (error) {
      print(error.request.uri);
      print(error.message);
      Fluttertoast.showToast(
          msg: error.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }));
//    flutterWebviewPlugin.onStateChanged.listen((_state) {
//      if (WebViewState.finishLoad == _state) {
//        print('finishLoad：' + currentUrl);
//        if (currentUrl.startsWith('https://oauth.cnblogs.com/auth/callback')) {
//          //博客园登录后的回调
//          var code = currentUrl.split('?')[1].split('=')[1];
//          print('博客园code：' + code);
//          FormData formData = new FormData.from({
//            "client_id": Application.ClientId,
//            "client_secret": Application.ClientSecret,
//            'grant_type': 'authorization_code',
//            'code': code,
//            'redirect_uri': 'https://oauth.cnblos.com/auth/callback'
//          });
//          new Dio()
//              .post("https://oauth.cnblogs.com/connect/token ", data: formData)
//              .then((response) {
//            AccessToken at = AccessToken.fromJson(response.data);
//            final ut= at.token_type+' '+at.access_token;
//            print("用户Token: " + ut);
//            UserDio.get('https://api.cnblogs.com/api/users').then((_response){
//              if(_response==null || _response.statusCode!=200){
//                print('获取用户信息失败');
//              }
//              else{
//                Application.User=UserEntity.fromJson(_response.data);
//                Application.User.Token=ut;
//                var _json=json.encode(Application.User);
//                print('用户信息json：'+_json);
//                Prefs.setString('user', _json).whenComplete(() {
////              flutterWebviewPlugin.dispose();
//                });
//              }
//            });
//          });
//        }
//      }
//    });
//    flutterWebviewPlugin.onUrlChanged.listen((String url) {
//      currentUrl = url;
//      print('onUrlChanged：' + currentUrl);
//    });
  }

  static DateFormat format = new DateFormat('yyyy-MM-dd HH:mm');
  static String getTime(DateTime time) {
    DateTime now = DateTime.now();
    var cha = now.difference(time);
//    print(cha);
    if (cha.inDays > 2)
      return format.format(time);
    else if (cha.inDays > 1)
      return '前天';
    else if (cha.inDays > 0)
      return '昨天';
    else if (cha.inHours > 0)
      return '${cha.inHours}小时前';
    else if (cha.inMinutes > 0)
      return '${cha.inMinutes}分钟前';
    else if (cha.inSeconds > 0)
      return '${cha.inSeconds}秒前';
    else
      return '刚刚';
  }

  static final flutterWebviewPlugin = new FlutterWebviewPlugin();
  static String currentUrl = '';
}
