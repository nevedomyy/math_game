import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(MathGame());

class MathGame extends StatefulWidget{
  @override
  _MathGame createState() => _MathGame();
}

class _MathGame extends State<MathGame> with TickerProviderStateMixin{
  AnimationController _controller;
  Animation _animation;
  String _flareAnimation = 'bottom';
  List<Color> _colors;
  List<String> _icons;
  List<List<String>> _numbers;
  List<int> _buttons;
  List<Function> _taps;
  List<List<String>> _passw;
  String _passwCur;
  int _level;
  int _currentBtn;
  int _currentTxt;
  bool _done = false;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn
    );
    _level = 0;
    _colors = List();
    _colors.add(Colors.white);
    _colors.add(Color.fromRGBO(39, 174, 97, 1.0));
    _colors.add(Color.fromRGBO(42, 128, 185, 1.0));
    _colors.add(Color.fromRGBO(143, 68, 173, 1.0));
    _colors.add(Color.fromRGBO(193, 57, 43, 1.0));
    _colors.add(Color.fromRGBO(243, 156, 17, 1.0));
    _icons = List();
    _icons.add('assets/star.png');
    _icons.add('assets/plus.png');
    _icons.add('assets/minus.png');
    _icons.add('assets/multiply.png');
    _icons.add('assets/divide.png');
    _icons.add('assets/equal.png');
    _numbers = List(3);
    _numbers[0] = ['6','2','3','4','1','5','24','3','8'];
    _numbers[1] = ['2','12','14','8','5','3','6','7','42'];
    _numbers[2] = ['4','15','60','2','3','5','6','18','12'];
    _buttons = List(12);
    _buttons = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    _passw = List(3);
    _passw[0]= ['455151545253','535151545253','453151555253','533151555253','453151555245','533151555245','455151545245','535151545245'];
    _passw[1]= ['522235155535',];
    _passw[2]= ['355155225352',];
    _taps = List();
    for(var i = 0; i < 12; i++){
      _taps.add((){
        setState(() {
          _passwCur = '';
          _done = false;
          switch(i){
            case 0: case 2: case 7: _flareAnimation = 'left'; break;
            case 1: case 4: case 9: _flareAnimation = 'right'; break;
            default: _flareAnimation = 'bottom';
          }
          if (_buttons[i] == 5){_buttons[i] = 0;}
          else _buttons[i]++;
          for(var i = 0; i < 12; i++){
            _passwCur = _passwCur + _buttons[i].toString();
          }
          for(String item in _passw[_level]){
            if (_passwCur == item){_done = true; break;}
          }
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next(){
    setState(() {
      _level++;
      if (_level == 3) _level = 0;
      for(var i = 0; i < 12; i++){_buttons[i] = 0;}
      _done = false;
      _controller.reset();
    });
  }

  Widget _btn(){
    _currentBtn++;
   return GestureDetector(
      onTap: _taps[_currentBtn],
      child: Container(
        padding: EdgeInsets.only(top: 5.0, left: 5.0),
        child: CircleAvatar(
          radius: 25.0,
          backgroundColor: _colors[_buttons[_currentBtn]],
             child: ImageIcon(AssetImage(_icons[_buttons[_currentBtn]]), color: Colors.black54, size: 30.0,)
        ),
      ),
    );
  }

  Widget _txt(){
    _currentTxt++;
    return Container(
      padding: EdgeInsets.only(top: 5.0, left: 5.0),
      child: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.white70,
        child: Text(_numbers[_level][_currentTxt], style: TextStyle(color: Colors.black54, fontSize: 25.0),),
      ),
    );
  }

  Widget _blank(){
    return Container(
      padding: EdgeInsets.only(top: 5.0, left: 5.0),
      child: CircleAvatar(
        radius: 25.0,
        backgroundColor: Color.fromRGBO(190, 195, 199, 1.0),
      ),
    );
  }

  Widget _row(Widget w1, Widget w2, Widget w3, Widget w4, Widget w5){
    return FadeTransition(
      opacity: _animation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          w1, w2, w3, w4, w5,
          SizedBox(width: 5.0,)
        ],
      ),
    );
  }

  Widget _rowDone(){
    if (!_done) return SizedBox(height: 30.0);
    return SizedBox(
      height: 30.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'done!',
            style: TextStyle(color: Colors.blue, fontSize: 20.0),
          ),
          FlatButton(
            child: Text(
              'NEXT',
              style: TextStyle(color: Colors.blue, fontSize: 20.0),
            ),
            onPressed: _next,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    _currentBtn = -1;
    _currentTxt = -1;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(190, 195, 199, 1.0),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: FlareActor(
                    'assets/man.flr',
                    alignment: Alignment.center,
                    animation: _flareAnimation,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              _rowDone(),
              SizedBox(height: 10.0,),
              _row(_txt(), _btn(), _txt(), _btn(), _txt()),
              _row(_btn(), _blank(), _btn(), _blank(), _btn()),
              _row(_txt(), _btn(), _txt(), _btn(), _txt()),
              _row(_btn(), _blank(), _btn(), _blank(), _btn()),
              _row(_txt(), _btn(), _txt(), _btn(), _txt()),
              SizedBox(height: 20.0,),
            ],
          ),
        ),
      ),
    );
  }
}