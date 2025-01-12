import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: LoadingAnimation(),
        ),
      ),
    );
  }
}

class LoadingAnimation extends StatefulWidget {
  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _textController;
  late AnimationController _colorController;

  final List<Color> _colors = [
    Color(0xFF00BCD4), // Cyan
    Color(0xFF3F51B5), // Indigo
    Color(0xFF9C27B0), // Purple
    Color(0xFFE91E63), // Pink
  ];

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _colorController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _textController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([
            _rotationController,
            _pulseController,
            _colorController
          ]),
          builder: (context, child) {
            final currentColor = ColorTween(
              begin: _colors[0],
              end: _colors[1],
            ).evaluate(_colorController)!;

            final nextColor = ColorTween(
              begin: _colors[2],
              end: _colors[3],
            ).evaluate(_colorController)!;

            return Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(
                  color: currentColor.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: nextColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dış halka
                  Transform.rotate(
                    angle: _rotationController.value * 2 * math.pi,
                    child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(12, (index) {
                        final double angle = 2 * math.pi * (index / 12);
                        final double size = 8 + 4 * _pulseController.value;
                        return Transform.translate(
                          offset: Offset(
                            60 * math.cos(angle),
                            60 * math.sin(angle),
                          ),
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [currentColor, nextColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: nextColor.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  
                  // İç halka
                  Transform.rotate(
                    angle: -_rotationController.value * 2 * math.pi,
                    child: Stack(
                      alignment: Alignment.center,
                      children: List.generate(8, (index) {
                        final double angle = 2 * math.pi * (index / 8);
                        final double size = 6 + 3 * _pulseController.value;
                        return Transform.translate(
                          offset: Offset(
                            35 * math.cos(angle),
                            35 * math.sin(angle),
                          ),
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [nextColor, currentColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: currentColor.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Merkez yazı
                  Text(
                    'AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: currentColor.withOpacity(0.8),
                          blurRadius: 15,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 20),
        // Alt yazı
        AnimatedBuilder(
          animation: _textController,
          builder: (context, child) {
            return Text(
              'Processing',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4 + _textController.value * 0.6),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.white.withOpacity(_textController.value * 0.5),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
