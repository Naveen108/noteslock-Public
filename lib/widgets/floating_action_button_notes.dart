import 'package:flutter/material.dart';
import 'package:noteslock/data/data.dart';
import 'package:noteslock/widgets/new_item_notes.dart';

class FancyFabNote extends StatefulWidget {
  final Function() onPressed;
  final scaffoldKey;
  final String tooltip;
  final IconData icon;
  final DataModel dataModel;
  FancyFabNote({this.onPressed, this.tooltip, this.icon,this.dataModel,this.scaffoldKey});

  @override
  _FancyFabNoteState createState() =>
      _FancyFabNoteState(dataModel:dataModel,scaffoldKey:scaffoldKey);
}

class _FancyFabNoteState extends State<FancyFabNote>
    with SingleTickerProviderStateMixin {
final DataModel dataModel;
  final scaffoldKey;
_FancyFabNoteState({this.dataModel,this.scaffoldKey});
  bool isOpened = false;
  static AnimationController _animationControllerNote;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButtonx;
  Animation<double> _translateButtony;

  final formKey = GlobalKey<FormState>();
  Curve _curve = Curves.easeOut;
  double _fabEnd = 10.0;

  @override
  initState() {
    _animationControllerNote =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationControllerNote);
    _buttonColor = ColorTween(
      begin:  Colors.blue,
      end: Colors.blue,
    ).animate(CurvedAnimation(
      parent: _animationControllerNote,
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
      parent: _animationControllerNote,
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
      parent: _animationControllerNote,
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
    _animationControllerNote.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationControllerNote.forward();
    } else {
      _animationControllerNote.reverse();
    }
    isOpened = !isOpened;
  }

  Widget form() {
    if(DataModel.currentBook.bookId!=null){
    return NewItemNote(animationControllerNote:_animationControllerNote,dataModel: dataModel,);}
    else{
      
      //  final snackbar = SnackBar(
      //       content: Text('You need to create a book or select one'),
      //     );
      //     scaffoldKey.currentState.showSnackBar(snackbar);
        return Text('You need to create a book or select one');
    }
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
