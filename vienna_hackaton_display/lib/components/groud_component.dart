import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:vienna_hackaton_display/components/svg_body_component.dart';
import 'package:vienna_hackaton_display/svg_utils.dart';

class GroundComponent extends SvgBodyComponent {
  GroundComponent({required super.svgName});

  @override
  (List<FixtureDef>?, BodyDef) createFixtureDefsAndBodyDef(String svgString) {
    final vertices = extractVerticesFromSvg(svgString);
    final fixtureDef = createChainShapeFixtureFromVertices(vertices.first);
    return ([fixtureDef], BodyDef(type: BodyType.static));
  }
}
