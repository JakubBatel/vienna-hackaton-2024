import 'dart:math' as math;
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/parallax.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame_svg/flame_svg.dart';

void main() {
  runApp(GameWidget(game: OidaGame()));
}

class OidaGame extends FlameGame with HasCollisionDetection, KeyboardEvents {
  late Player player;
  late ParallaxComponent background;
  late TextComponent scoreText;
  late TextComponent title;
  int score = 0;
  final double gravity = 0.8;
  final double jumpForce = -15;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    background = await loadParallaxComponent(
      [ParallaxImageData('background.png')],
      baseVelocity: Vector2(20, 0),
      velocityMultiplierDelta: Vector2(1.2, 1.0),
    );
    add(background);

    player = Player(this);
    add(player);

    add(Platform(Vector2(0, size.y - 20), Vector2(size.x, 20)));
    add(Platform(Vector2(300, size.y - 150), Vector2(200, 20)));
    add(Platform(Vector2(600, size.y - 300), Vector2(200, 20)));

    for (int i = 0; i < 5; i++) {
      add(Collectible(Vector2(math.Random().nextDouble() * size.x, math.Random().nextDouble() * size.y)));
    }

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 20),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 24)),
    );
    add(scoreText);

    title = TextComponent(
      text: 'OIDA',
      position: Vector2(size.x / 2, 60),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 80,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [Colors.purple, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.red],
            ).createShader(Rect.fromLTWH(0, 0, size.x, 100)),
        ),
      ),
    );
    add(title);
  }

  @override
  void update(double dt) {
    super.update(dt);
    title.angle = math.sin(score / 10) * 0.1;
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return KeyEventResult.handled;
  }
}

class Player extends SvgComponent with CollisionCallbacks, KeyboardHandler {
  final OidaGame game;
  final double moveSpeed = 5;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  int spaceCounter = 0;
  int currentSvgIndex = 0;
  bool spacePressed = false;
  List<String> svgPaths = [
    '/images/EggPlayer.svg',
    '/images/baby.svg',
    '/images/bird.svg',
    '/images/crazy.svg',
  ];

  Player(this.game) : super(size: Vector2(50, 50), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await loadSvg();
    position = Vector2(200, 300);
    add(RectangleHitbox());
  }

  Future<void> loadSvg() async {
    svg = await Svg.load(svgPaths[currentSvgIndex]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity.y += game.gravity;
    position += velocity;

    if (position.y > game.size.y - 20) {
      position.y = game.size.y - 20;
      isOnGround = true;
      velocity.y = 0;
    }

    position.x = position.x.clamp(size.x / 2, game.size.x - size.x / 2);
    if (!spacePressed) {
      spaceCounter = 0;
    }
    spacePressed = false;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        velocity.x = -moveSpeed;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocity.x = moveSpeed;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        if (isOnGround) {
          velocity.y = game.jumpForce;
          isOnGround = false;
        }
        if (!spacePressed) {
          spaceCounter++;
          spacePressed = true;
          if (spaceCounter == 3) {
            changeSvg();
            spaceCounter = 0;
          }
        }
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.arrowRight) {
        velocity.x = 0;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        spacePressed = false;
      }
    }

    return true;
  }

  void changeSvg() async {
    currentSvgIndex = (currentSvgIndex + 1) % svgPaths.length;
    await loadSvg();

    if (currentSvgIndex == svgPaths.length - 1) {
      size = Vector2(100, 100);
    } else {
      size = Vector2(50, 50);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Platform) {
      if (velocity.y > 0) {
        isOnGround = true;
        velocity.y = 0;
        position.y = other.position.y;
      }
    } else if (other is Collectible) {
      other.removeFromParent();
      game.score += 10;
      game.scoreText.text = 'Score: ${game.score}';
    }
  }
}

class Platform extends PositionComponent with CollisionCallbacks {
  Platform(Vector2 position, Vector2 size) : super(position: position, size: size) {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), Paint()..color = Colors.green);
  }
}

class Collectible extends CircleComponent with CollisionCallbacks {
  Collectible(Vector2 position) : super(position: position, radius: 10, paint: Paint()..color = Colors.yellow) {
    add(CircleHitbox());
  }
}
