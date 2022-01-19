import 'package:fast_noise/fast_noise.dart' as fast_noise;
import 'package:flutter/animation.dart';
import 'package:frederic/main.dart';
import 'package:image/image.dart';

class GlassmorphBackgroundGenerator {
  GlassmorphBackgroundGenerator();

  List<int> generate(int width, int height) {
    int mainColorRed = theme.mainColor.red;
    int mainColorGreen = theme.mainColor.green;
    int mainColorBlue = theme.mainColor.blue;

    Image image = Image(width, height);
    var background = fast_noise.noise2(width, height,
        noiseType: fast_noise.NoiseType.Cellular,
        frequency: 0.01,
        seed: 1888,
        cellularReturnType: fast_noise.CellularReturnType.Distance2Add);

    for (int i = 0; i < background.length; i++) {
      var row = background[i];
      for (int j = 0; j < row.length; j++) {
        double value = row[j];
        if (value < 0) value = 0;
        if (value > 1) value = 1;

        value = Curves.easeOutExpo.transform(value);

        int red = (mainColorRed * value).toInt();
        int green = (mainColorGreen * value).toInt();
        int blue = (mainColorBlue * value).toInt();

        image.setPixelRgba(
            i, j, (255 + red) ~/ 3, (255 + green) ~/ 2, (255 + blue) ~/ 1);

        continue;
        //int blue = (value * 255.0).toInt();
        if (blue > 255) blue = 255;
        if (blue < 0) blue = 0;

        int factor = 255 - blue;
        //int factor = (255 - (blue * 2));
        if (factor > 255) factor = 255;

        image.setPixelRgba(i, j, factor, factor, 255);
      }
    }

    //image = gaussianBlur(image, width ~/ 3);

    return encodePng(image);
  }
}
