import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/pages/studio/left_menu/weather/weather_utils.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherStickerElements extends StatelessWidget {
  final double? width;
  final double? height;
  const WeatherStickerElements({
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 1;
    return _selectedIcon(context, selectedIndex);
    // return Padding(
    //   padding: const EdgeInsets.only(top: 12.0, bottom: 8.0, left: 24.0, right: 12.0),
    //   child: SizedBox(
    //     height: 350.0,
    //     child: GridView.builder(
    //       itemCount: WeatherIconsUtil.iconMap.keys.length,
    //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 4,
    //         childAspectRatio: 1 / 1,
    //         mainAxisSpacing: 6.0,
    //         crossAxisSpacing: 6.0,
    //       ),
    //       itemBuilder: (BuildContext context, int index) {
    //         return LeftMenuEleButton(
    //           width: 30.0,
    //           height: 30.0,
    //           onPressed: onPressed,
    //           child: _createIconList(context)[index],
    //         );
    //       },
    //     ),
    //   ),
    // );
  }

  // List<Widget> _createIconList(BuildContext context) {
  //   return WeatherIconsUtil.iconMap.keys.map(
  //     (name) {
  //       final icon = WeatherIcons.fromString(name);
  //       return GridTile(
  //         child: BoxedIcon(
  //           icon,
  //           size: 50,
  //           color: CretaColor.primary,
  //         ),
  //       );
  //     },
  //   ).toList();
  // }

  Widget _selectedIcon(BuildContext context, int iconIndex) {
    final iconNames = WeatherIconsUtil.iconMap.keys.toList();

    if (iconIndex >= 0 && iconIndex < iconNames.length) {
      final selectedIconName = iconNames[iconIndex];
      final icon = WeatherIcons.fromString(selectedIconName);
      return BoxedIcon(
        icon,
        size: 50.0,
        color: CretaColor.primary,
      );
    } else {
      return const Icon(
        Icons.error_outline,
        size: 50.0,
        color: Colors.red,
      );
    }
  }
}
