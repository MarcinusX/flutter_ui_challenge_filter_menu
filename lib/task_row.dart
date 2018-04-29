import 'package:filter_menu/task.dart';
import 'package:flutter/material.dart';

class TaskRow extends StatefulWidget {
  final double speedFactor;
  final ValueNotifier<bool> showCompletedNotifier;
  final Task task;

  const TaskRow(
      {Key key, this.showCompletedNotifier, this.task, this.speedFactor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new TaskRowState();
  }
}

class TaskRowState extends State<TaskRow> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  bool shouldBeShown;
  VoidCallback onFilterChanged;

  @override
  void initState() {
    super.initState();
    shouldBeShown = widget.task.finished || !widget.showCompletedNotifier.value;
    animationController = new AnimationController(
        value: shouldBeShown ? 1.0 : 0.0,
        vsync: this,
        duration: new Duration(
            milliseconds: (200 * (1 + 2 * widget.speedFactor)).toInt()));
    animation = new CurvedAnimation(
        parent: animationController, curve: Curves.easeInOut);
    onFilterChanged = () {
      bool shouldOnlyCompletedBeShown = widget.showCompletedNotifier.value;
      bool shouldThisBeShown =
          widget.task.finished || !shouldOnlyCompletedBeShown;
      if (shouldThisBeShown != shouldBeShown) {
        if (shouldThisBeShown) {
          animationController
              .forward()
              .then((_) => setState(() => shouldBeShown = shouldThisBeShown));
        } else {
          animationController
              .reverse()
              .then((_) => setState(() => shouldBeShown = shouldThisBeShown));
        }
      }
    };
    widget.showCompletedNotifier.addListener(onFilterChanged);
  }

  @override
  void dispose() {
    animationController.dispose();
    widget.showCompletedNotifier.removeListener(onFilterChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dotSize = 12.0;
    return new AnimatedBuilder(
      animation: animation,
      builder: (context, child) => new Opacity(
            opacity: animation.value,
            child: new SizeTransition(
              sizeFactor: animation,
              child: new Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: new Row(
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.symmetric(
                          horizontal: 32.0 - dotSize / 2),
                      child: new Container(
                        height: dotSize,
                        width: dotSize,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle, color: widget.task.color),
                      ),
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          widget.task.name,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        new Text(
                          widget.task.category,
                          style:
                              new TextStyle(fontSize: 12.0, color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
