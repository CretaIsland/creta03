// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/creta_color.dart';
import '../../design_system/creta_font.dart';
import 'studio_constant.dart';
import '../../creta_strings.dart';

class BookMainPage extends StatefulWidget {
  const BookMainPage({super.key});

  @override
  State<BookMainPage> createState() => _BookMainPageState();
}

List<bool> selected = [];

class _BookMainPageState extends State<BookMainPage> {
  List<IconData> icon = [
    Icons.dynamic_feed_outlined, //MaterialIcons.dynamic_feed,
    Icons.insert_drive_file_outlined, //MaterialIcons.insert_drive_file,
    Icons.space_dashboard_outlined,
    Icons.inventory_2_outlined,
    Icons.image_outlined,
    Icons.slideshow_outlined,
    Icons.title_outlined,
    Icons.pentagon_outlined,
    Icons.interests_outlined,
    Icons.photo_camera_outlined,
    Icons.chat_outlined,
  ];

  void select(int n) {
    for (int i = 0; i < icon.length; i++) {
      if (i == n) {
        selected[i] = true;
      } else {
        selected[i] = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < icon.length; i++) {
      selected.add(false);
    }
    selected[0] = true;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Snippet.CretaScaffold(
        title: 'Creta Studio',
        context: context,
        child: Stack(
          children: [
            Container(color: LayoutConst.studioBGColor),
            Container(
                margin: EdgeInsets.all(0),
                height: height,
                width: LayoutConst.menuStickWidth,
                decoration: BoxDecoration(
                  color: LayoutConst.menuStickBGColor, //Color(0xff332A7C),
                  //borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                        top: 24,
                        child: Column(
                          children: icon
                              .map((e) => NavBarItem(
                                    icon: e,
                                    title: CretaStrings.menuStick[icon.indexOf(e)],
                                    onTap: () {
                                      setState(() {
                                        select(icon.indexOf(e));
                                      });
                                    },
                                    selected: selected[icon.indexOf(e)],
                                  ))
                              .toList(),
                        ))
                  ],
                )),
          ],
        ));
  }
}

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final bool selected;

  const NavBarItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap,
      required this.selected});

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with TickerProviderStateMixin {
  // late AnimationController _controller1;
  // late AnimationController _controller2;

  // late Animation<double> _anim1;
  // late Animation<double> _anim2;
  // late Animation<double> _anim3;
  // late Animation<Color?> _color;

  bool hovered = false;

  @override
  void initState() {
    super.initState();
    // _controller1 = AnimationController(
    //   vsync: this,
    //   duration: Duration(microseconds: 250),
    // );
    // _controller2 = AnimationController(
    //   vsync: this,
    //   duration: Duration(microseconds: 275),
    // );

    // _anim1 = Tween(begin: LayoutConst.menuStickWidth, end: LayoutConst.menuStickWidth * (9 / 10))
    //     .animate(_controller1);
    // _anim2 = Tween(begin: LayoutConst.menuStickWidth, end: LayoutConst.menuStickWidth * (5 / 10))
    //     .animate(_controller2);
    // _anim3 = Tween(begin: LayoutConst.menuStickWidth, end: LayoutConst.menuStickWidth * (1 / 10))
    //     .animate(_controller2);

    // _color =
    //     ColorTween(begin: CretaColor.text[700], end: CretaColor.text[900]).animate(_controller2);

    // _controller1.addListener(() {
    //   setState(() {});
    // });
    // _controller2.addListener(() {
    //   setState(() {});
    // });
  }

  // @override
  // void didUpdateWidget(NavBarItem oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (!widget.selected) {
  //     Future.delayed(Duration(milliseconds: 10), () {
  //       //_controller1.reverse();
  //     });
  //     _controller1.reverse();
  //     _controller2.reverse();
  //   } else {
  //     _controller1.forward();
  //     _controller2.forward();
  //     Future.delayed(Duration(milliseconds: 10), () {
  //       //_controller2.forward();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (value) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (value) {
          setState(() {
            hovered = false;
          });
        },
        child: Container(
          width: LayoutConst.menuStickWidth,
          color: widget.selected
              ? LayoutConst.studioBGColor
              //: (hovered ? CretaColor.text[100] : Colors.transparent),
              : Colors.transparent,
          child: Stack(
            //alignment: AlignmentDirectional.center,
            children: [
              // CustomPaint(
              //   painter: CurvePainter(
              //     animValue1: _anim1.value,
              //     animValue2: _anim2.value,
              //     animValue3: _anim3.value,
              //   ),
              // ),
              SizedBox(
                height: LayoutConst.menuStickIconAreaHeight,
                width: LayoutConst.menuStickWidth,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        color:
                            hovered ? CretaColor.text[900] : CretaColor.text[700], //_color.value,
                        size: hovered
                            ? LayoutConst.menuStickIconSize + 4
                            : LayoutConst.menuStickIconSize,
                      ),
                      Text(
                        widget.title,
                        style: CretaFont.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CurvePainter extends CustomPainter {
//   final double animValue1;
//   final double animValue2;
//   final double animValue3;

//   CurvePainter({required this.animValue1, required this.animValue2, required this.animValue3});

//   @override
//   void paint(Canvas canvas, Size size) {
//     Path path = Path();
//     Paint paint = Paint();
//     path.moveTo(LayoutConst.menuStickWidth, 0);
//     path.quadraticBezierTo(LayoutConst.menuStickWidth, 10, animValue1, 10); //1
//     path.lineTo(animValue2, 10); //2
//     path.quadraticBezierTo(animValue3, 10, animValue3, 40); //3
//     path.lineTo(LayoutConst.menuStickWidth, 40);
//     path.close();

//     path.moveTo(LayoutConst.menuStickWidth, 80);
//     path.quadraticBezierTo(LayoutConst.menuStickWidth, 70, animValue1, 70); //4
//     path.lineTo(animValue2, 70); //5
//     path.quadraticBezierTo(animValue3, 70, animValue3, 40); //6
//     path.lineTo(LayoutConst.menuStickWidth, 40);
//     path.close();

//     paint.color = LayoutConst.studioBGColor;
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return oldDelegate != this;
//   }
// }
