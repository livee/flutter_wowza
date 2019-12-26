#import "WowzaStreamPlugin.h"
#import "WowzaStreamPlugin-Swift.h"

@implementation WowzaStreamPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWowzaStreamPlugin registerWithRegistrar:registrar];
}
@end
