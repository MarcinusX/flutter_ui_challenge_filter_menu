import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedFab extends StatefulWidget {
  final VoidCallback onClick;

  const AnimatedFab({Key key, this.onClick}) : super(key: key);

  @override
  _AnimatedFabState createState() => new _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  final double expandedSize = 180.0;
  final double hiddenSize = 20.0;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation = new ColorTween(begin: Colors.pink, end: Colors.pink[800])
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: expandedSize,
      height: expandedSize,
      child: new AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildExpandedBackground(),
              _buildOption(Icons.check_circle, 0.0),
              _buildOption(Icons.flash_on, -math.pi / 3),
              _buildOption(Icons.access_time, -2 * math.pi / 3),
              _buildOption(Icons.error_outline, math.pi),
              _buildFabCore(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOption(IconData icon, double angle) {
    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = 26.0 * (_animationController.value - 0.8) * 5;
    }
    return new Transform.rotate(
      angle: angle,
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Padding(
          padding: new EdgeInsets.only(top: 8.0),
          child: new IconButton(
            onPressed: _onIconClick,
            icon: new Transform.rotate(
              angle: -angle,
              child: new Icon(
                icon,
                color: Colors.white,
              ),
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: new EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedBackground() {
    double size =
        hiddenSize + (expandedSize - hiddenSize) * _animationController.value;
    return new Container(
      height: size,
      width: size,
      decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
    );
  }

  Widget _buildFabCore() {
    double scaleFactor = 2 * (_animationController.value - 0.5).abs();
    return new FloatingActionButton(
      onPressed: _onFabTap,
      child: new Transform(
        alignment: Alignment.center,
        transform: new Matrix4.identity()..scale(1.0, scaleFactor),
        child: new Icon(
          _animationController.value > 0.5 ? Icons.close : Icons.filter_list,
          color: Colors.white,
          size: 26.0,
        ),
      ),
      backgroundColor: _colorAnimation.value,
    );
  }

  open() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  close() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  _onFabTap() {
    if (_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

  _onIconClick() {
    widget.onClick();
    close();
  }
}

//import 'package:flutter/material.dart';
//
//import 'dart:math' as math;
//
//class FilterFab extends StatefulWidget {
//  final ValueNotifier<bool> filterValueNotifier;
//
//  const FilterFab({Key key, this.filterValueNotifier}) : super(key: key);
//
//  @override
//  State<StatefulWidget> createState() {
//    return new FilterFabState();
//  }
//}
//
//class FilterFabState extends State<FilterFab>
//    with SingleTickerProviderStateMixin {
//  AnimationController animationController;
//  Animation<double> animation;
//  Animation<Color> colorAnimation;
//
//  final double expandedSize = 180.0;
//  final double hiddenSize = 20.0;
//
//  @override
//  void initState() {
//    super.initState();
//    animationController = new AnimationController(
//        vsync: this, duration: Duration(milliseconds: 200));
//    animation = new CurvedAnimation(
//        parent: animationController, curve: Curves.easeInOut);
//    colorAnimation = new ColorTween(begin: Colors.pink, end: Colors.pink[800])
//        .animate(animationController);
//  }
//
//  @override
//  void dispose() {
//    animationController.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new SizedBox(
//      width: expandedSize,
//      height: expandedSize,
//      child: new AnimatedBuilder(
//          animation: animation,
//          builder: (context, child) {
//            return new Stack(
//              alignment: Alignment.center,
//              children: <Widget>[
//                _buildExpandedBackground(),
//                buildOption(Icons.check_circle, 0.0),
//                buildOption(Icons.flash_on, -math.pi / 3),
//                buildOption(Icons.access_time, -2 * math.pi / 3),
//                buildOption(Icons.error_outline, math.pi),
//                _buildFabCore(),
//              ],
//            );
//          }),
//    );
//  }
//
//  open() {
//    if (animationController.isDismissed) {
//      animationController.forward();
//    }
//  }
//
//  close() {
//    if (animationController.isCompleted) {
//      animationController.reverse();
//    }
//  }
//
//  _onFabTap() {
//    if (animation.isDismissed) {
//      open();
//    } else {
//      close();
//    }
//  }
//
//  _onItemTap() {
//    widget.filterValueNotifier.value = !widget.filterValueNotifier.value;
//    close();
//  }
//
//  Widget _buildExpandedBackground() {
//    return new Container(
//      height: hiddenSize + (expandedSize - hiddenSize) * animation.value,
//      width: hiddenSize + (expandedSize - hiddenSize) * animation.value,
//      decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
//    );
//  }
//
//  Widget _buildFabCore() {
//    double defaultIconSize = 26.0;
//    double scaleFactor = 2 * (animationController.value - 0.5).abs();
//    return new FloatingActionButton(
//      onPressed: _onFabTap,
//      backgroundColor: colorAnimation.value,
//      child: new Center(
//        child: new Transform(
//          alignment: Alignment.center,
//          transform: new Matrix4.identity()..scale(1.0, scaleFactor),
//          child: new Icon(
//            animationController.value > 0.5 ? Icons.close : Icons.filter_list,
//            color: Colors.white,
//            size: defaultIconSize,
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget buildOption(IconData icon, double angle) {
//    double iconSize = 0.0;
//    if (animation.value > 0.5) {
//      iconSize = 26 * animation.value;
//    }
//    double defaultPadding = 16.0;
//    double padding = defaultPadding +
//        (expandedSize - defaultPadding) * (1 - animation.value);
//    return new Transform.rotate(
//      angle: angle,
//      child: new Align(
//        alignment: Alignment.topCenter,
//        child: new Padding(
//          padding: new EdgeInsets.only(top: padding),
//          child: new IconButton(
//            onPressed: _onItemTap,
//            icon: new Transform.rotate(
//              angle: -angle,
//              child: new Icon(
//                icon,
//                color: Colors.white,
//              ),
//            ),
//            iconSize: iconSize,
//            alignment: Alignment.topCenter,
//            padding: new EdgeInsets.all(0.0),
//          ),
//        ),
//      ),
//    );
//  }
//}
