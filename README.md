# Vietmap Flutter GL - Flutter map SDK
[<img src="https://bizweb.dktcdn.net/100/415/690/themes/804206/assets/logo.png?1689561872933" height="40"/> </p>](https://bit.ly/vietmap-api)


Contact [vietmap.vn](https://bit.ly/vietmap-api) to register a valid key.

## Getting started

Add library to pubspec.yaml file
```yaml
  vietmap_flutter_gl: latest_version
```

Check the latest version at [https://pub.dev/packages/vietmap_flutter_gl](https://pub.dev/packages/vietmap_flutter_gl)
 
or run this command in the terminal to add the library to the project:
```bash
  flutter pub add vietmap_flutter_gl
```
## Android config


Add the below code to the build.gradle (project) file at path: **android/build.gradle**

```gradle
 maven { url "https://jitpack.io" }
```


at the repositories block


```gradle

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url "https://jitpack.io" }
    }
}
```
Upgrade the minSdkVersion to a minimum is 24 in the build.gradle (app) file, at path **android/app/build.gradle**
```gradle
  minSdkVersion 24
```
## iOS config
Add the below codes to the Info.plist file. Replace your API key to **YOUR_API_KEY_HERE** 
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


## Main characteristics

### Show the map
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
The VietmapGL Maps Flutter SDK allows you to define interactions that you can activate on the map to enable gestures and click events. The following interactions are supported

### Zoom Controls
The map supports the familiar two-finger pinch and zooms to change the zoom level as well as double tap to zoom in. Set zoom to 4 for country-level display and 18 for house number display. In this SDK the camera position plays an important role

And following operations can be performed using the CameraPosition

#### Target
The target is single latitude and longitude coordinate that the camera centers it on. Changing the camera's target will move the camera to the inputted coordinates. The target is a LatLng object. The target coordinate is always _at the center of the viewport_.


#### Tilt
Tilt is the camera's angle from the nadir (directly facing the Earth) and uses unit degrees. The camera's minimum (default) tilt is 0 degrees, and the maximum tilt is 60. Tilt levels use six decimal points of precision, which enables you to restrict/set/lock a map's bearing with extreme precision.

The map camera tilt can also adjust by placing two fingertips on the map and moving both fingers up and down in parallel at the same time or

#### Bearing
Bearing represents the direction that the camera is pointing in and is measured in degrees  _clockwise from north_.

The camera's default bearing is 0 degrees (i.e. "true north") causing the map compass to hide until the camera bearing becomes a non-zero value. Bearing levels use six decimal point precision, which enables you to restrict/set/lock a map's bearing with extreme precision. In addition to programmatically adjusting the camera bearing, the user can place two fingertips on the map and rotate their fingers.

#### Zoom
Zoom controls the scale of the map and consumes any value between 0 and 22. At zoom level 0, the viewport shows continents and other world features. A middle value of 11 will show city-level details. At a higher zoom level, the map will begin to show buildings and points of interest. The camera can zoom in the following ways:

- Pinch motion two fingers to zoom in and out.
- Quickly tap twice on the map with a single finger to zoom in.
- Quickly tap twice on the map with a single finger and hold your finger down on the screen after the second tap.
- Then slide the finger up to zoom out and down to zoom out.

##### SDK allows various methods to move, and animate the camera to a particular location :
~~~dart  
_mapController?.moveCamera(CameraUpdate.newLatLngZoom(LatLng(22.553147478403194, 77.23388671875), 14));  
_mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(28.698791, 77.121243), 14));  
~~~  

## Map Events
### Map Click/Long click

If you want to respond to a user tapping on a point on the map, you can use an onMapClick callback.

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

##### Sets a callback that's invoked when the map is completely rendered.
##### Encourage this callback to call some action on the initial, after the map is completely loaded
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
### Add a Marker (Marked a point in the map with a custom widget)

```dart
  Stack(
    children: [
      VietmapGL(
        trackCameraPosition: true, // Will track the map change to update the marker position in realtime
        ...
        ),
      MarkerLayer
        ignorePointer: true, // Will ignore all user gestures on the marker
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
#### Note: You must enable _trackCameraPosition: true_, at _VietmapGL_, which ensured the MarkerLayer renders normally
- The marker support anchor with input is an alignment, which required width and height to calculate the position of the marker, the default for both of them is 20
- Make sure your width and height are correct to the marker display exactly
```dart
    Marker(
        width: 40,
        height:40,
        alignment: Alignment.bottomCenter,
        child: Icon(Icons.location_on, size:40),
        latLng: LatLng(10.792765, 106.674143)),
```
### Add a Line/Polyline (A line connects 2 points on the map)

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
~~~dart  
    _mapController?.removePolyline(line);  
~~~  

### Remove all Polyline
~~~dart
    _mapController?.clearLines();
~~~

### Add a Fill/Polygon
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

### Remove all Polygon
```dart
    _mapController?.clearPolygons();
```


<br>

# Troubleshooting
- Our SDK uses the key to identify the markers and update their location while the user does some gestures, so we strongly recommend you add the key for all of the widgets in the screen which use the map SDK:
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

Demo code [here](./example/lib/main.dart)
# Note: Replace apikey which is provided by VietMap to all _YOUR_API_KEY_HERE_ tag to the application work normally

<br></br>
<br></br>

[<img src="https://bizweb.dktcdn.net/100/415/690/themes/804206/assets/logo.png?1689561872933" height="40"/> </p>](https://vietmap.vn/maps-api)
Email us: [maps-api.support@vietmap.vn](mailto:maps-api.support@vietmap.vn)


Contact for [support](https://vietmap.vn/lien-he)

Vietmap API document [here](https://maps.vietmap.vn/docs/map-api/overview/)

Have a bug to report? [Open an issue](https://github.com/vietmap-company/flutter-map-sdk/issues). If possible, include a full log and information which shows the issue.
Have a feature request? [Open an issue](https://github.com/vietmap-company/flutter-map-sdk/issues). Tell us what the feature should do and why you want the feature.

[Tài liệu tiếng Việt](./README.vi.md)