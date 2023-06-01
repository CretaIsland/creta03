import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

//Preview  : https://flutteranimations.netlify.app

///Implicit Animating Widgets Used : AnimatedContainer, AnimatedDefaultTextStyle, AnimatedPositioned

class CustomCursorExample extends StatefulWidget {
  const CustomCursorExample({super.key});

  @override
  CustomCursorExampleState createState() => CustomCursorExampleState();
}

class CustomCursorExampleState extends State<CustomCursorExample> {
  final globalKey = GlobalKey<ScaffoldState>();
  Offset pointer = const Offset(300, 300);
  Color backgroundColor = Colors.black;
  bool isLogoHovering = false;
  bool isInfoHovering = false;
  bool isTwitterHovering = false;
  bool isGithubHovering = false;
  bool isCodePenHovering = false;
  bool isLinkedinHovering = false;
  int mainItemHover = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        endDrawer: Container(
          color: Colors.black.withOpacity(0.9),
          width: isMobileView(context) ? getWidth(context) : getWidth(context) / 2,
          height: getHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    size: isMobileView(context) ? 30 : 50,
                    color: Colors.white,
                  )),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: ElevatedButton(
                    onPressed: () {
                      js.context.callMethod(
                          "open", ["https://dev.to/iamsahdeep/custom-cursor-in-flutter-web-1k4l"]);
                    },
                    child: Text(
                      "Check out this blog to make custom Mouse Cursor/Pointer like in this pen.",
                      style:
                          TextStyle(color: Colors.white, fontSize: isMobileView(context) ? 20 : 40),
                    )),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: MouseRegion(
          cursor: SystemMouseCursors.none,
          onHover: (eve) {
            setState(() {
              pointer = eve.position;
            });
          },
          child: AnimatedContainer(
            height: getHeight(context),
            width: getWidth(context),
            duration: const Duration(milliseconds: 500),
            color: backgroundColor,
            child: Stack(
              children: [
                AnimatedPositioned(
                  //Outer Ring
                  duration: const Duration(milliseconds: 1500),
                  left:
                      getCursorMainScreenWithRangeW(pointer.dx - (getWidth(context) / 2), context),
                  top:
                      getCursorMainScreenWithRangeH(pointer.dy - (getWidth(context) / 2), context) -
                          getWidth(context) / 4,
                  child: Container(
                    height: getWidth(context),
                    width: getWidth(context),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(getWidth(context) / 2)),
                        border:
                            Border.all(width: 2, color: Colors.white, style: BorderStyle.solid)),
                  ),
                ),
                AnimatedPositioned(
                  //Inner Ring
                  duration: const Duration(milliseconds: 1000),
                  left:
                      getCursorMainScreenWithRangeW(pointer.dx - (getWidth(context) / 3), context) +
                          100,
                  top:
                      getCursorMainScreenWithRangeH(pointer.dy - (getWidth(context) / 3), context) -
                          getWidth(context) / 8,
                  child: Container(
                    height: 2 * getWidth(context) / 3,
                    width: 2 * getWidth(context) / 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(getWidth(context) / 3)),
                        border:
                            Border.all(width: 2, color: Colors.white, style: BorderStyle.solid)),
                  ),
                ),
                AnimatedPositioned(
                    // Custom dot in Cursor
                    duration: const Duration(milliseconds: 100),
                    left: pointer.dx,
                    top: pointer.dy,
                    child: Container(
                      width: 3,
                      height: 3,
                      color: Colors.white,
                    )),
                AnimatedPositioned(
                  // Cursor Ring
                  duration: const Duration(milliseconds: 300),
                  left: pointer.dx - 100,
                  top: pointer.dy - 100,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        border:
                            Border.all(width: 4, color: Colors.white, style: BorderStyle.solid)),
                  ),
                ),
                Align(
                  // Animated Logo
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Transform.rotate(
                      angle: isLogoHovering ? 50 : 0,
                      child: InkWell(
                        onTap: () {},
                        onHover: (val) {
                          setState(() {
                            isLogoHovering = val;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedDefaultTextStyle(
                              style: TextStyle(
                                  color: isLogoHovering ? Colors.orangeAccent : Colors.white,
                                  fontSize: isLogoHovering ? 70 : 50,
                                  fontWeight: !isLogoHovering ? FontWeight.bold : FontWeight.w900),
                              duration: const Duration(milliseconds: 500),
                              child: const Text("S.")),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: InkWell(
                      onTap: () {
                        globalKey.currentState!.openEndDrawer();
                      },
                      onHover: (val) {
                        setState(() {
                          isInfoHovering = val;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.info_outline,
                          size: 50,
                          color: isInfoHovering ? Colors.orangeAccent : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          js.context.callMethod("open", ["https://sahdeepsingh.com/contact"]);
                        },
                        onHover: (v) {
                          setState(() {
                            mainItemHover = v ? 1 : 0;
                            backgroundColor = Colors.black.withRed(v ? 30 : 0);
                          });
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                              color: mainItemHover == 1 ? Colors.white : Colors.deepOrange,
                              fontWeight: FontWeight.w900,
                              fontSize: (mainItemHover == 1 ? 70 : 50)),
                          child: Text(" ping me".toUpperCase()),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.only(left: pointer.dx / 10),
                        child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 70),
                            child: Text("Get in Touch".toUpperCase())),
                      ),
                      InkWell(
                        onTap: () {
                          js.context.callMethod("open", ["https://sahdeepsingh.com"]);
                        },
                        onHover: (v) {
                          setState(() {
                            mainItemHover = v ? 2 : 0;
                            backgroundColor = Colors.black.withRed(v ? 30 : 0);
                          });
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: mainItemHover == 2 ? Colors.white : Colors.deepOrange,
                              fontWeight: FontWeight.w900,
                              fontSize: (mainItemHover == 2 ? 70 : 50)),
                          child: Text(" visit website".toUpperCase()),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                js.context.callMethod("open", ["https://github.com/iamSahdeep"]);
                              },
                              onHover: (eve) {
                                setState(() {
                                  isGithubHovering = eve;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: AnimatedContainer(
                                  height: isGithubHovering ? 70 : 60,
                                  duration: const Duration(milliseconds: 300),
                                  child: Center(
                                    child: Image.network(
                                      "https://cdn.freebiesupply.com/logos/large/2x/github-icon-logo-png-transparent.png",
                                      color: isGithubHovering ? Colors.orangeAccent : Colors.white,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                js.context.callMethod("open", ["https://twitter.com/iamSahdeep"]);
                              },
                              onHover: (eve) {
                                setState(() {
                                  isTwitterHovering = eve;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: AnimatedContainer(
                                  height: isTwitterHovering ? 70 : 60,
                                  duration: const Duration(milliseconds: 300),
                                  child: Center(
                                    child: Image.network(
                                      "https://iconsplace.com/wp-content/uploads/_icons/ffffff/256/png/twitter-icon-18-256.png",
                                      color: isTwitterHovering ? Colors.orangeAccent : Colors.white,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                js.context.callMethod("open", ["https://codepen.io/iamSahdeep"]);
                              },
                              onHover: (eve) {
                                setState(() {
                                  isCodePenHovering = eve;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: AnimatedContainer(
                                  height: isCodePenHovering ? 70 : 60,
                                  duration: const Duration(milliseconds: 300),
                                  child: Center(
                                    child: Image.network(
                                      "https://blog.codepen.io/wp-content/uploads/2012/06/Button-White-Large.png",
                                      color: isCodePenHovering ? Colors.orangeAccent : Colors.white,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                js.context
                                    .callMethod("open", ["https://www.linkedin.com/in/iamsahdeep"]);
                              },
                              onHover: (eve) {
                                setState(() {
                                  isLinkedinHovering = eve;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: AnimatedContainer(
                                  height: isLinkedinHovering ? 70 : 60,
                                  duration: const Duration(milliseconds: 300),
                                  child: Center(
                                    child: Image.network(
                                      "https://cdn3.iconfinder.com/data/icons/free-social-icons/67/linkedin_circle_gray-512.png",
                                      color:
                                          isLinkedinHovering ? Colors.orangeAccent : Colors.white,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}

//Util Methods

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

bool isMobileView(BuildContext context) {
  return getWidth(context) < 700 || getHeight(context) > getWidth(context);
}

///Changing range eg : (0 - 1000) -> (300 - 700) ie., -600! In terms of width
double getCursorMainScreenWithRangeW(double da, BuildContext context) {
  return (((da) * (getWidth(context) - 600)) / (getWidth(context)));
}

///same as above but for Height
double getCursorMainScreenWithRangeH(double da, BuildContext context) {
  return (((da) * (getHeight(context) - 600)) / (getHeight(context)));
}
