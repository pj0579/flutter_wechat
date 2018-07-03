import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWechat {
  String code;
  static const MethodChannel _channel = const MethodChannel('flutter_wechat');

  static Future<dynamic> registerWechat(String wxId) async {
    var res=await _channel.invokeMethod(
        'registerWechat', {'wxId': wxId});
    return res;
  }


  static Future<dynamic> shareWebPage(
      {String webpageUrl: "", String title: "title", String description: "description", int type: 0, String imgUrl: ""}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'webpageUrl': webpageUrl,
      'title': title,
      'description': description,
      'type': type,
      'imgUrl': imgUrl
    };
   var res= await _channel.invokeMethod(
        'shareWebPage',
        params);
    return res;
  }

  static Future<dynamic> shareText({String text: "", int type: 0}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'type': type,
      'text': text,

    };
    var res=await _channel.invokeMethod(
        'shareText',
        params);
    return res;
  }

  static Future<dynamic> shareImage({String imgUrl: "", int type: 0}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'type': type,
      'imgUrl': imgUrl,

    };
    var res=await _channel.invokeMethod(
        'shareImage',
        params);
    return res;
  }

  static Future<dynamic> shareMusic(
      {String imgUrl: "", int type: 0, String musicUrl: "", String title: "", String description: "", String musicDataUrl: "", String musicLowBandDataUrl: "", String musicLowBandUrl: ""}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'type': type,
      'imgUrl': imgUrl,
      'musicUrl': musicUrl,
      'title': title,
      'description': description,
      'musicDataUrl': musicDataUrl,
      'musicLowBandDataUrl': musicLowBandDataUrl,
      'musicLowBandUrl': musicLowBandUrl,
    };
    var res=await _channel.invokeMethod(
        'shareMusic',
        params);
    return res;
  }

  static Future<dynamic> shareVideo(
      {String imgUrl: "", int type: 0, String videoUrl: "", String title: "", String description: "", String videoLowBandUrl: ""}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'type': type,
      'imgUrl': imgUrl,
      'videoUrl': videoUrl,
      'title': title,
      'description': description,
      'videoLowBandUrl': videoLowBandUrl
    };
    var res=await _channel.invokeMethod(
        'shareVideo',
        params);
    return res;
  }

  static Future<dynamic> login(
      {String scope: "snsapi_userinfo", String state: "login",}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'scope': scope,
      'state': state
    };
    var res=await _channel.invokeMethod(
        'login',
        params);
    return res;
  }


  static Future<dynamic> pay({
    String partnerId: "",
    String prepayId: "",
    String nonceStr: "",
    String timeStamp: "",
    String sign: "",
    String package: "",
    String appId: "",
  }) async {
   var res= await _channel.invokeMethod(
        'pay');
    return res;
  }
}
