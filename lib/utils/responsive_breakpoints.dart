// lib/utils/responsive_breakpoints.dart
import 'package:flutter/material.dart';

/// ResponsiveBreakpoints helps layout adapt to different screen widths.
/// The app uses this to change layout (side-by-side vs stacked) on smaller screens.
class ResponsiveBreakpoints {
  // breakpoint values in logical pixels
  static const double mobile = 600;
  static const double tablet = 1200;

  // checks if current width is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  // checks if current width is tablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobile &&
      MediaQuery.sizeOf(context).width < tablet;

  // checks if desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  // get number of columns (optional helper)
  static int getColumns(BuildContext context,
      {int mobileColumns = 1, int tabletColumns = 2, int desktopColumns = 3}) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobile) return mobileColumns;
    if (width < tablet) return tabletColumns;
    return desktopColumns;
  }
}
