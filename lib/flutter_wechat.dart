import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWechat {

  static const MethodChannel _channel =
  const MethodChannel('flutter_wechat');

  static void registerWechat(String wxId) async {
    await _channel.invokeMethod(
        'registerWechat', {'wxId': wxId});
  }

  static Future<bool> shareWebPage(
      {String webpageUrl: "", String title: "title", String description: "description", int type: 0, String imgUrl: ""}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'webpageUrl': webpageUrl,
      'title': title,
      'description': description,
      'type': type,
      'imgUrl': imgUrl
    };
    await _channel.invokeMethod(
        'shareWebPage',
        params);
    return true;
  }

  static Future<bool> shareText({String text: "", int type: 0}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'type': type,
      'text': text,

    };
    await _channel.invokeMethod(
        'shareText',
        params);
    return true;
  }

  static Future<bool> shareImage({String imgUrl: "", int type: 0}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'type': type,
      'imgUrl': imgUrl,

    };
    await _channel.invokeMethod(
        'shareImage',
        params);
    return true;
  }

  static Future<bool> shareMusic(
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
    await _channel.invokeMethod(
        'shareMusic',
        params);
    return true;
  }

  static Future<bool> shareVideo(
      {String imgUrl: "", int type: 0, String videoUrl: "", String title: "", String description: "",String videoLowBandUrl:""}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'type': type,
      'imgUrl': imgUrl,
      'videoUrl': videoUrl,
      'title': title,
      'description': description,
      'videoLowBandUrl':videoLowBandUrl
    };
    await _channel.invokeMethod(
        'shareVideo',
        params);
    return true;
  }
}
