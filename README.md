# flutter_wechat

A  flutter plugin to use wechat.

## Features
- [X]  Add Login
- [ ]  Add Pay
- [ ]  Support LocalImage
- [ ]  Support 分享小程序
## Install
Add this to your package's pubspec.yaml file:
```
dependencies:
  flutter_wechat: "^0.0.7"
 ```
## Getting Started

* Android
   * For Android, you must do the following before you can use the plugin:
       * Add the permissions to your AndroidManifest.xml
      ```
       <uses-permission android:name="android.permission.INTERNET" />
       <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
       <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
       <uses-permission android:name="android.permission.READ_PHONE_STATE" />
       <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
       <uses-permission android:name="android.permission.WRITE_SETTINGS" />
      ```
* IOS
    * add a wechat key.
         * 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id
         * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN
## How to use
```
import 'package:flutter_wechat/flutter_wechat.dart';
注册
await FlutterWechat.registerWechat("wxxxxxx");// 微信注册需要在你需要的地方注册，最好是app首页
分享
await FlutterWechat.shareText(text: "test", type:0,);//文字分享 type 0 聊天页面 1 朋友圈
await FlutterWechat.shareImage(imgUrl: "xxx", type:0,);
await FlutterWechat.shareMusic(imgUrl: "xxx", musicUrl:"",title:"",description:"",musicDataUrl:"",musicLowBandDataUrl:"",musicLowBandUrl:"",type:0,);
await FlutterWechat.shareVideo(imgUrl: "xxx", videoUrl:"",title:"",description:"",videoLowBandUrl:"",type:0,);
await FlutterWechat.shareWebPage(imgUrl: "xxx", webpageUrl:"",title:"",description:"",type:0,);
登录
await FlutterWechat.login(scope:"",state:"");

