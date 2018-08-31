# flutter_wechat

A  flutter plugin to use wechat.
测试使用暂时不维护了 有需要的请使用 https://github.com/OpenFlutter/fluwx
## Features
- [X]  Add Login
- [X]  Add Pay
- [ ]  Support LocalImage
- [ ]  Support 分享小程序
## Install
Add this to your package's pubspec.yaml file:
```
dependencies:
  flutter_wechat: "^0.1.5"
 ```
## Getting Started

* Android
   * For Android, you must do the following before you can use the plugin:
     Add the permissions to your `AndroidManifest.xml`
      ```
       <uses-permission android:name="android.permission.INTERNET" />
       <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
       <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
       <uses-permission android:name="android.permission.READ_PHONE_STATE" />
       <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
       <uses-permission android:name="android.permission.WRITE_SETTINGS" />
      ```
      如果想要响应微信分享登录resp需要在mainActivity同级目录下创建wxapi文件夹
      下面新建WXEntryACtivity集成Activity(需要在`AndroidManifest.xml`注册）
```
    <activity android:name=".wxapi.WXEntryActivity" android:exported="true" android:launchMode="singleTop"/>
```

```
    private IWXAPI api;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        api = WXAPIFactory.createWXAPI(this, "wxb25d3dec3db1affc", false);
        onNewIntent(getIntent());
        finish();
    }

        @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp baseResp) {
        sendBroadcastToWechat(baseResp);
    }

    private void sendBroadcastToWechat(BaseResp baseResp) {
        Intent intent = new Intent();
        intent.setAction("sendResp");
        if (baseResp instanceof SendAuth.Resp) {
            SendAuth.Resp resp = (SendAuth.Resp) (baseResp);
            intent.putExtra("code", resp.errCode == 0 ? resp.code : "-1");
            intent.putExtra("type", "SendAuthResp");
            sendBroadcast(intent);
        } else {
            intent.setAction("sendResp");
            intent.putExtra("code", baseResp.errCode + "");
            intent.putExtra("type", "ShareResp");
            sendBroadcast(intent);
        }
    }
    protected void onNewIntent(Intent intent) {
        api.handleIntent(intent, this);
    }
 ```
 如果想要响应微信支付resp需要在mainActivity同级目录下创建wxapi文件夹(需要在`AndroidManifest.xml`注册）
 
    <activity
      android:name=".wxapi.WXPayEntryActivity"
      android:exported="true"
      android:launchMode="singleTop">

      <intent-filter>
          <action android:name="android.intent.action.VIEW"/>
          <category android:name="android.intent.category.DEFAULT"/>
          <data android:scheme="your AppId"/>
      </intent-filter>
    </activity>
 
      下面新建WXEntryACtivity集成Activity
 ```
 public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {


    private IWXAPI api;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        api = WXAPIFactory.createWXAPI(this, "wxb25d3dec3db1affc", false);
        onNewIntent(getIntent());
        finish();
    }

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp baseResp) {
        sendBroadcastToWechat(baseResp);
    }

    private void sendBroadcastToWechat(BaseResp baseResp) {
        Intent intent = new Intent();
        intent.setAction("sendResp");
        intent.putExtra("code", baseResp.errCode + "");
        intent.putExtra("type", "PayResp");
        sendBroadcast(intent);
    }

    protected void onNewIntent(Intent intent) {
        api.handleIntent(intent, this);
    }


}
```
* IOS
    * add a wechat key.
        在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id
        参考 https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN
<br/> <br/>
    * 重写项目的AppDelegate的handleOpenURL和openURL方法         
```        
// ios 8.x or older
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
     NSString * urlStr = [url absoluteString];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"WeChat" object:nil userInfo:@{@"url":urlStr}];
    return YES;
}
```
```
// ios 9.0+
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    NSString * urlStr = [url absoluteString];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"WeChat" object:nil userInfo:@{@"url":urlStr}];
    return YES;
}
```
         
## How to use
```
import 'package:flutter_wechat/flutter_wechat.dart';
```
```
      分享返回错误码 0为正确 -1 -2 -3- 4- 5
      登录成功返回 access_code 登录错误返回 -1
      支付成功返回 0为正确  -1 -2
``` 
```
注册
await FlutterWechat.registerWechat("wxxxxxx").then((state){print(state)});// 微信注册需要在你需要的地方注册，最好是app首页
分享
await FlutterWechat.shareText(text: "test", type:0,).then((state){print(state)});//文字分享 type 0 聊天页面 1 朋友圈
await FlutterWechat.shareImage(imgUrl: "xxx", type:0,).then((state){print(state)});
await FlutterWechat.shareMusic(imgUrl: "xxx", musicUrl:"",title:"",description:"",musicDataUrl:"",musicLowBandDataUrl:"",musicLowBandUrl:"",type:0,).then((state){print(state)});
await FlutterWechat.shareVideo(imgUrl: "xxx", videoUrl:"",title:"",description:"",videoLowBandUrl:"",type:0,).then((state){print(state)});
await FlutterWechat.shareWebPage(imgUrl: "xxx", webpageUrl:"",title:"",description:"",type:0,).then((state){print(state)});
登录
await FlutterWechat.login(scope:"",state:"").then((state){print(state)});
支付
await FlutterWechat.pay(partnerId: "",prepayId: "",nonceStr: "",timeStamp: "",sign: "",package: "",appId: "",).then((state){print(state)});//具体参考微信参数传递
```
