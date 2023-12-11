# Vietmap Flutter GL - Flutter map SDK
[<img src="https://bizweb.dktcdn.net/100/415/690/themes/804206/assets/logo.png?1689561872933" height="40"/> </p>](https://bit.ly/vietmap-api)


Liên hệ với [vietmap.vn](https://bit.ly/vietmap-api) để đăng ký API key miễn phí.

## Bắt đầu

Thêm thư viện vào file pubspec.yaml
```yaml
  vietmap_flutter_gl: latest_version
```

Kiểm tra phiên bản mới nhất tại [https://pub.dev/packages/vietmap_flutter_gl](https://pub.dev/packages/vietmap_flutter_gl)
 
hoặc chạy lệnh sau trong terminal để thêm thư viện vào project:
```bash
  flutter pub add vietmap_flutter_gl
```
## Cấu hình Android


Thêm mã sau vào tệp build.gradle (project) tại đường dẫn: **android/build.gradle**

```gradle
 maven { url "https://jitpack.io" }
```


tại khối repositories


```gradle

  allprojects {
      repositories {
          google()
          mavenCentral()
          maven { url "https://jitpack.io" }
      }
  }
```
Nâng minSdkVersion lên tối thiểu là 24 trong tệp build.gradle (app) tại đường dẫn **android/app/build.gradle**
```gradle
  minSdkVersion 24
```
## Cấu hình iOS
Thêm các mã sau vào tệp Info.plist.
```ruby
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
  <string>Nhập mô tả yêu cầu vị trí của bạn</string>
	<key>NSLocationAlwaysUsageDescription</key>
  <string>Nhập mô tả yêu cầu vị trí của bạn</string>
	<key>NSLocationWhenInUseUsageDescription</key>
  <string>Nhập mô tả yêu cầu vị trí của bạn</string>
```

Nâng cấp phiên bản iOS lên tối thiểu 12.0 trong tệp Podfile (iOS), tại đường dẫn **ios/Podfile** (bỏ comment dòng bên dưới)

```ruby
  platform :ios, '12.0'
```

## Các chức năng chính

### Hiển thị bản đồ
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


## Tương tác với bản đồ
SDK Maps Flutter của VietmapGL cho phép bạn xác định các tương tác có thể kích hoạt trên bản đồ để theo dõi cử chỉ và sự kiện trên bản đồ. Các tương tác sau được hỗ trợ

### Zoom Controls
Bản đồ hỗ trợ phóng to và thu nhỏ bằng cử chỉ ghim và vuốt hai ngón tay để thay đổi cấp độ phóng to cũng như nhấp đúp để phóng to vào. Đặt zoom thành 4 để hiển thị ở cấp độ quốc gia và 18 để hiển thị số nhà. Trong SDK này, vị trí camera đóng vai trò quan trọng

Và các hoạt động sau có thể được thực hiện bằng cách sử dụng CameraPosition

#### Target
Target là tọa độ duy nhất của vĩ độ và kinh độ mà camera tập trung vào. Thay đổi mục tiêu của camera sẽ di chuyển camera đến tọa độ đã nhập. Mục tiêu là một đối tượng LatLng. Tọa độ mục tiêu _luôn ở giữa viewport_. 

#### Tilt
Tilt là góc của camera so với phương nadir (trực tiếp hướng về Trái đất) và sử dụng đơn vị là độ. Góc nghiêng tối thiểu (mặc định) của camera là 0 độ và góc nghiêng tối đa là 60 độ. Các cấp độ góc nghiêng sử dụng sáu chữ số sau dấu thập phân, giúp bạn hạn chế/đặt/đóng băng phương diện bearing của một bản đồ với độ chính xác cực kỳ cao.

Camera bản đồ có thể điều chỉnh góc nghiêng bằng cách đặt hai đầu ngón tay lên bản đồ và di chuyển cả hai đầu ngón tay lên và xuống cùng một lúc 

#### Bearing
Hướng di chuyển đại diện cho hướng mà camera đang hướng tới và được đo bằng độ **theo chiều kim đồng hồ từ phía bắc**.

Hướng mặc định của camera là 0 độ (tức là "chính bắc") khiến cho la bàn bản đồ ẩn đi cho đến khi hướng của camera trở thành giá trị khác không. Các cấp độ hướng sử dụng sáu chữ số sau dấu thập phân, giúp bạn hạn chế/đặt/đóng băng hướng của một bản đồ với độ chính xác cực kỳ cao. Ngoài việc điều chỉnh hướng camera theo chương trình, người dùng cũng có thể đặt hai đầu ngón tay lên bản đồ và xoay đầu ngón tay của họ.

#### Zoom
Zoom kiểm soát tỷ lệ của bản đồ và tiêu thụ giá trị nằm giữa 0 và 22. Ở cấp độ phóng to 0, viewport hiển thị các châu lục và các đặc điểm khác trên thế giới. Giá trị trung bình là 11 sẽ hiển thị chi tiết ở cấp độ thành phố. Ở mức phóng to cao hơn, bản đồ sẽ bắt đầu hiển thị các tòa nhà và điểm đáng chú ý. Camera có thể phóng to theo các cách sau:

- Cử chỉ ghim hai ngón tay để phóng to và thu nhỏ.

- Nhấp nhanh hai lần vào bản đồ với một ngón tay để phóng to.

- Nhấp nhanh hai lần vào bản đồ với một ngón tay và giữ ngón tay xuống màn hình sau lần nhấp thứ hai.

- Sau đó di chuyển ngón tay lên để phóng to và xuống để thu nhỏ.
 
##### SDK cho phép nhiều phương thức để di chuyển và làm mờ camera đến một vị trí cụ thể:
~~~dart  
_mapController?.moveCamera(CameraUpdate.newLatLngZoom(LatLng(22.553147478403194, 77.23388671875), 14));  
_mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(28.698791, 77.121243), 14));  
~~~  

## Các sự kiện trên bản đồ
### Map Click/Long click

Nếu bạn muốn xử lý khi người dùng nhấp vào một điểm trên bản đồ, bạn có thể sử dụng hàm onMapClick.

Nó thiết lập một hàm callback được gọi khi người dùng nhấp vào bản đồ:
~~~dart  
VietmapGL(    
  initialCameraPosition: _kInitialPosition,    
  onMapClick: (point, latlng) =>{    
    print(latlng.toString())  
 }, )  
~~~  

##### Thiết lập một hàm callback được gọi khi người dùng nhấp và giữ lâu trên bản đồ.
~~~dart  
  VietmapGL(    
    initialCameraPosition: _kInitialPosition,    
    onMapLongClick: (point, latlng) =>{    
      print(latlng.toString())  
  }, )  
~~~  

##### Thiết lập một hàm callback được gọi khi bản đồ được hiển thị hoàn toàn.
##### Khuyến khích sử dụng hàm callback này để thực hiện một số hành động thay cho initState, những hàm sử dụng sau khi bản đồ đã được tải hoàn toàn để tránh crash app.
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
### Thêm marker (widget/hình ảnh trên bản đồ), marker không quay theo hướng bản đồ khi người dùng xoay bản đồ


```dart
  Stack(
    children: [
      VietmapGL(
        trackCameraPosition: true, // Sẽ theo dõi thay đổi bản đồ để cập nhật vị trí marker theo thời gian thực
        ...
        ),
      MarkerLayer(
        ignorePointer: true, // Sẽ bỏ qua tất cả các cử chỉ người dùng trên marker
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
  ])
    
```

### Thêm marker (widget/hình ảnh trên bản đồ), marker sẽ quay cùng bản đồ khi người dùng xoay bản đồ
- Đánh dấu tĩnh hỗ trợ xoay với đầu vào là bearing, bạn có thể tìm giá trị này khi lấy vị trí GPS.
- Gợi ý sử dụng marker này cho các ứng dụng định vị, theo dõi vị trí của tài xế. Khi đó xe của tài xế sẽ quay đúng hướng ngay cả khi người dùng quay bản đồ theo bất cứ góc nào.
```dart
  Stack(
    children: [
      VietmapGL(
        trackCameraPosition: true, // Sẽ theo dõi thay đổi bản đồ để cập nhật vị trí marker theo thời gian thực
        ...
        ),
      StaticMarkerLayer(
                ignorePointer: true, // Sẽ bỏ qua tất cả các cử chỉ người dùng trên marker
                mapController: _mapController!,
                markers: [
                    StaticMarker(
                        width: 50,
                        height: 50,
                        bearing: 0,
                        child: _markerWidget(Icons.arrow_downward_rounded),
                        latLng: LatLng(10.736657, 106.672240)),
                  ]),
  ])
```

#### Lưu ý: Bạn phải bật **trackCameraPosition: true**, ở **VietmapGL**, điều này đảm bảo rằng MarkerLayer hiển thị bình thường

- Đánh dấu hỗ trợ neo với đầu vào là alignment, cần truyền chiều rộng và chiều cao để tính vị trí của đánh dấu, mặc định cho cả hai là 20

- Đảm bảo rằng chiều rộng và chiều cao của marker bằng với chiều rộng và chiều cao của child để marker hiển thị chính xác

```dart
    Marker(
        width: 40,
        height:40,
        alignment: Alignment.bottomCenter,
        child: Icon(Icons.location_on, size:40),
        latLng: LatLng(10.792765, 106.674143)),
```
### Thêm a Line/Polyline (Vẽ đường nối 2 hoặc nhiều điểm trên bản đồ)

~~~dart  
    Line? line = await _mapController?.addPolyline(
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
### Update polyLine
```dart
    _mapController?.updatePolyline(
      line,
      PolylineOptions(
          geometry: [
            LatLng(10.736657, 106.672240),
            LatLng(10.766543, 106.742378),
            LatLng(10.775818, 106.640497),
            LatLng(10.727416, 106.735597),
            LatLng(10.792765, 106.674143),
            LatLng(10.736657, 106.672240),
          ],
          polylineColor: Colors.blue,
          polylineWidth: 14.0,
          polylineOpacity: 1,
          draggable: true),
    );
```

### Xoá một Polyline
~~~dart  
    _mapController?.removePolyline(line);  
~~~  

### Xoá tất cả Polyline
~~~dart
    _mapController?.clearLines();
~~~

### Thêm một Fill/Polygon (Vẽ đa giác nối 3 hoặc nhiều điểm trên bản đồ)
~~~dart  
    Polygon? = await _mapController?.addPolygon(
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
### Update Polygon
```dart
    _mapController?.updatePolygon(
      polygon,
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
          polygonColor: Colors.blue,
          polygonOpacity: 1,
          draggable: true),
    );
```
### Xoá một Polygon
~~~dart  
    _mapController?.removePolygon(polygon);  
~~~  

### Xoá tất cả Polygon
```dart
    _mapController?.clearPolygons();
```

### Tìm đường đi giữa 2 hoặc nhiều điểm
- Chúng tôi cung cấp package để tìm đường đi giữa 2 hoặc nhiều điểm, bạn có thể tìm package
[vietmap_flutter_plugin](https://pub.dev/packages/vietmap_flutter_plugin) để sử dụng nó.
- Chạy lệnh sau trong terminal để thêm thư viện vào project:
```bash
  flutter pub add vietmap_flutter_plugin
```

- Example code:
```dart
  List<LatLng> points = [];
  /// Tìm đường đi giữa 2 điểm
  var routingResponse = await Vietmap.routing(VietMapRoutingParams(points: [
    const LatLng(21.027763, 105.834160),
    const LatLng(21.027763, 105.834160)
  ]));

  /// Xử lý kết quả trả về
  routingResponse.fold((Failure failure) {
    // Xử lý lỗi nếu có
  }, (VietMapRoutingModel success) {
    if (success.paths?.isNotEmpty == true &&
        success.paths![0].points?.isNotEmpty == true) {
      /// import this [import 'package:vietmap_gl_platform_interface/vietmap_gl_platform_interface.dart';] package
      points =
          VietmapPolylineDecoder.decodePolyline(success.paths![0].points!);
    }
  });

  /// Vẽ đường đi lên bản đồ
  Line? line = await _mapController?.addPolyline(
    PolylineOptions(
        geometry: points,
        polylineColor: Colors.red,
        polylineWidth: 14.0,
        polylineOpacity: 0.5),
  );
```

<br>

# Troubleshooting
- SDK của chúng tôi **sử dụng Key để xác định các marker** và cập nhật vị trí của chúng khi người dùng thực hiện một số cử chỉ, vì vậy chúng tôi **đề xuất bạn thêm Key cho tất cả các widget** trong toàn bộ màn hình sử dụng SDK bản đồ:

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

Demo code [tại đây](./example/lib/main.dart)
## Lưu ý: Thay thế apikey được cung cấp bởi VietMap vào tất cả các thẻ  **_YOUR_API_KEY_HERE_**  để ứng dụng hoạt động bình thường

<br></br>
<br></br>

[<img src="https://bizweb.dktcdn.net/100/415/690/themes/804206/assets/logo.png?1689561872933" height="40"/> </p>](https://vietmap.vn/maps-api)
Email cho chúng tôi: [maps-api.support@vietmap.vn](mailto:maps-api.support@vietmap.vn)


Liên hệ [hỗ trợ](https://vietmap.vn/lien-he).

Tài liệu Vietmap API [tại đây](https://maps.vietmap.vn/docs/map-api/overview/).

Có lỗi cần báo cáo? [Open an issue](https://github.com/vietmap-company/flutter-map-sdk/issues). Nếu có thể, hãy đính kèm một bản log đầy đủ và thông tin của vấn đề.

Yêu cầu tính năng mới? [Open an issue](https://github.com/vietmap-company/flutter-map-sdk/issues). Hãy cho chúng tôi biết tính năng nên làm gì và tại sao bạn muốn tính năng đó.
