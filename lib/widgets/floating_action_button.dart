import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/widgets/new_item.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  
  final String tooltip;
  final IconData icon;
  final DataModel dataModel;
  FancyFab({this.onPressed, this.tooltip, this.icon,this.dataModel});

  @override
  _FancyFabState createState() =>
      _FancyFabState(dataModel:dataModel);
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
final DataModel dataModel;

_FancyFabState({this.dataModel});
  bool isOpened = false;
  static AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButtonx;
  Animation<double> _translateButtony;

  final formKey = GlobalKey<FormState>();
  Curve _curve = Curves.easeOut;
  double _fabEnd = 10.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin:  Colors.blue,
      end: Colors.blue,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    //x direction flow
    _translateButtonx = Tween<double>(
      begin: 5000.0,
      end: _fabEnd,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    //y direction flow
    _translateButtony = Tween<double>(
      begin: -14.0,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget form() {
    return NewItem(animationController:_animationController,dataModel: dataModel,);
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Add',
        child: AnimatedIcon(
          icon: AnimatedIcons.add_event,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            _translateButtonx.value,
            _translateButtony.value,
            0.0,
          ),
          child: form(),
        ),
        toggle(),
      ],
    );
  }
}
