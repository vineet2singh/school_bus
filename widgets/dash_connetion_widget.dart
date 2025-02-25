import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

class DashedConnectionWidget extends StatelessWidget {
  final Color startColor;
  final Color endColor;
  final Color dashColor;
  final double dashLength;
  final double spacing;
  final double circleSize;

  const DashedConnectionWidget({
    super.key,
    this.startColor = Colors.red,
    this.endColor = Colors.blue,
    this.dashColor = Colors.black,
    this.dashLength = 50,
    this.spacing = 10,
    this.circleSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircle(startColor),
        SizedBox(width: spacing),
        Dash(length: dashLength, dashColor: dashColor),
        SizedBox(width: spacing),
        _buildCircle(endColor),
      ],
    );
  }

  Widget _buildCircle(Color color) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
