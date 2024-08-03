import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:vienna_hackaton_display/components/svg_body_component.dart';
import 'package:vienna_hackaton_display/svg_utils.dart';

class EggComponent extends SvgBodyComponent {
  EggComponent({required super.svgName});

  @override
  (List<FixtureDef>?, BodyDef) createFixtureDefsAndBodyDef(String svgString) {
    final vertices = extractVerticesFromSvg(svgString);
    final fixtureDef = createPolygonShapeFixtureFromVertices(vertices.first);
    return ([fixtureDef], BodyDef(type: BodyType.dynamic, position: Vector2(2.0, 0.0)));
  }
}
