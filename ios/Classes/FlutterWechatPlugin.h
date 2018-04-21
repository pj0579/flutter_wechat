#import <Flutter/Flutter.h>
#include "WXApi.h"
@interface FlutterWechatPlugin : NSObject<FlutterPlugin,WXApiDelegate,FlutterStreamHandler>

@end
