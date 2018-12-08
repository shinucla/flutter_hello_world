import 'package:flutter/material.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override Widget build(BuildContext context)
  {
    return MaterialApp( title: 'My First App',
                        home: HelloWorldWidget());
  }
}

class HelloWorldState extends State<HelloWorldWidget>
  with SingleTickerProviderStateMixin
{
  bool pressed = false;
  String text = 'Hello World!';

  bool toggled = false;
  AnimationController _animationController;
  Animation<Color> _toggleBtnColor;
  Animation<double> _toggleAniIcon;
  Animation<double> _translateButton;

  @override initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    )
    ..addListener(() { setState(() {}); })
    ;

    _toggleAniIcon = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _toggleBtnColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0, 1, curve: Curves.linear)
    ));
    _translateButton = Tween<double>(
      begin: 56,  // float btn icon height
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0, 0.75, curve: Curves.easeOut)
    ));
    super.initState();
  }

  @override dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override Widget build(BuildContext context)
  {
    return Scaffold( appBar: AppBar( title: Text('app bar title')),
                     body: Center( child: Text(text)),
                     floatingActionButton: Column(
                       //crossAxisAlignment: CrossAxisAlignment.end,
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: <Widget>[
                         Transform(
                           transform: Matrix4.translationValues(0, _translateButton.value * 2, 0),
                           child: _switchText()
                         ),
                         Transform(
                           transform: Matrix4.translationValues(0, _translateButton.value * 1, 0),
                           child: _stream()
                         ),
                         _toggle()]
                     )
                   );
  }

  Widget _switchText() {
    return Container(
      child: FloatingActionButton(
        onPressed: updateText,
        tooltip: 'Update Text',
        child: Icon(Icons.update),
      ),
    );
  }

  Widget _stream() {
    return Container(
      child: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Streaming',
        child: Icon(Icons.cloud_download),
      ),
    );
  }

  Widget _toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _toggleBtnColor.value,
        onPressed: () => _animate(),
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _toggleAniIcon,
        ),
      ),
    );
  }

  _animate() {
    if (!toggled) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    toggled = !toggled;
  }

  void updateText()
  {
    if (pressed) {
      text = 'Hello Pressed On';
    } else {
      text = 'Hello Pressed Off';
    }

    setState(() {
      pressed = !pressed;
    });
  }
}

class HelloWorldWidget extends StatefulWidget { // StatelessWidget
  @override HelloWorldState createState() => new HelloWorldState();
}
