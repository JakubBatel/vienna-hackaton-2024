import 'dart:async';
import 'dart:io';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:vienna_hackaton_display/components/background_component.dart';
import 'package:vienna_hackaton_display/components/egg_component.dart';
import 'package:vienna_hackaton_display/components/groud_component.dart';

class OjdaWorld extends Forge2DWorld {
  StreamSubscription? _connectionSubscription;

  OjdaWorld();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    debugMode = kDebugMode;

    await _createServer();

    await _loadLevel();
  }

  @override
  void onRemove() {
    _connectionSubscription?.cancel();
    super.onRemove();
  }

  Future<void> _createServer() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
    final ipAddr = await _getLocalIP();
    print('Server running on ws://$ipAddr:${server.port}');

    _connectionSubscription = server.listen((request) async {
      if (request.uri.path == '/ws') {
        try {
          final socket = await WebSocketTransformer.upgrade(request);
          socket.listen((message) {
            print('Received: $message');
            socket.add('Echo: $message');
          });
        } catch (e) {
          print('Upgrade failed: $e');
        }
      }
    });
  }

  Future<void> _loadLevel() async {
    add(BackgroundComponent());
    add(GroundComponent(svgName: 'images/TryoutFloor.svg'));
    add(EggComponent(svgName: 'images/EggCharacter01.svg'));
  }
}

Future<String> _getLocalIP() async {
  final interfaces = await NetworkInterface.list();
  for (var netInterface in interfaces) {
    for (var address in netInterface.addresses) {
      if (address.type == InternetAddressType.IPv4 && !address.isLoopback) {
        return address.address;
      }
    }
  }
  return '127.0.0.1'; // Fallback to localhost
}
