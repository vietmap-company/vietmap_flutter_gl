## 3.0.0, Sep 19, 2024
* Refactor `==` operator override 
* Fix `UserLocationLayer` icon not rotate on user tilt map.
* Allow custom `UserLocationLayer` pulse color & opacity.
* `Deprecated` default UserLocation icon, use `UserLocationLayer` instead.
* Migrate to Metal renderer on iOS
## 3.0.0-pre.5, Jul 23, 2024 
* Fix `UserLocationLayer` icon not rotate on user tilt map.
* Allow custom `UserLocationLayer` pulse color & opacity.
## 3.0.0-pre.4, Jul 22, 2024
* `Deprecated` default UserLocation icon, use `UserLocationLayer` instead.
## 3.0.0-pre.2, Jun 18, 2024
* Migrate to Metal renderer on iOS
## 3.0.0-pre.1, Jun 16, 2024
* Migrate to Metal renderer on iOS
## 2.2.1. Jun 10, 2024
* Upgrade `vietmap_flutter_plugin` to version `0.3.1`
## 2.2.0, Jun 10, 2024
* Upgrade `vietmap_gl_platform_interface` to version `0.2.0`
* Provide `VietMapSnapEngine`
* Create `Driver tracking` demo screen
## 2.1.0, Jun 5, 2024
* Deprecate `RouteSimulator.addListener` listener, use `RouteSimulator.addV2Listener` instead.
* Provide `recentLatLng` for `RouteSimulator.addV2Listener` listener, use for calculate heading angle of shipper/vehicle using `VietmapPolyline.calculateFinalBearing(previousLatLng, latLng)`.
## 2.0.3, May 24, 2024
* Upgrade `turf` library to version `0.0.10`
* Provide `Route Simulator Animation` for tracking driver/demo screen
* Update `README.md` document for `Route Simulator Animation`
## 2.0.2, May 21, 2024
* Upgrade VietMap android SDK
* Fix SDK crash on `armeabi-v7a` device
## 2.0.1, Apr 10, 2024
* Fix iOS plugin registrant.
## 2.0.0, Apr 9, 2024
* Upgrade to Vietmap Native SDK v2.0.0
## 2.0.0-beta-2, Jan 23, 2024
* Create animated polyline demo screen.
## 2.0.0-beta, Jan 23, 2024
* Created a new feature to ensure that the API key provided by Vietmap can only be used by the application(s) that register with our system.
* Add encrypted data for API key verification that cannot be used by 3rd parties without consent from Vietmap or your organization

## 1.3.9, Jan 31, 2024
* Add `rotateOrigin` offset and fix `alignment` in `StaticMarkerLayer`

## 1.3.8, Jan 10, 2024
* Update `README.md` document
* Fix android `LocationComponents` overloads
## 1.3.7, Jan 08, 2024
* Update `README.md` document
## 1.3.6, Jan 04, 2024
* Fix the map not keep annotation when change map style
## 1.3.5, Jan 04, 2024
* Upgrade `vietmap_gl_platform_interface` to version `0.1.5`
* Provide `setStyle` function to set map style
## 1.3.4, Dec 18, 2023
* Upgrade `vietmap_gl_platform_interface` to version `0.1.4`
* Fix `VietmapPolylineDecoder` `encode` and `decode` function
* Fix draw polyline below the road name
## 1.3.3, Dec 15, 2023
* Provide query `Point` from tile map with `queryRenderedFeatures` function inside `VietmapMapController` class
## 1.3.2, Dec 11, 2023
* Provide `nearestLatLngOnLine` and `splitRouteByLatLng` function inside `VietmapPolyline` class, which help show shipper/vehicle location on route and remove route traveled by shipper/vehicle.
* `splitRouteByLatLng` will split route into 2 parts, which are `routeBeforeLatLng` and `routeAfterLatLng`, you can use one of them to to update the route of shipper/vehicle traveled.
* Create `VietmapPolyline` class to handle more complex polyline
## 1.3.1, Dec 05, 2023
* Add document for `StaticMarkerLayer` and `StaticMarker`
## 1.3.0, Nov 28, 2023
* Calculate `StaticMarker` angle when user rotate the map
## 1.2.7, Nov 27, 2023
* Fix `StaticMarkerLayer` render 
## 1.2.5, Nov 23, 2023
* Fix `StaticMarkerLayer` render
* Fix bearing anchor display not correct
* Cập nhật tài liệu `tiếng Việt`
* Update `README.md` document
## 1.2.4, Nov 22, 2023
* Add new `StaticMarkerLayer` and `StaticMarker` to render static marker, which rotate with the map when user rotate the map
## 1.2.2, Nov 21, 2023
* Update iOS configuration
## 1.2.1, Nov 15, 2023
* Fix android map style
## 1.2.0, Nov 15, 2023
* Update version` 2.0.0` of android and ios native map sdk
## 1.1.8, Nov 14, 2023
* Fix white screen error when app to background and back to foreground
## 1.1.7, Sep 25, 2023
* Update `README.md` document
* Update map style url
## 1.1.6, Sep 25, 2023
* Fix duplicate marker when add new marker to marker layer
## 1.1.5, Sep 25, 2023
* Fix marker render when add new marker to marker layer
## 1.1.4, Sep 25, 2023
* Disable customize marker key when add new marker to marker layer
## 1.1.3, Aug 24, 2023
* Fix memory leaks when add new marker/remove marker from marker layer
## 1.1.2, Aug 24, 2023
* Remove unnecessary library
## 1.1.1, Aug 24, 2023
* Add recenter map function
## 1.1.0, Aug 16, 2023
* Update readme document
## 1.0.9, Aug 16, 2023
* Update readme document
## 1.0.8, Aug 14, 2023
* Fix warning on load drawable image
## 1.0.7, Aug 10, 2023
* Fix `MarkerLayer` keep state when clear all markers from list
## 1.0.6, Aug 10, 2023
* Fix crash app when enable location tracking on android
* Fix `MarkerLayer` dispose

## 1.0.5, Aug 9, 2023
* Fix `onMapRendered` callback
## 1.0.4, Aug 9, 2023
* Fix crash app when enable location tracking on android
* Add `onMapRendered` callback
## 1.0.3, Aug 8, 2023
* Fix crash app when update marker location
## 1.0.2, Aug 2, 2023
* Remove unnecessary code
## 1.0.1, Aug 2, 2023
* Fix `MarkerLayer` render
* Allow user to set marker icon align with screen position
* Allow user to set marker icon size
## 1.0.0, Aug 2, 2023
* Release v1.0.0 version
* Fix ux when add new marker to marker layer
## 0.2.1, Aug 2, 2023
* Update README.md document
## 0.2.0, Aug 1, 2023
* fix marker layer on iOS
## 0.1.7, Aug 1, 2023
* config iOS map
## 0.1.6, Aug 1, 2023
* fix platform interface
## 0.1.5, Aug 1, 2023
* fix platform interface
## 0.1.4, Aug 1, 2023
* Refactor string color to Flutter Color
* Optimize marker layer
* Add new class to set marker icon
* Create new sample app
## 0.1.3, July 28, 2023
* refactor native sdk 