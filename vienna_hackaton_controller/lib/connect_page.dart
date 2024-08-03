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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _socket == null
                  ? [
                      TextField(
                        controller: _ipAddrController,
                        decoration: const InputDecoration(
                          labelText: 'Enter IP Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.network_wifi),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _connectWebSocket,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: const Text('Connect'),
                      )
                    ]
                  : [
                      TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Type your message',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.message),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _sendMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: const Text('Send'),
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
