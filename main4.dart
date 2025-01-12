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
         child: CyberLoader(),
       ),
     ),
   );
 }
}

class CyberLoader extends StatefulWidget {
 @override
 _CyberLoaderState createState() => _CyberLoaderState();
}

class _CyberLoaderState extends State<CyberLoader>
   with TickerProviderStateMixin {
 late AnimationController _rotationController;
 late AnimationController _pulseController;
 late AnimationController _glowController;
 late AnimationController _scanlineController;

 final List<Color> cyberColors = [
   Color(0xFF00FF9B), // Neon Yeşil
   Color(0xFF00B8FF), // Neon Mavi
   Color(0xFFFF0099), // Neon Pembe
 ];

 @override
 void initState() {
   super.initState();
   
   _rotationController = AnimationController(
     duration: const Duration(milliseconds: 6000),
     vsync: this,
   )..repeat();

   _pulseController = AnimationController(
     duration: const Duration(milliseconds: 1500),
     vsync: this,
   )..repeat(reverse: true);

   _glowController = AnimationController(
     duration: const Duration(milliseconds: 3000),
     vsync: this,
   )..repeat();

   _scanlineController = AnimationController(
     duration: const Duration(milliseconds: 2000),
     vsync: this,
   )..repeat();
 }

 @override
 void dispose() {
   _rotationController.dispose();
   _pulseController.dispose();
   _glowController.dispose();
   _scanlineController.dispose();
   super.dispose();
 }

 @override
 Widget build(BuildContext context) {
   return Column(
     mainAxisSize: MainAxisSize.min,
     children: [
       Container(
         width: 220,
         height: 220,
         child: Stack(
           alignment: Alignment.center,
           children: [
             // Arkadaki kare çerçeve
             AnimatedBuilder(
               animation: _pulseController,
               builder: (context, child) {
                 return Container(
                   width: 180,
                   height: 180,
                   decoration: BoxDecoration(
                     color: Colors.black,
                     border: Border.all(
                       color: cyberColors[0].withOpacity(0.3),
                       width: 2,
                     ),
                     boxShadow: [
                       BoxShadow(
                         color: cyberColors[0].withOpacity(0.2),
                         blurRadius: 20,
                         spreadRadius: 5 * _pulseController.value,
                       ),
                     ],
                   ),
                 );
               },
             ),

             // Tarama çizgileri efekti
             ClipRect(
               child: AnimatedBuilder(
                 animation: _scanlineController,
                 builder: (context, child) {
                   return Container(
                     width: 180,
                     height: 180,
                     child: Column(
                       children: List.generate(20, (index) {
                         final offset = (_scanlineController.value * 20 + index) % 20;
                         return Container(
                           height: 9,
                           color: Colors.white.withOpacity(
                             offset == 0 ? 0.2 : 0.0,
                           ),
                         );
                       }),
                     ),
                   );
                 },
               ),
             ),

             // Dönen üçgenler
             AnimatedBuilder(
               animation: _rotationController,
               builder: (context, child) {
                 return Stack(
                   alignment: Alignment.center,
                   children: [
                     // Dış üçgen
                     Transform.rotate(
                       angle: _rotationController.value * 2 * math.pi,
                       child: CustomPaint(
                         size: Size(160, 160),
                         painter: TrianglePainter(
                           color: cyberColors[1],
                           progress: _pulseController.value,
                         ),
                       ),
                     ),
                     // İç üçgen
                     Transform.rotate(
                       angle: -_rotationController.value * 2 * math.pi,
                       child: CustomPaint(
                         size: Size(120, 120),
                         painter: TrianglePainter(
                           color: cyberColors[2],
                           progress: _pulseController.value,
                         ),
                       ),
                     ),
                   ],
                 );
               },
             ),

             // Merkez hologram efekti
             AnimatedBuilder(
               animation: _glowController,
               builder: (context, child) {
                 final glowOpacity = math.sin(_glowController.value * math.pi * 2) * 0.5 + 0.5;
                 return Container(
                   width: 60,
                   height: 60,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     gradient: RadialGradient(
                       colors: [
                         Colors.white.withOpacity(0.6 * glowOpacity),
                         Colors.transparent,
                       ],
                     ),
                   ),
                 );
               },
             ),

             // AI Yazısı
             ShaderMask(
               shaderCallback: (bounds) => LinearGradient(
                 colors: [
                   cyberColors[0],
                   cyberColors[1],
                   cyberColors[2],
                 ],
                 stops: [0.0, 0.5, 1.0],
                 begin: Alignment.topLeft,
                 end: Alignment.bottomRight,
               ).createShader(bounds),
               child: Text(
                 'AI',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 40,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ),
           ],
         ),
       ),
       SizedBox(height: 20),
       // Alt yazı animasyonu
       _buildStatusText(),
     ],
   );
 }

 Widget _buildStatusText() {
   final statuses = ['INITIALIZING', 'SCANNING', 'PROCESSING'];
   return AnimatedBuilder(
     animation: _glowController,
     builder: (context, child) {
       final statusIndex = (_glowController.value * statuses.length).floor() % statuses.length;
       return Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           Text(
             statuses[statusIndex],
             style: TextStyle(
               color: cyberColors[statusIndex].withOpacity(0.8),
               fontSize: 16,
               fontWeight: FontWeight.w500,
               letterSpacing: 3,
               shadows: [
                 Shadow(
                   color: cyberColors[statusIndex].withOpacity(0.5),
                   blurRadius: 8,
                 ),
               ],
             ),
           ),
           ...List.generate(3, (index) {
             final dotOpacity = math.sin((_glowController.value * 2 * math.pi + index * 0.5) % math.pi);
             return Text(
               '.',
               style: TextStyle(
                 color: cyberColors[statusIndex].withOpacity(dotOpacity),
                 fontSize: 16,
                 fontWeight: FontWeight.bold,
               ),
             );
           }),
         ],
       );
     },
   );
 }
}

class TrianglePainter extends CustomPainter {
 final Color color;
 final double progress;

 TrianglePainter({required this.color, required this.progress});

 @override
 void paint(Canvas canvas, Size size) {
   final paint = Paint()
     ..color = color.withOpacity(0.5)
     ..style = PaintingStyle.stroke
     ..strokeWidth = 2;

   final path = Path();
   final side = size.width;
   final height = side * math.sqrt(3) / 2;

   path.moveTo(side / 2, 0);
   path.lineTo(side, height);
   path.lineTo(0, height);
   path.close();

   // Glow efekti
   canvas.drawPath(
     path,
     Paint()
       ..color = color.withOpacity(0.2 + 0.2 * progress)
       ..style = PaintingStyle.stroke
       ..strokeWidth = 4
       ..maskFilter = MaskFilter.blur(BlurStyle.outer, 4),
   );

   canvas.drawPath(path, paint);
 }

 @override
 bool shouldRepaint(TrianglePainter oldDelegate) =>
     oldDelegate.progress != progress || oldDelegate.color != color;
}
