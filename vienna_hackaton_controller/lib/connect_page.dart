import 'dart:io';

import 'package:flutter/material.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  late final TextEditingController _ipAddrController;
  late final TextEditingController _messageController;
  WebSocket? _socket;

  @override
  void initState() {
    super.initState();
    _ipAddrController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _socket == null
                  ? [
                      TextField(
                        controller: _ipAddrController,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _connectWebSocket,
                        child: Text('Connect'),
                      )
                    ]
                  : [
                      TextField(
                        controller: _messageController,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _sendMessage,
                        child: Text('Send'),
                      )
                    ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _connectWebSocket() async {
    final url = 'ws://${_ipAddrController.text}/ws';
    final s = await WebSocket.connect('ws://192.168.1.56:3000/ws');
    setState(() => _socket = s);
    s.listen((message) {
      print(message);
    });
  }

  void _sendMessage() {
    final message = _messageController.text;
    _socket?.add(message);
    _messageController.clear();
  }
}
