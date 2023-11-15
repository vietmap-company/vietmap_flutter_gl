# Vietmap Flutter Map GL

[<img src="https://bizweb.dktcdn.net/100/415/690/themes/804206/assets/logo.png?1689561872933" height="40"/> </p>](https://vietmap.vn/maps-api)

Contact [vietmap.vn](https://bit.ly/vietmap-api) to register a valid key.

## Getting started

Add library to file pubspec.yaml
```yaml
  vietmap_flutter_gl: latest_version
```

Check the latest version from [https://pub.dev/packages/vietmap_flutter_gl](https://pub.dev/packages/vietmap_flutter_gl)
 
or run this bash in terminal to add library:
```bash
  flutter pub add vietmap_flutter_gl
```
## Android config


Add below code to build.gradle (project) from this path **android/build.gradle**

```gradle
 maven { url "https://jitpack.io" }
```


like this


```gradle

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url "https://jitpack.io" }
    }
}
```


## iOS config
Add this code to file Info.plist,replace your apikey to **YOUR_API_KEY_HERE** 
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


## Features

Show map with VietmapGL widget
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


Add a Marker with input is a Flutter widget
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

## Map Interactions
The VietmapGL Maps Flutter SDK allows you to define interactions that you can activate on the map to enable gestures and click events. The following interactions are supported –

### Zoom Controls
The map supports the familiar two-finger pinch and zooms to change zoom level as well as double tap to zoom in. Set zoom to 4 for country level display and 18 for house number display. In this SDK the camera position plays an important role

And following operations can be performed using the CameraPosition

#### Target
The target is single latitude and longitude coordinate that the camera centers it on. Changing the camera's target will move the camera to the inputted coordinates. The target is a LatLng object. The target coordinate is always _at the center of the viewport_.


#### Tilt
Tilt is the camera's angle from the nadir (directly facing the Earth) and uses unit degrees. The camera's minimum (default) tilt is 0 degrees, and the maximum tilt is 60. Tilt levels use six decimal point of precision, which enables you to restrict/set/lock a map's bearing with extreme precision.

The map camera tilt can also adjust by placing two fingertips on the map and moving both fingers up and down in parallel at the same time or

#### Bearing
Bearing represents the direction that the camera is pointing in and measured in degrees  _clockwise from north_.

The camera's default bearing is 0 degrees (i.e. "true north") causing the map compass to hide until the camera bearing becomes a non-zero value. Bearing levels use six decimal point precision, which enables you to restrict/set/lock a map's bearing with extreme precision. In addition to programmatically adjusting the camera bearing, the user can place two fingertips on the map and rotate their fingers.

#### Zoom
Zoom controls scale of the map and consumes any value between 0 and 22. At zoom level 0, viewport shows continents and other world features. A middle value of 11 will show city level details.At a higher zoom level, map will begin to show buildings and points of interest. Camera can zoom in following ways:

- Pinch motion two fingers to zoom in and out.
- Quickly tap twice on the map with a single finger to zoom in.
- Quickly tap twice on the map with a single finger and hold your finger down on the screen after the second tap.
- Then slide the finger up to zoom out and down to zoom out.

##### Sdk allows various method to Move, ease,animate Camera to a particular location :
~~~dart  
_mapController?.moveCamera(CameraUpdate.newLatLngZoom(LatLng(22.553147478403194, 77.23388671875), 14));  
_mapController?.easeCamera(CameraUpdate.newLatLngZoom(LatLng(28.704268, 77.103045), 14));  
_mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(28.698791, 77.121243), 14));  
~~~  

## Map Events
### Map Click/Long click
If you want to respond to a user tapping on a point on the map, you can use a onMapClick callback.

It sets a callback that's invoked when the user clicks on the map:
~~~dart  
VietmapGL(    
  initialCameraPosition: _kInitialPosition,    
  onMapClick: (point, latlng) =>{    
    print(latlng.toString())  
 }, )  
~~~  

##### Sets a callback that's invoked when the user long clicks on the map view.
~~~dart  
VietmapGL(    
  initialCameraPosition: _kInitialPosition,    
  onMapLongClick: (point, latlng) =>{    
    print(latlng.toString())  
 }, )  
~~~  


## Map Overlays


### Add a Polyline
Draw a polyline on Map
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

### Remove a Polyline
To remove polyline from Map
~~~dart  
_mapController?.removePolyline(line);  
~~~  

### Add a Polygon
Draw a polygon on the map:
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

### Remove a Polygon
~~~dart  
_mapController?.removePolygon(polygon);  
~~~  

<br>


Code mẫu màn hình bản đồ [tại đây](./example/lib/main.dart)
# Lưu ý: Thay apikey được VietMap cung cấp vào toàn bộ tag _YOUR_API_KEY_HERE_ để ứng dụng hoạt động bình thường

<br></br>
<br></br>
For any queries and support, please contact:

Email us at [support@vietmap.vn](mailto:support@vietmap.vn)


[Support](https://vietmap.vn/lien-he)
Need support? contact us!