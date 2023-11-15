# Vietmap Flutter GL
[<img src="https://bizweb.dktcdn.net/100/415/690/themes/804206/assets/logo.png?1689561872933" height="40"/> </p>](https://vietmap.vn/maps-api)


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
Chỉnh minSdkVersion về 24 trong file build.gradle (app) tại đường dẫn **android/app/build.gradle**
```gradle
  minSdkVersion 24
```
## Cấu hình cho iOS
Thêm đoạn code sau vào file Info.plist
```
	<key>VietMapAPIBaseURL</key>
	<string>https://maps.vietmap.vn/api/navigations/route/</string>
	<key>VietMapAccessToken</key>
	<string>YOUR_API_KEY_HERE</string>
	<key>VietMapURL</key>
	<string>https://maps.vietmap.vn/api/maps/light/styles.json?apikey=YOUR_API_KEY_HERE</string>
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
          'https://maps.vietmap.vn/api/maps/light/styles.json?apikey=YOUR_API_KEY_HERE',
      initialCameraPosition:
          CameraPosition(target: LatLng(10.762317, 106.654551)),
      onMapCreated: (VietmapController controller) {
          setState(() {
            _mapController = controller;
          });
        },
    );
```


## Map Interactions
VietmapGL Maps Flutter SDK cho phép bạn định nghĩa các tương tác mà bạn có thể kích hoạt trên bản đồ để kích hoạt các sự kiện cử chỉ và nhấp chuột. Các tương tác sau được hỗ trợ:
### Zoom Controls

Bản đồ hỗ trợ cử chỉ hai ngón tay quen thuộc và thu phóng để thay đổi cấp độ thu phóng cũng như nhấp đúp để phóng to. Đặt thu phóng thành 4 để hiển thị cấp độ quốc gia và 18 để hiển thị số nhà. Trong SDK này, CameraPosition (vị trí hiển thị của bản đồ trên màn hình) đóng một vai trò quan trọng

Và các hoạt động sau có thể được thực hiện bằng cách sử dụng CameraPosition

#### Target

Mục tiêu là một tọa độ vĩ độ và kinh độ duy nhất mà bản đồ hiển thị tại đó. Thay đổi mục tiêu của máy ảnh sẽ di chuyển máy ảnh đến các tọa độ được nhập. Mục tiêu là một đối tượng LatLng. Tọa độ mục tiêu luôn _ở giữa khung nhìn_.

#### Tilt

Tilt là góc của máy ảnh từ trạng thái thẳng đứng từ trên xuống (đối diện trực tiếp với Trái đất) và sử dụng đơn vị độ. Góc nghiêng tối thiểu (mặc định) của máy ảnh là 0 độ và góc nghiêng tối đa là 60. Các cấp độ nghiêng sử dụng sáu chữ số thập phân, cho phép bạn hạn chế / đặt / khóa phương vị của bản đồ với độ chính xác cực đại.

Bản đồ máy ảnh có thể điều chỉnh góc nghiêng bằng cách đặt hai ngón tay lên bản đồ và di chuyển cả hai ngón tay lên và xuống song song cùng một lúc hoặc

#### Bearing
Bearing giải thích hướng mà máy ảnh đang chỉ vào và được đo bằng độ _theo chiều kim đồng hồ từ phía bắc_.

Mặc định của máy ảnh là 0 độ (tức là "phía bắc") khiến cho la bàn bản đồ bị ẩn cho đến khi phương vị máy ảnh trở thành một giá trị khác 0. Các cấp độ mang sáu chữ số thập phân, cho phép bạn hạn chế / đặt / khóa phương vị của bản đồ với độ chính xác cực đại. Ngoài việc điều chỉnh phương vị máy ảnh theo chương trình, người dùng cũng có thể đặt hai ngón tay lên bản đồ và xoay ngón tay của họ.

#### Zoom

Zoom điều khiển tỷ lệ của bản đồ và nhận vào bất kỳ giá trị nào giữa 0 và 22. Ở cấp độ thu phóng 0, khung nhìn hiển thị các lục địa và các đại dương. Giá trị trung bình của 11 sẽ hiển thị chi tiết cấp thành phố. Ở mức thu phóng cao hơn, bản đồ sẽ bắt đầu hiển thị các tòa nhà và các điểm đến. Máy ảnh có thể thu phóng theo các cách sau:

- Chạm 2 ngón tay để thu phóng vào và ra.
- Nhấp nhanh hai lần vào bản đồ bằng một ngón tay để phóng to.
- Nhấp nhanh hai lần vào bản đồ bằng một ngón tay và giữ ngón tay của bạn xuống màn hình sau lần nhấp thứ hai.
- Sau đó, trượt ngón tay lên để thu phóng ra và xuống để thu phóng ra.
#### SDK cho phép nhiều phương pháp để di chuyển Camera đến một vị trí cụ thể:
~~~dart  
_mapController?.moveCamera(CameraUpdate.newLatLngZoom(LatLng(22.553147478403194, 77.23388671875), 14));  
_mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(28.698791, 77.121243), 14));  
~~~  

