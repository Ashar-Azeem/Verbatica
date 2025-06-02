import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class NumberCaptcha extends StatefulWidget {
  const NumberCaptcha(this.code, {super.key, required this.isDark});
  final bool isDark;
  final String code;

  @override
  State<NumberCaptcha> createState() => _NumberCaptchaState();
}

class _NumberCaptchaState extends State<NumberCaptcha> {
  final double width = 65.w;
  final double height = 6.h;
  final int dotCount = 350;

  Map getRandomData() {
    List list = widget.code.split("");
    double x = 0.0;
    double maxFontSize = 36.0;

    List mList = [];
    for (String item in list) {
      Color color =
          widget.isDark
              ? Color.fromARGB(
                255,
                150 + Random().nextInt(100),
                150 + Random().nextInt(100),
                150 + Random().nextInt(100),
              )
              : Color.fromARGB(
                255,
                150 + Random().nextInt(105), // 150–255 range
                150 + Random().nextInt(105),
                150 + Random().nextInt(105),
              );

      int fontWeight = Random().nextInt(9);

      TextSpan span = TextSpan(
        text: item,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.values[fontWeight],
          fontSize: maxFontSize - Random().nextInt(6),
        ),
      );

      TextPainter painter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );

      painter.layout();

      double y = Random().nextInt(height.toInt()).toDouble() - painter.height;

      if (y < 0) {
        y = 0;
      }

      Map strMap = {"painter": painter, "x": x, "y": y};

      mList.add(strMap);

      x += painter.width + 4;
    }

    double offsetX = (width - x) / 2;
    List dotData = [];

    for (var i = 0; i < dotCount; i++) {
      int brightness = 100 + Random().nextInt(100);
      Color color = Color.fromARGB(255, brightness, brightness, brightness);
      double x = Random().nextDouble() * (width - 5);
      double y = Random().nextDouble() * (height - 5);
      double dotWidth = 1 + Random().nextDouble() * 3;
      dotData.add({"x": x, "y": y, "dotWidth": dotWidth, "color": color});
    }

    return {"painterData": mList, "offsetX": offsetX, "dotData": dotData};
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth =
        getTextSize(
          "8" * widget.code.length,
          const TextStyle(fontWeight: FontWeight.w800, fontSize: 26),
        ).width;

    final Map drawData = getRandomData();

    return Container(
      width: max(maxWidth, width),
      height: height,
      decoration: BoxDecoration(
        color: widget.isDark ? Color.fromARGB(255, 8, 10, 12) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(255, 81, 144, 221), // Your button color
        ),
      ),
      child: CustomPaint(painter: HBCheckCodePainter(drawData: drawData)),
    );
  }

  Size getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size;
  }
}

class HBCheckCodePainter extends CustomPainter {
  final Map drawData;
  HBCheckCodePainter({required this.drawData});

  final Paint _paint =
      Paint()
        ..strokeCap = StrokeCap.square
        ..isAntiAlias = true
        ..strokeWidth = 1.0
        ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    List mList = drawData["painterData"];
    double offsetX = drawData["offsetX"];

    canvas.translate(offsetX, 0);

    for (var item in mList) {
      TextPainter painter = item["painter"];
      double x = item["x"];
      double y = item["y"];
      painter.paint(canvas, Offset(x, y));
    }

    canvas.translate(-offsetX, 0);

    List dotData = drawData["dotData"];
    for (var item in dotData) {
      double x = item["x"];
      double y = item["y"];
      double dotWidth = item["dotWidth"];
      Color color = item["color"];
      _paint.color = color;
      canvas.drawOval(Rect.fromLTWH(x, y, dotWidth, dotWidth), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
