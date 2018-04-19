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
      如果想要响应微信resp需要在mainActivity同级目录下创建wxapi文件夹
      下面新建WXEntryACtivity集成Activity
      例如：
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
        String toastString = "";
        switch (baseResp.errCode) {
            case 0:
                toastString = "操作成功";
                if (baseResp instanceof SendAuth.Resp) {
                    SendAuth.Resp newResp = (SendAuth.Resp) baseResp;
                    //获取微信传回的code
                    String code = newResp.code;
                    FlutterWechatPlugin.setCode(code);
                }
                break;
            case -1:
                toastString = "一般错误";
                break;
            case -2:
                toastString = "取消操作";
                break;
            case -3:
                toastString = "发送失败";
                break;
            case -4:
                toastString = "认证拒绝";
                break;
            case -5:
                toastString = "帐号禁用";
                break;
        }
        Toast.makeText(this, toastString, Toast.LENGTH_SHORT).show();
    }

    protected void onNewIntent(Intent intent) {
        api.handleIntent(intent, this);
    }
 ```
* IOS
    * add a wechat key.
         * 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id
         * https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN
<br/> 重写项目的AppDelegate的handleOpenURL和openURL方法         
```        
         - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
      {
         return  [WXApi handleOpenURL:url delegate:self];
      }
        - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString     *)sourceApplication annotation:(id)annotation
      {
         BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
         NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
         return  isSuc;
      }
       - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
      {
         return [WXApi handleOpenURL:url delegate:self];
      }
```
         实现-(void) onResp:(BaseResp*)resp方法
         
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

