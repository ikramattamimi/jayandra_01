import 'package:flutter/material.dart';

class AnimatedCard extends StatefulWidget {
  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });

    if (_isVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: toggleVisibility,
          child: Text(_isVisible ? 'Hide' : 'Show'),
        ),
        SizedBox(height: 16),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: Transform.translate(
                offset: Offset(0, (1 - _animation.value) * 100),
                child: child,
              ),
            );
          },
          child: _isVisible
              ? Card(
                  child: Container(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Text('Animated Card'),
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}