import 'dart:math';
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:svg_path_parser/svg_path_parser.dart';
import 'package:xml/xml.dart';

List<List<Vector2>> _convertPathToVertices(Path path) {
  final pathMetrics = path.computeMetrics();
  final verticesList = <List<Vector2>>[];

  for (final pathMetric in pathMetrics) {
    final List<Vector2> vertices = [];
    for (double distance = 0.0; distance < pathMetric.length; distance += 10.0) {
      final pos = pathMetric.getTangentForOffset(distance);
      if (pos != null) {
        vertices.add(Vector2(pos.position.dx, pos.position.dy));
      }
    }
    verticesList.add(vertices);
  }

  return verticesList;
}

List<List<Vector2>> extractVerticesFromSvg(String svgString) {
  final svgXmlDoc = XmlDocument.parse(svgString);
  final svgPaths = svgXmlDoc.findAllElements('path').map((path) => path.getAttribute('d')!).toList();

  final svgPath = parseSvgPath(svgPaths.first);
  return _convertPathToVertices(svgPath);
}

FixtureDef createChainShapeFixtureFromVertices(List<Vector2> vertices) {
  final shape = ChainShape()..createLoop(vertices);
  return FixtureDef(shape);
}

FixtureDef createPolygonShapeFixtureFromVertices(List<Vector2> vertices) {
  final shape = PolygonShape();
  final simplifiedVertices = vertices; // _simplifyVertices(vertices);

  var rounds = simplifiedVertices.length / 8;
  final reminder = simplifiedVertices.length % 8;

  for (int i = 0; i < rounds; i++) {
    if (reminder < 3) {
      if (i + 2 == rounds) {
        print('i * 8 ${i * 8}, (i + 1) * 8 - (3 - reminder) ${(i + 1) * 8 - (3 - reminder)}');
        shape.set(simplifiedVertices.sublist(i * 8, (i + 1) * 8 - (3 - reminder)).toList());
        continue;
      } else if (i + 1 == rounds) {
        shape.set(simplifiedVertices.sublist(i * 8 - (3 - reminder)).toList());
        continue;
      }
    }

    print('i * 8 ${i * 8}, min((i + 1) * 8, simplifiedVertices.length) ${min((i + 1) * 8, simplifiedVertices.length)}');
    shape.set(simplifiedVertices.sublist(i * 8, min((i + 1) * 8, simplifiedVertices.length)).toList());
  }
  return FixtureDef(shape);
}
