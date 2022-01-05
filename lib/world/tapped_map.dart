import 'dart:math';
import '../component/tile.dart';


List<int> tappedMapFlat(List<List<Tile?>>tiles, double xSize, double ySize, double mouseX, double mouseY) {
  double xTranslate = (2/3 * mouseX);
  double qDetailed = xTranslate / xSize;
  double yTranslate1 = (-1/3 * mouseX);
  double yTranslate2 = (sqrt(3) / 3 * mouseY);
  yTranslate2 *= -1;  // The y axis gets positive going down, so we flip it.
  double rDetailed = (yTranslate1 / xSize) + (yTranslate2 / ySize);
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

List<int> tappedMapPoint(List<List<Tile?>>tiles, double xSize, double ySize, double mouseX, double mouseY) {
  double xTranslate1 = (-1/3 * mouseY);
  xTranslate1 *= -1;
  double xTranslate2 = (sqrt(3) / 3 * mouseX);
  double qDetailed = (xTranslate1 / ySize) + (xTranslate2 / xSize);

  double yTranslate = (2/3 * mouseY);
  yTranslate *= -1;
  double rDetailed = yTranslate / ySize;
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
