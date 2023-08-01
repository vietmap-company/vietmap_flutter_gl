# Vietmap Flutter Map GL

Vietmap Flutter Map GL

Liên hệ [vietmap.vn](https://bit.ly/vietmap-api) để đăng kí key hợp lệ.

## Getting started

Thêm thư viện vào file pubspec.yaml
```yaml
  vietmap_flutter_gl: latest_version
```

Kiểm tra phiên bản của thư viện tại [https://pub.dev/packages/vietmap_flutter_gl](https://pub.dev/packages/vietmap_flutter_gl)
 
hoặc chạy lệnh sau để thêm thư viện vào project:
```bash
  flutter pub add vietmap_flutter_gl
```
## Cấu hình cho Android


Thêm đoạn code sau vào build.gradle (project) tại đường dẫn **android/build.gradle**

```gradle
 maven { url "https://jitpack.io" }
```


như sau


```gradle

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url "https://jitpack.io" }
    }
}
```


## Cấu hình cho iOS
Thêm đoạn code sau vào file Info.plist
```
	<key>VietMapAPIBaseURL</key>
	<string>https://maps.vietmap.vn/api/navigations/route/</string>
	<key>VietMapAccessToken</key>
	<string>YOUR_API_KEY_HERE</string>
	<key>VietMapURL</key>
	<string>https://run.mocky.io/v3/ff325d44-9fdd-480f-9f0f-a9155bf362fa</string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>This app requires location permission to working normally</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>This app requires location permission to working normally</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>This app requires location permission to working normally</string>
```


## Các tính năng chính

Hiển thị bản đồ nền 
```dart 
    VietmapGL(
      styleString:
          'https://run.mocky.io/v3/06602373-c116-41cc-9af6-1ce0dc7807ae',
      initialCameraPosition:
          CameraPosition(target: LatLng(10.762317, 106.654551)),
      onMapCreated: (VietmapController controller) {
          setState(() {
            _mapController = controller;
          });
        },
    );
```

Thêm marker với đầu vào là Flutter widget 
```dart
    MarkerLayer(
      ignorePointer: true,
      mapController: _mapController!,
      markers: [
            Marker(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      'Simple text marker',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                latLng: LatLng(10.727416, 106.735597)),
            Marker(
                child: Icon(Icons.location_on),
                latLng: LatLng(10.792765, 106.674143)),
      ])
```
Các hàm thường sử dụng
```dart 
    // Thêm polyline
    _mapController?.addPolyline(
      PolylineOptions(
          geometry: [
            LatLng(10.736657, 106.672240),
            LatLng(10.766543, 106.742378),
            LatLng(10.775818, 106.640497),
            LatLng(10.727416, 106.735597),
            LatLng(10.792765, 106.674143),
            LatLng(10.736657, 106.672240),
          ],
          polylineColor: Colors.red,
          polylineWidth: 14.0,
          polylineOpacity: 0.5,
          draggable: true),
    );
    // Thêm polygon
    _mapController?.addPolygon(
      PolygonOptions(
          geometry: [
            [
              LatLng(10.736657, 106.672240),
              LatLng(10.766543, 106.742378),
              LatLng(10.775818, 106.640497),
              LatLng(10.727416, 106.735597),
              LatLng(10.792765, 106.674143),
              LatLng(10.736657, 106.672240),
            ]
          ],
          polygonColor: Colors.red,
          polygonOpacity: 0.5,
          draggable: true),
    );
```

Code mẫu màn hình bản đồ [tại đây](./example/lib/main.dart)
# Lưu ý: Thay apikey được VietMap cung cấp vào toàn bộ tag _YOUR_API_KEY_HERE_ để ứng dụng hoạt động bình thường
