package vn.vietmap.vietmapgl;

import android.content.Context;
import vn.vietmap.vietmapsdk.Vietmap;


abstract class VietmapUtils {
  private static final String TAG = "VietmapGLController";

  static Vietmap getVietMapGL(Context context) {
    return Vietmap.getInstance(context);
  }
}
