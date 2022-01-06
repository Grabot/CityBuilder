import 'dart:math';
import '../component/tile.dart';

// Don't forget to update these size if you update the sizes in the tile object.
double xSizeFlat = 32;
double ySizeFlat = sqrt(3) * 16 / 2;
double xSizePoint = sqrt(3) * 16;
double ySizePoint = 16;

List<int> tappedMapFlat(List<List<Tile?>>tiles, double mouseX, double mouseY) {
  double xTranslate = (2/3 * mouseX);
  double qDetailed = xTranslate / xSizeFlat;
  double yTranslate1 = (-1/3 * mouseX);
  double yTranslate2 = (sqrt(3) / 3 * mouseY);
  yTranslate2 *= -1;  // The y axis gets positive going down, so we flip it.
  double rDetailed = (yTranslate1 / xSizeFlat) + (yTranslate2 / ySizeFlat);
  double sDetailed = (qDetailed + rDetailed) * -1;

  int q = qDetailed.round();
  int r = rDetailed.round();
  int s = sDetailed.round();

  double qDiff = (q - qDetailed).abs();
  double rDiff = (r - rDetailed).abs();
  double sDiff = (s - sDetailed).abs();

  if (qDiff > rDiff && qDiff > sDiff) {
    q = -r - s;
  } else if (rDiff > sDiff) {
    r = -q - s;
  } else {
    s = -q - r;
  }
  return [q, r, s];
}

List<int> tappedMapPoint(List<List<Tile?>>tiles, double mouseX, double mouseY) {
  double xTranslate1 = (-1/3 * mouseY);
  xTranslate1 *= -1;
  double xTranslate2 = (sqrt(3) / 3 * mouseX);
  double qDetailed = (xTranslate1 / ySizePoint) + (xTranslate2 / xSizePoint);

  double yTranslate = (2/3 * mouseY);
  yTranslate *= -1;
  double rDetailed = yTranslate / ySizePoint;
  double sDetailed = (qDetailed + rDetailed) * -1;

  int q = qDetailed.round();
  int r = rDetailed.round();
  int s = sDetailed.round();

  double qDiff = (q - qDetailed).abs();
  double rDiff = (r - rDetailed).abs();
  double sDiff = (s - sDetailed).abs();

  if (qDiff > rDiff && qDiff > sDiff) {
    q = -r - s;
  } else if (rDiff > sDiff) {
    r = -q - s;
  } else {
    s = -q - r;
  }
  return [q, r, s];
}

List<int> tappedMap(List<List<Tile?>>tiles, double mouseX, double mouseY, int rotate) {
  double qDetailed = -1;
  double rDetailed = -1;
  double sDetailed = -1;
  if (rotate == 0) {
    double xTranslate = (2/3 * mouseX);
    qDetailed = xTranslate / xSizeFlat;
    double yTranslate1 = (-1/3 * mouseX);
    double yTranslate2 = (sqrt(3) / 3 * mouseY);
    yTranslate2 *= -1;  // The y axis gets positive going down, so we flip it.
    rDetailed = (yTranslate1 / xSizeFlat) + (yTranslate2 / ySizeFlat);
    sDetailed = (qDetailed + rDetailed) * -1;
  } else if (rotate == 1) {
    double xTranslate1 = (-1/3 * mouseY);
    xTranslate1 *= -1;
    double xTranslate2 = (sqrt(3) / 3 * mouseX);
    qDetailed = (xTranslate1 / ySizePoint) + (xTranslate2 / xSizePoint);

    double yTranslate = (2/3 * mouseY);
    yTranslate *= -1;
    rDetailed = yTranslate / ySizePoint;
    sDetailed = (qDetailed + rDetailed) * -1;
  }

  int q = qDetailed.round();
  int r = rDetailed.round();
  int s = sDetailed.round();

  double qDiff = (q - qDetailed).abs();
  double rDiff = (r - rDetailed).abs();
  double sDiff = (s - sDetailed).abs();

  if (qDiff > rDiff && qDiff > sDiff) {
    q = -r - s;
  } else if (rDiff > sDiff) {
    r = -q - s;
  } else {
    s = -q - r;
  }
  return [q, r, s];
}