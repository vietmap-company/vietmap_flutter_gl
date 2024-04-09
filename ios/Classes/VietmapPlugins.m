#import "VietmapPlugins.h"
#import "vietmap_flutter_gl/vietmap_flutter_gl-Swift.h"

@implementation VietmapPlugins
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVietmapGlFlutterPlugin registerWithRegistrar:registrar];
}
@end
