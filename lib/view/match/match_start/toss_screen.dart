import 'dart:math';
import 'package:cricketly/constant/colors.dart';
import 'package:cricketly/model/match/get_team_player_model.dart';
import 'package:cricketly/view/match/match_start/select_player_screen.dart';
import 'package:cricketly/widgtes/appbar.dart';
import 'package:cricketly/widgtes/button.dart';
import 'package:flutter/material.dart';

class TossScreen extends StatefulWidget {
  final TeamInfo teamA;
  final TeamInfo teamB;
  final bool isUpdate;
  final Map<String, dynamic> matchInfo;

  const TossScreen({
    super.key,
    required this.matchInfo,
    required this.teamA,
    required this.teamB,
    required this.isUpdate,
  });

  @override
  TossScreenState createState() => TossScreenState();
}

class TossScreenState extends State<TossScreen> {
  late bool _showFrontSide;
  double _distanceFromBottom = 100;
  bool _isActive = false;
  String _face = '';
  final List<String> faces = ['heads', 'tails'];
  String cartoon = '';
  double _textOpacity = 0;
  final int _flip_duration = 1800;

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
  }

  void _restart() {
    setState(() {
      _distanceFromBottom = 110;
      _textOpacity = 0.0;
      _isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BuildAppBar(
              onTap: () {
                Navigator.pop(context);
              },
              title: 'Toss',
            ),
            AnimatedPositioned(
              duration: const Duration(seconds: 2),
              curve: Curves.bounceOut,
              bottom: _distanceFromBottom,
              top: size.height * 0.1,
              right: size.width * 0.31,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: _flip_duration),
                transitionBuilder: __transitionBuilder,
                switchOutCurve: Curves.easeIn.flipped,
                child: _showFrontSide ? _buildHeads() : _buildTails(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.1),
              child: Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: _textOpacity,
                  child: Text(
                    _face.toUpperCase(),
                    style: const TextStyle(
                      color: ConstColors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.01, 0.8),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _textOpacity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton2(
                      buttonText: 'Restart',
                      onPressed: _restart,
                      minWidth: size.width / 2,
                    ),
                    SizedBox(height: size.height * 0.02),
                    MaterialButton2(
                      buttonText: 'Continue',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectPlayerScreen(
                              matchInfo: widget.matchInfo,
                              teamA: widget.teamA,
                              teamB: widget.teamB,
                              isUpdate: widget.isUpdate,
                            ),
                          ),
                        );
                      },
                      minWidth: size.width / 2,
                    ),
                    SizedBox(height: size.height * 0.1),
                  ],
                ),
              ),
            ),
            !_isActive
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          if (details.delta.dy > 0 && !_isActive) {
                            _isActive = true;
                            _flipCoin('heads');
                          }
                          if (details.delta.dy < 0 && !_isActive) {
                            _isActive = true;
                            _flipCoin('tails');
                          }
                        },
                        onTap: () {
                          if (!_isActive) {
                            _isActive = true;
                            int faceIndex = Random().nextInt(faces.length);
                            _flipCoin(faces[faceIndex]);
                          }
                        },
                        child: Container(
                          width: size.width / 2,
                          height: size.height * 0.06,
                          decoration: const BoxDecoration(
                              color: ConstColors.appGreen8FColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Center(
                            child: Text(
                              'Toss'.toUpperCase(),
                              style: const TextStyle(
                                color: ConstColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

//--------------------------------------------------------------- Button actions ---------------------------------------------------------------//
  void _flipCoin(String face) async {
    setState(() {
      _distanceFromBottom = MediaQuery.of(context).size.height / 3;
      _showFrontSide = !_showFrontSide;
      _face = face;
    });
    Future.delayed(const Duration(milliseconds: 3000)).then((value) {
      setState(() {
        _textOpacity = 1.0;
      });
    });
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi * 12, end: 0.0).animate(animation);

    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.01;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value * 16, pi / 2) : rotateAnim.value;
        if (_face == 'heads') {
          return Transform(
            transform: (Matrix4.rotationX(value)),
            alignment: Alignment.center,
            child: (rotateAnim.value < 0.5 ||
                    value > 1.4 && value < 1.5 ||
                    (value > pi / 4 && value < pi / 2) ||
                    (value > pi * 3 && value < pi * 4) ||
                    (value > pi * 5 && value < pi * 6) ||
                    (value > pi * 8 && value < pi * 9))
                ? _buildHeads()
                : _buildTails(),
          );
        } else {
          return Transform(
            transform: (Matrix4.rotationX(value)),
            alignment: Alignment.center,
            child: (rotateAnim.value < 1 ||
                    value > 1.4 && value < 1.5 ||
                    (value > pi / 4 && value < pi / 2) ||
                    (value > pi * 3 && value < pi * 4) ||
                    (value > pi * 5 && value < pi * 6) ||
                    (value > pi * 8 && value < pi * 9))
                ? _buildTails()
                : _buildHeads(),
          );
        }
      },
    );
  }

  Widget _buildHeads() {
    return __buildLayout(
      key: const ValueKey(true),
      faceName: "Heads",
    );
  }

  Widget _buildTails() {
    return __buildLayout(
      key: const ValueKey(false),
      faceName: "Tails",
    );
  }

  Widget __buildLayout({required Key key, required String faceName}) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      shadowColor: Colors.blue,
      elevation: 10,
      key: key,
      child: SizedBox(
        height: 150,
        child: Center(
          child: faceName == "Heads"
              ? Image.asset('assets/images/svg/${cartoon}heads.png')
              : Image.asset('assets/images/svg/${cartoon}tails.png'),
        ),
      ),
    );
  }
}
