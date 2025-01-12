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
         child: AILoadingSpinner(),
       ),
     ),
   );
 }
}

class AILoadingSpinner extends StatefulWidget {
 @override
 _AILoadingSpinnerState createState() => _AILoadingSpinnerState();
}

class _AILoadingSpinnerState extends State<AILoadingSpinner>
   with TickerProviderStateMixin {
 late AnimationController _controller;
 late AnimationController _borderController;
 late AnimationController _textOpacityController;

 final List<Color> colors = [
   Colors.red,
   Colors.orange,
   Colors.yellow,
   Colors.green,
   Colors.blue,
   Colors.indigo,
   Colors.purple,
   Colors.pink,
 ];

 @override
 void initState() {
   super.initState();
   
   _controller = AnimationController(
     duration: const Duration(milliseconds: 2000),
     vsync: this,
   )..repeat();

   _borderController = AnimationController(
     duration: const Duration(milliseconds: 3000),
     vsync: this,
   )..repeat();

   _textOpacityController = AnimationController(
     duration: const Duration(milliseconds: 1500),
     vsync: this,
   )..repeat(reverse: true);
 }

 @override
 void dispose() {
   _controller.dispose();
   _borderController.dispose();
   _textOpacityController.dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return Column(
     mainAxisSize: MainAxisSize.min,
     children: [
       AnimatedBuilder(
         animation: Listenable.merge([_borderController, _controller, _textOpacityController]),
         builder: (context, child) {
           final borderColor = HSVColor.fromAHSV(
             1.0,
             (_borderController.value * 360),
             1.0,
             1.0,
           ).toColor();

           return Container(
             width: 150,
             height: 150,
             decoration: BoxDecoration(
               color: Colors.black,
               borderRadius: BorderRadius.circular(15),
               border: Border.all(
                 color: borderColor.withOpacity(0.7),
                 width: 2,
               ),
               boxShadow: [
                 BoxShadow(
                   color: borderColor.withOpacity(0.3),
                   blurRadius: 10,
                   spreadRadius: 2,
                 ),
               ],
             ),
             child: Stack(
               alignment: Alignment.center,
               children: [
                 // AI Yazısı
                 Text(
                   'AI',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 24,
                     fontWeight: FontWeight.bold,
                     shadows: [
                       Shadow(
                         color: Colors.white.withOpacity(0.5),
                         blurRadius: 10,
                         offset: Offset(0, 0),
                       ),
                     ],
                   ),
                 ),

                 // Dönen renkli toplar
                 Transform.rotate(
                   angle: _controller.value * 2 * math.pi,
                   child: Stack(
                     alignment: Alignment.center,
                     children: List.generate(
                       8,
                       (index) {
                         final double angle = 2 * math.pi * (index / 8);
                         return Transform.translate(
                           offset: Offset(
                             35 * math.cos(angle),
                             35 * math.sin(angle),
                           ),
                           child: Container(
                             width: 12,
                             height: 12,
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: colors[index],
                               boxShadow: [
                                 BoxShadow(
                                   color: colors[index].withOpacity(0.5),
                                   blurRadius: 5,
                                   spreadRadius: 1,
                                 ),
                               ],
                             ),
                           ),
                         );
                       },
                     ),
                   ),
                 ),
               ],
             ),
           );
         },
       ),
       SizedBox(height: 15), // Boşluk ekledim
       // Creating yazısı artık karenin altında
       AnimatedBuilder(
         animation: _textOpacityController,
         builder: (context, child) {
           return Text(
             'Creating',
             style: TextStyle(
               color: Colors.white.withOpacity(0.3 + _textOpacityController.value * 0.7),
               fontSize: 16,
               fontWeight: FontWeight.w500,
               shadows: [
                 Shadow(
                   color: Colors.white.withOpacity(_textOpacityController.value * 0.5),
                   blurRadius: 8,
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
