import 'package:flutter/material.dart';

import '../models/trace_history_data.dart';

/// Created by Chandan Jana on 13-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class TrackStatusPainter extends CustomPainter {
  final List<TraceHistoryData> statusList;

  //final TraceHistoryData historyData;
  //final int position;

  TrackStatusPainter(this.statusList);

  //TrackStatusPainter(this.historyData, this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint grayPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint bluePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final Paint greenPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // Horizontal line
    /*final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = 10;

    canvas.drawCircle(Offset(centerX - 30, centerY), radius, bluePaint);
    canvas.drawCircle(Offset(centerX + 30, centerY), radius, greenPaint);
    canvas.drawLine(
        Offset(centerX - 30 + radius, centerY), Offset(centerX + 30 - radius, centerY), grayPaint);*/

    // Vertical line
    /*final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = 10.0;
    final double gap = 30.0;

    canvas.drawCircle(Offset(centerX, centerY - gap), radius, greenPaint);
    canvas.drawCircle(Offset(centerX, centerY + gap), radius, bluePaint);
    canvas.drawLine(
        Offset(centerX, centerY - gap + radius),
        Offset(centerX, centerY + gap - radius ),
        grayPaint);*/

    final Paint linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;
    //final double centerX = size.width / 2;
    final double centerX = 0;
    //final double centerY = size.height / 2;
    final double radius = 15.0;
    final double gap = 20.0;
    for (int i = 0; i < statusList.length; i++) {
      final status = statusList[i];
      //final status = historyData;
      Color color = Colors.green;
      String label = 'Assigned';
      double centerY = (i + 1) * 50.0;
      //double centerY = (position + 1) * 50.0;

      if (status.message!.contains('Assigned')) {
        color = Colors.green;
        label = status.message!;
      } else if (status.message!.contains('')) {
        color = Colors.yellow;
        label = status.message!;
      } else if (status.message!.contains('Lost')) {
        color = Colors.red;
        label = status.message!;
      }

      final Paint circlePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(centerX + 20, centerY - 5 - gap));

      //canvas.drawCircle(Offset(30, y), 10, circlePaint);
      canvas.drawCircle(Offset(centerX, centerY - gap), radius, circlePaint);
      //canvas.drawCircle(Offset(centerX, centerY - gap), radius, circlePaint);

      // i != statusList.length - 1
      if (i != statusList.length - 1) {
        canvas.drawLine(
          Offset(centerX, centerY - gap + radius),
          Offset(centerX, (i + 2) * 50.0 + gap - radius),
          //Offset(centerX, (position + 2) * 50.0 + gap - radius),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
