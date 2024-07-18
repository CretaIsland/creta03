import 'package:flutter/material.dart';


class DrawerHandlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // 사각형 부분
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(20, 0);
    path.lineTo(20, size.height);
    path.lineTo(0, size.height);
    path.close();

    // 원의 오른쪽 반쪽 부분
    // 원의 중심 위치 계산
    final Offset circleCenter = Offset(20, size.height / 2);
    // 원을 그리기 위한 사각형 영역 계산
    final Rect rect = Rect.fromCircle(center: circleCenter, radius: 20);
    // 시작 각도는 -90도 (위쪽), 스윕 각도는 180도 (반원)
    path.arcTo(rect, -3.14 / 2, 3.14, false);

    canvas.drawPath(path, paint);

    // 아이콘
    final iconPaint = Paint()..color = Colors.white.withOpacity(0.5);
    canvas.drawCircle(circleCenter, 10, iconPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DrawerHandle extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawerHandle({super.key, required this.scaffoldKey});

  @override
  State<DrawerHandle> createState() => _DrawerHandleState();
}

class _DrawerHandleState extends State<DrawerHandle> {
  void _openDrawer() {
    widget.scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: MouseRegion(
        onHover: (_) => _openDrawer(),
        child: CustomPaint(
          size: Size(40, MediaQuery.of(context).size.height),
          painter: DrawerHandlePainter(),
        ),
      ),
    );
    
  }
}