## Map Events
### Map Click/Long click

Nếu bạn muốn phản hồi khi người dùng nhấp vào một điểm trên bản đồ, bạn có thể sử dụng một callback onMapClick.
Nó thiết lập một callback được gọi khi người dùng nhấp vào bản đồ:
~~~dart  
VietmapGL(    
  initialCameraPosition: _kInitialPosition,    
  onMapClick: (point, latlng) =>{    
    print(latlng.toString())  
 }, )  
~~~  

##### Thiết lập một callback được gọi khi người dùng nhấp vào bản đồ:
~~~dart  
VietmapGL(    
  initialCameraPosition: _kInitialPosition,    
  onMapLongClick: (point, latlng) =>{    
    print(latlng.toString())  
 }, )  
~~~  

##### Thiết lập một callback được gọi khi bản đồ được hiển thị hoàn toàn.
##### Khuyến khích sử dụng callback này để thực hiện các thao tác trên bản đồ lúc khởi tạo:
~~~dart  
VietmapGL(    
  initialCameraPosition: _kInitialPosition,    
  onMapRenderedCallback: () {
            _mapController?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(10.739031, 106.680524),
                    zoom: 10,
                    tilt: 60)));
    },
  )  
~~~  
## Map Overlays
### Thêm một Marker (Đánh dấu một điểm trên bản đồ)

Thêm marker với đầu vào là Flutter widget 
```dart
  Stack(
    children: [
      VietmapGL(
        _trackCameraPosition: true_,
        ...
        ),
      MarkerLayer
        ignorePointer: true, // đặt là true nếu bạn chỉ hiển thị marker mà không muốn nhận sự kiện click
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
        ]
  ])
    
```
#### Lưu ý: Để MarkerLayer hoạt động, bạn cần phải thêm _trackCameraPosition: true_, vào _VietmapGL_

### Thêm một Polyline (Đường thẳng nối các điểm trên bản đồ)
Vẽ một polyline lên bản đồ
~~~dart  
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
~~~  

### Xoá một Polyline
Để xoá một polyline trên bản đồ, bạn có thể sử dụng phương thức removePolyline() của VietmapController.
~~~dart  
_mapController?.removePolyline(line);  
~~~  

### Thêm một Polygon (Đa giác trên bản đồ)
Vẽ một polygon lên bản đồ
~~~dart  
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
~~~  

### Xoá một Polygon
~~~dart  
_mapController?.removePolygon(polygon);  
~~~  

<br>

### Lưu ý

 - Các Widget khác khi thêm vào Widget Stack chứa MarkerLayer đều phải thêm thuộc tính *key* để tránh gặp lỗi trong quá trình hiển thị MarkerLayer, ví dụ:
 ```dart
 Stack(
  children:[
    MarkerLayer(
      ...
    ),
    Positioned(
      key: const Key('yourWidgetKey'),
      ...
    ),
  ]
 )
 ```

Code mẫu màn hình bản đồ [tại đây](./example/lib/main.dart)
# Lưu ý: Thay apikey được VietMap cung cấp vào toàn bộ tag _YOUR_API_KEY_HERE_ để ứng dụng hoạt động bình thường

<br></br>
<br></br>

Nếu có bất kỳ thắc mắc và hỗ trợ, vui lòng liên hệ:

[<img src="https://bizweb.dktcdn.net/100/415/690/themes/804206/assets/logo.png?1689561872933" height="40"/> </p>](https://vietmap.vn/maps-api)
Gửi email: [maps-api.support@vietmap.vn](mailto:maps-api.support@vietmap.vn)


Liên hệ [hỗ trợ](https://vietmap.vn/lien-he)

Tài liệu api [tại đây](https://maps.vietmap.vn/docs/map-api/overview/)