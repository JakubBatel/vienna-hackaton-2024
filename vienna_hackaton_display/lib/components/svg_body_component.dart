import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_svg/flame_svg.dart';

abstract class SvgBodyComponent extends BodyComponent {
  final String svgName;
  late final Svg svg;

  SvgBodyComponent({required this.svgName});

  @override
  // ignore: must_call_super
  Future<void> onLoad() async {
    final svgString = await Flame.assets.readFile(svgName);
    final (fixtureDefs, bodyDef) = createFixtureDefsAndBodyDef(svgString);
    this.fixtureDefs = fixtureDefs;
    this.bodyDef = bodyDef;

    svg = await Svg.loadFromString(svgString);

    body = createBody();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    svg.render(canvas, svg.pictureInfo.size.toVector2());
  }

  (List<FixtureDef>?, BodyDef) createFixtureDefsAndBodyDef(String svgString);
}
