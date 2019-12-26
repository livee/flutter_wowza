#import "WowzaStreamPlugin.h"
#import "Runner-Swift.h"

@implementation WowzaStreamPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWowzaStreamPlugin registerWithRegistrar:registrar];
}
@end
