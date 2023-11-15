part of vietmap_flutter_gl;

class MarkerWidget extends StatefulWidget {
  final Point initialPosition;
  final LatLng coordinate;
  final void Function(MarkerState) addMarkerState;
  final Widget child;
  final double width;
  final double height;
  final Alignment alignment;
  MarkerWidget(
      {required String key,
      required this.coordinate,
      required this.initialPosition,
      required this.addMarkerState,
      required this.child,
      required this.width,
      this.alignment = Alignment.center,
      required this.height})
      : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = MarkerState(initialPosition);
    addMarkerState(state);
    return state;
  }
}

class MarkerState extends State with TickerProviderStateMixin {
  Point _position;

  MarkerState(this._position);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ratio = 1.0;

    //web does not support Platform._operatingSystem
    if (!kIsWeb) {
      // iOS returns logical pixel while Android returns screen pixel
      ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
    }
    var _leftPosition = 0.0;
    var _topPosition = 0.0;
    var width = (widget as MarkerWidget).width;
    var height = (widget as MarkerWidget).height;
    if ((widget as MarkerWidget).alignment == Alignment.center) {
      _leftPosition = width / 2;
      _topPosition = height / 2;
    } else if ((widget as MarkerWidget).alignment == Alignment.topLeft) {
      _leftPosition = 0;
      _topPosition = 0;
    } else if ((widget as MarkerWidget).alignment == Alignment.topRight) {
      _leftPosition = width;
      _topPosition = 0;
    } else if ((widget as MarkerWidget).alignment == Alignment.bottomLeft) {
      _leftPosition = 0;
      _topPosition = height;
    } else if ((widget as MarkerWidget).alignment == Alignment.bottomRight) {
      _leftPosition = width;
      _topPosition = height;
    } else if ((widget as MarkerWidget).alignment == Alignment.centerLeft) {
      _leftPosition = 0;
      _topPosition = height / 2;
    } else if ((widget as MarkerWidget).alignment == Alignment.centerRight) {
      _leftPosition = width;
      _topPosition = height / 2;
    } else if ((widget as MarkerWidget).alignment == Alignment.topCenter) {
      _leftPosition = width / 2;
      _topPosition = 0;
    } else if ((widget as MarkerWidget).alignment == Alignment.bottomCenter) {
      _leftPosition = width / 2;
      _topPosition = height;
    }

    return Positioned(
        left: _position.x / ratio - _leftPosition,
        top: _position.y / ratio - _topPosition,
        child: getChild());
  }

  void updatePosition(Point<num> point) {
    if (!mounted) return;
    setState(() {
      _position = point;
    });
  }

  LatLng getCoordinate() {
    return (widget as MarkerWidget).coordinate;
  }

  Widget getChild() {
    return (widget as MarkerWidget).child;
  }
}
