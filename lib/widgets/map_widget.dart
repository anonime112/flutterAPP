import 'package:flutter/material.dart';
import 'package:repair_service_ui/utils/constants.dart';

// Simple map widget for showing location on trips
// This is a mockup implementation since Google Maps API key setup requires configuration
class SimpleMapWidget extends StatefulWidget {
  final String startLocation;
  final String endLocation;
  final double height;

  const SimpleMapWidget({
    Key? key,
    required this.startLocation,
    required this.endLocation,
    this.height = 300.0,
  }) : super(key: key);

  @override
  _SimpleMapWidgetState createState() => _SimpleMapWidgetState();
}

class _SimpleMapWidgetState extends State<SimpleMapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Color(0xFFE8F0FF),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1.0,
        ),
      ),
      child: Stack(
        children: [
          // Map gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEAF2FF), Color(0xFFF5F7FB)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Constants.accentOrange.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),
          ),
          // Animated route path visualization
          CustomPaint(
            painter: RoutePathPainter(
              progress: _animation.value,
              startColor: Constants.accentGreen,
              endColor: Constants.accentOrange,
            ),
            size: Size.fromHeight(widget.height),
          ),
          // Location markers
          Positioned(
            left: 40.0,
            top: 50.0,
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  color: Constants.accentGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Constants.accentGreen.withOpacity(0.4),
                      blurRadius: 16.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ),
          ),
          Positioned(
            right: 40.0,
            bottom: 50.0,
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  color: Constants.accentOrange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Constants.accentOrange.withOpacity(0.4),
                      blurRadius: 16.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ),
          ),
          // Location labels
          Positioned(
            left: 20.0,
            top: 20.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Text(
                widget.startLocation,
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20.0,
            bottom: 20.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Text(
                widget.endLocation,
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                ),
              ),
            ),
          ),
          // Center info
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.navigation,
                      size: 28.0,
                      color: Constants.primaryColor,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Trajet simulé',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Constants.primaryColor,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '12.4 km • ~24 min',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoutePathPainter extends CustomPainter {
  final double progress;
  final Color startColor;
  final Color endColor;

  RoutePathPainter({
    required this.progress,
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.lerp(startColor, endColor, progress % 1.0)!
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Create a curved path from top-left to bottom-right
    final startPoint = Offset(60, 50);
    final controlPoint1 = Offset(size.width * 0.3, size.height * 0.4);
    final controlPoint2 = Offset(size.width * 0.7, size.height * 0.6);
    final endPoint = Offset(size.width - 60, size.height - 50);

    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // Draw the full path
    canvas.drawPath(path, paint..color = Colors.grey[300]!..strokeWidth = 3.0);

    // Draw animated progress
    final pathMetrics = path.computeMetrics();
    for (var pathMetric in pathMetrics) {
      final length = pathMetric.length;
      final currentLength = length * progress;
      final extractPath = pathMetric.extractPath(0, currentLength);
      canvas.drawPath(extractPath, paint..strokeWidth = 4.0);
    }
  }

  @override
  bool shouldRepaint(RoutePathPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
