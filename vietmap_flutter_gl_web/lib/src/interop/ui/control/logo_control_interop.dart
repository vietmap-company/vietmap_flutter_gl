@JS('vietmapgl')
library vietmap.interop.ui.control.logo_control;

import 'package:js/js.dart';
import 'package:vietmap_flutter_gl_web/src/interop/ui/map_interop.dart';

/// A LogoControl is a control that adds the watermark.
///
/// @implements {IControl}
/// @private
@JS('LogoControl')
class LogoControlJsImpl {
  external factory LogoControlJsImpl();

  external onAdd(VietmapGLJsImpl map);

  external onRemove();

  external getDefaultPosition();
}
