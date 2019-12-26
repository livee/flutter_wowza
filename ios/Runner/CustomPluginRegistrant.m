
#import "CustomPluginRegistrant.h"
#import "CustomPluginRegistrant.h"

#if __has_include("WowzaStreamPlugin.h")
#import "WowzaStreamPlugin.h"
#else
@import WowzaStreamPlugin;
#endif

@implementation CustomPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [WowzaStreamPlugin registerWithRegistrar:[registry registrarForPlugin:@"WowzaStreamPlugin"]];
}

@end
