#import "FlutterWechatPlugin.h"

@implementation FlutterWechatPlugin {
    FlutterResult res;
}
- (instancetype)init
{
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleOpenURL:)
                                                 name:@"WeChat"
                                               object:nil];
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_wechat"
                                     binaryMessenger:[registrar messenger]];
    FlutterWechatPlugin* instance = [[FlutterWechatPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    res=result;
    NSDictionary *arguments = [call arguments];
    NSNumber* wxType = arguments[@"type"];
    int type=[wxType intValue];
    if ([@"registerWechat" isEqualToString:call.method]) {
        [WXApi registerApp:arguments[@"wxId"]];
        res(nil);
    }
    else if([@"shareText" isEqualToString:call.method]) {
        NSString* text= arguments[@"text"];
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = text;
        req.bText = YES;
        req.scene = type==0?WXSceneSession:WXSceneTimeline;
        [WXApi sendReq:req];
    }else if([@"shareImage" isEqualToString:call.method]){
        NSString* imgUrl= arguments[@"imgUrl"];
        WXMediaMessage *mediaMsg = [WXMediaMessage message];
        WXImageObject *imgObj = [WXImageObject object];
        imgObj.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        mediaMsg.mediaObject = imgObj;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = mediaMsg;
        req.bText = NO;
        req.scene = type==0?WXSceneSession:WXSceneTimeline;
        [WXApi sendReq:req];
    }else if([@"shareWebPage" isEqualToString:call.method]){
        NSString* webpageUrl= arguments[@"webpageUrl"];
        NSString* imgUrl= arguments[@"imgUrl"];
        NSString* webTitle= arguments[@"title"];
        NSString* webDescription= arguments[@"description"];
        WXMediaMessage* message =[WXMediaMessage message];
        message.title = webTitle;
        message.description =webDescription;
        NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        [message setThumbImage:[UIImage imageWithData:data]];
        WXWebpageObject* webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl =webpageUrl;
        message.mediaObject = webpageObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.bText = NO;
        req.scene = type==0?WXSceneSession:WXSceneTimeline;
        [WXApi sendReq:req];
    }else if([@"shareMusic" isEqualToString:call.method]){
        NSString* musicUrl= arguments[@"musicUrl"];
        NSString* imgUrl= arguments[@"imgUrl"];
        NSString* musicTitle= arguments[@"title"];
        NSString* musicDescription= arguments[@"description"];
        NSString* musicDataUrl= arguments[@"musicDataUrl"];
        WXMediaMessage* message =[WXMediaMessage message];
        message.title = musicTitle;
        message.description =musicDescription;
        NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        [message setThumbImage:[UIImage imageWithData:data]];
        WXMusicObject* musicObject = [WXMusicObject object];
        musicObject.musicUrl =musicUrl;
        musicObject.musicDataUrl = musicDataUrl;
        message.mediaObject = musicObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.bText = NO;
        req.scene = type==0?WXSceneSession:WXSceneTimeline;
        [WXApi sendReq:req];
    }else if([@"shareVideo" isEqualToString:call.method]){
        NSString* videoUrl= arguments[@"videoUrl"];
        NSString* imgUrl= arguments[@"imgUrl"];
        NSString* videoTitle= arguments[@"title"];
        NSString* videoDescription= arguments[@"description"];
        WXMediaMessage* message =[WXMediaMessage message];
        message.title = videoTitle;
        message.description =videoDescription;
        NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        [message setThumbImage:[UIImage imageWithData:data]];
        WXVideoObject* musicObject = [WXVideoObject object];
        musicObject.videoUrl =videoUrl;
        
        message.mediaObject = musicObject;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.message = message;
        req.bText = NO;
        req.scene = type==0?WXSceneSession:WXSceneTimeline;
        [WXApi sendReq:req];
    }else if([@"login" isEqualToString:call.method]){
        NSString* scope= arguments[@"scope"];
        NSString* state= arguments[@"state"];
        SendAuthReq* req =[[SendAuthReq alloc] init];
        req.scope = scope;
        req.state = state;

        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }else if([@"pay" isEqualToString:call.method]){
        PayReq *request = [[PayReq alloc] init];
        NSString* partnerId= arguments[@"partnerId"];
        NSString* prepayId= arguments[@"prepayId"];
        NSString* package= arguments[@"package"];
        NSString* nonceStr= arguments[@"nonceStr"];
        NSString* time= arguments[@"timeStamp"];
        NSString* sign= arguments[@"sign"];
        request.partnerId = partnerId;
        request.prepayId= prepayId;
        request.package = package;
        request.nonceStr= nonceStr;
        request.timeStamp= [time intValue];;
        request.sign = sign;
        [WXApi sendReq:request];
    }
}
-(BOOL)handleOpenURL:(NSNotification *)aNotification
{
    NSString * aURLString =  [aNotification userInfo][@"url"];
    NSURL * aURL = [NSURL URLWithString:aURLString];
    if ([WXApi handleOpenURL:aURL delegate:self])
    {
        return YES;
    } else {
        return NO;
    }
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
         res([NSString stringWithFormat:@"%d",resp.errCode]);
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *r = (SendAuthResp *)resp;
        if (r.errCode == WXSuccess)
        {
           res(r.code);
        }else{
            res([NSString stringWithFormat:@"%d",r.errCode]);
        }
    } else if ([resp isKindOfClass:[PayResp class]]) {
        res([NSString stringWithFormat:@"%d",resp.errCode]);
    }
}
@end
