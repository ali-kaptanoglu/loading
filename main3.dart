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
         child: FuturisticLoader(),
       ),
     ),
   );
 }
}

class FuturisticLoader extends StatefulWidget {
 @override
 _FuturisticLoaderState createState() => _FuturisticLoaderState();
}

class _FuturisticLoaderState extends State<FuturisticLoader>
   with TickerProviderStateMixin {
 late AnimationController _mainController;
 late AnimationController _pulseController;
 late AnimationController _waveController;
 late AnimationController _glowController;

 final List<Color> mainColors = [
   Color(0xFF4A90E2), // Mavi
   Color(0xFF9B59B6), // Mor
   Color(0xFF2ECC71), // Yeşil
 ];

 @override
 void initState() {
   super.initState();
   
   _mainController = AnimationController(
     duration: const Duration(milliseconds: 3000),
     vsync: this,
   )..repeat();

   _pulseController = AnimationController(
     duration: const Duration(milliseconds: 1500),
     vsync: this,
   )..repeat(reverse: true);

   _waveController = AnimationController(
     duration: const Duration(milliseconds: 2000),
     vsync: this,
   )..repeat();

   _glowController = AnimationController(
     duration: const Duration(milliseconds: 4000),
     vsync: this,
   )..repeat();
 }

 @override
 void dispose() {
   _mainController.dispose();
   _pulseController.dispose();
   _waveController.dispose();
   _glowController.dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return Column(
     mainAxisSize: MainAxisSize.min,
     children: [
       Container(
         width: 200,
         height: 200,
         child: Stack(
           alignment: Alignment.center,
           children: [
             // Arkadaki dalga efekti
             ...List.generate(3, (index) {
               return AnimatedBuilder(
                 animation: _waveController,
                 builder: (context, child) {
                   return Transform.scale(
                     scale: 1 + (_waveController.value + index / 3) % 1 * 0.3,
                     child: Container(
                       width: 160,
                       height: 160,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         border: Border.all(
                           color: mainColors[index].withOpacity(
                               1 - (_waveController.value + index / 3) % 1),
                           width: 2,
                         ),
                       ),
                     ),
                   );
                 },
               );
             }),

             // Ana hexagon şekli
             AnimatedBuilder(
               animation: Listenable.merge([_mainController, _pulseController]),
               builder: (context, child) {
                 return Transform.rotate(
                   angle: _mainController.value * 2 * math.pi,
                   child: CustomPaint(
                     size: Size(120, 120),
                     painter: HexagonPainter(
                       colors: mainColors,
                       progress: _pulseController.value,
                     ),
                   ),
                 );
               },
             ),

             // İç parıltı efekti
             AnimatedBuilder(
               animation: _glowController,
               builder: (context, child) {
                 return Container(
                   width: 80,
                   height: 80,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     gradient: RadialGradient(
                       colors: [
                         Colors.white.withOpacity(0.2 + _glowController.value * 0.2),
                         Colors.transparent,
                       ],
                     ),
                   ),
                 );
               },
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
                     color: Colors.white.withOpacity(0.8),
                     blurRadius: 10,
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
       SizedBox(height: 20),
       // Altdaki yazılar
       _buildLoadingText(),
     ],
   );
 }

 Widget _buildLoadingText() {
   return AnimatedBuilder(
     animation: _pulseController,
     builder: (context, child) {
       return Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           'S', 'Y', 'S', 'T', 'E', 'M'
         ].asMap().entries.map((entry) {
           final int idx = entry.key;
           final String char = entry.value;
           final double delay = idx * 0.1;
           final double opacity = 0.3 + 
               math.sin((_pulseController.value * 2 * math.pi + delay) % math.pi) * 0.7;
           
           return Text(
             char,
             style: TextStyle(
               color: Colors.white.withOpacity(opacity),
               fontSize: 18,
               fontWeight: FontWeight.bold,
               letterSpacing: 4,
               shadows: [
                 Shadow(
                   color: mainColors[idx % mainColors.length]
                       .withOpacity(opacity * 0.8),
                   blurRadius: 8,
                 ),
               ],
             ),
           );
         }).toList(),
       );
     },
   );
 }
}

class HexagonPainter extends CustomPainter {
 final List<Color> colors;
 final double progress;

 HexagonPainter({required this.colors, required this.progress});

 @override
 void paint(Canvas canvas, Size size) {
   final Paint paint = Paint()
     ..style = PaintingStyle.stroke
     ..strokeWidth = 3.0;

   final Path path = Path();
   final double radius = size.width / 2;
   final double centerX = size.width / 2;
   final double centerY = size.height / 2;

   for (int i = 0; i < 6; i++) {
     final double angle = (i * 60) * math.pi / 180;
     final double x = centerX + radius * math.cos(angle);
     final double y = centerY + radius * math.sin(angle);
     
     if (i == 0) {
       path.moveTo(x, y);
     } else {
       path.lineTo(x, y);
     }
   }
   path.close();

   // Gradient efekti
   final Gradient gradient = SweepGradient(
     colors: [
       ...colors,
       colors[0],
     ],
     stops: [
       0.0,
       0.33,
       0.66,
       1.0,
     ],
     transform: GradientRotation(progress * 2 * math.pi),
   );

   paint.shader = gradient.createShader(Offset.zero & size);

   // Glow efekti
   canvas.drawPath(
     path,
     Paint()
       ..style = PaintingStyle.stroke
       ..strokeWidth = 8.0
       ..maskFilter = MaskFilter.blur(BlurStyle.outer, 4)
       ..shader = gradient.createShader(Offset.zero & size),
   );

   canvas.drawPath(path, paint);
 }

 @override
 bool shouldRepaint(HexagonPainter oldDelegate) => 
     oldDelegate.progress != progress;
}
