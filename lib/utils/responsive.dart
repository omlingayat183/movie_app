import 'package:flutter/widgets.dart';

class Responsive {

  static int gridColumns(BuildContext context,
      {int minWidth = 220, int max = 6}) {
    final width = MediaQuery.of(context).size.width;
    int count = (width / minWidth).floor();
    if (count < 1) count = 1;
    if (count > max) count = max;
    return count;
  }


  static double contentMaxWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w > 1200 ? 1100 : w;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= 600 && w < 1024;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;
}
