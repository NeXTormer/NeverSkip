import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frederic/theme/background_generator/glassmorph_background_generator.dart';

class BackgroundGeneratorTestScreen extends StatelessWidget {
  const BackgroundGeneratorTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      GlassmorphBackgroundGenerator generator = GlassmorphBackgroundGenerator();
      final image = generator.generate(
          constraints.maxWidth.toInt(), constraints.maxHeight.toInt());

      final werner = Uint8List.fromList(image);

      return Container(
        color: Colors.amberAccent,
        child: Image.memory(werner),
      );
    });
  }
}
