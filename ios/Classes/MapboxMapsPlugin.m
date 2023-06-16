#import "MapboxMapsPlugin.h"
#import "vietmap_flutter_gl/vietmap_flutter_gl-Swift.h"

@implementation MapboxMapsPlugin 
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMapboxGlFlutterPlugin registerWithRegistrar:registrar];
}
@end
