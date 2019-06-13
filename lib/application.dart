import 'package:dio/dio.dart';
import 'package:cnblogs/entity/accesstoken.dart';
import 'package:prefs/prefs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:intl/intl.dart';
import 'entity/user.dart';
import 'dart:convert';

class Application {
  static Router router;
  static String Token = '';
  static UserEntity User;
  static final String ClientId = 'd6c6987a-a73d-4309-8d74-d6027d9732b5';
  static final String ClientSecret =
      'TqtsJT13U6m2u3v7QEHQXWRlx8XdZ8tGxv81VCQ-XxTY3nVXYBKHSXPthveAaGm95eNVMPS91XJRLBT4';
  static final Dio SystemDio = new Dio();
  static final Dio UserDio = new Dio();

  static init() {
    Prefs.getStringF('user', '').then((_json) {
      if (_json.isNotEmpty) {
        User = UserEntity.fromJson(json.decode(_json));
      }
    });
    UserDio.interceptors.add(InterceptorsWrapper(onRequest: (Options options) {
      if (User != null) {
        options.headers["Authorization"] = User.Token;
        return options;
      }
    }));
    Token='';
    Prefs.setString('token', '');
    SystemDio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options options){
      if (Token.isEmpty) {
        SystemDio.lock();
        bindToken().then((d){
          options.headers["Authorization"] = Token;
          SystemDio.unlock();
          return options;
        });
      } else {
        options.headers["Authorization"] = Token;
        SystemDio.unlock();
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
    }, onResponse: (_response) {
      if (_response.statusCode >= 400 && _response.statusCode <= 500) {
        //Toeken已失效
        Application.Token = '';
        Prefs.setString('token', '').then((b) {
          bindToken();
        });
      }
    }));
  }
  static Future bindToken() async{
    if(Token.isEmpty){
      Token=await Prefs.getStringF('token','');
      if(Token.isEmpty){
        FormData formData = new FormData.from({
          "client_id": Application.ClientId,
          "client_secret": Application.ClientSecret,
          'grant_type': 'client_credentials'
        });
        var response=await new Dio()
            .post("https://api.cnblogs.com/token", data: formData);
        if(response==null || response.statusCode!=200){
          print('绑定Token失败');
        }
        else{
          AccessToken at = AccessToken.fromJson(response.data);
          Token = at.token_type + ' ' + at.access_token;
          print("Token: " + Token);
          Prefs.setString('token', Token).then((b) {
            Prefs.dispose();
          });
        }
      }
      else
        print('本地Token：'+Token);
    }
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
}