import 'dart:math';
import 'dart:ui';

class Sizing {
  static const double DESIGN_WIDTH = 224;
  static const double DESIGN_HEIGHT = 485;

  static Size _physicalSize;

  static void setSize(Size size) => _physicalSize = size;

  static Sizing _sizing = Sizing();

  Sizing getInstence() => _sizing;

  double getValue(double widthDesign) => (widthDesign * _physicalSize.width) / DESIGN_WIDTH;

  double getY(double heightDesign) => (heightDesign * _physicalSize.height) / DESIGN_HEIGHT;

  double getDisplayHeight() => _physicalSize.height;

  double getDisplayWidth() => _physicalSize.width;

  double getStraight(double straightDesign) => straightDesign * sqrt(
      (_physicalSize.width * _physicalSize.width +_physicalSize.width * _physicalSize.width) /
      (DESIGN_WIDTH * DESIGN_WIDTH + DESIGN_WIDTH * DESIGN_WIDTH)
  );
}