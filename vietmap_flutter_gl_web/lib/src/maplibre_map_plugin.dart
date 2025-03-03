part of '../vietmap_flutter_gl_web.dart';

class VietMapGLPlugin {
  /// Registers this class as the default instance of [VietmapGlPlatform].
  static void registerWith(Registrar registrar) {
    VietmapGlPlatform.createInstance = () => VietmapController();
  }
}
