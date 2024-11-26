import 'dart:async';
import 'dart:convert';

import 'package:flutter_easy_english/utils/environment.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late StompClient client;
  final Map<String, Function> subscribers = {};
  String? url;
  int reconnectDelay = 5000; // Reconnect delay in milliseconds
  bool connected = false;
  final Map<String, StompUnsubscribe?> subscriptionHandles = {}; // Corrected to StompUnsubscribe
  Function? onConnectedCallback;

  WebSocketService();

  // Connect to the WebSocket server
  void connect(Function onConnected) {
    url = Environment.wsUrl; // Replace with your WebSocket URL
    onConnectedCallback = onConnected;
    _createClient();
  }

  // Create and activate the Stomp client
  void _createClient() {
    final channel = WebSocketChannel.connect(Uri.parse(url!));
    client = StompClient(
      config: StompConfig(
        url: url!,
        onConnect: (StompFrame frame) {
          print('Connected to WebSocket');
          connected = true;
          _onConnect();

          // Execute the onConnected callback if provided
          if (onConnectedCallback != null) {
            onConnectedCallback!();
          }
        },
        onDisconnect: (_) {
          print('Disconnected from WebSocket');
          connected = false;
          _scheduleReconnect();
        },
        onStompError: (frame) {
          print('Error: ${frame.headers["message"]}');
        },
        webSocketConnectHeaders: {'Authorization': 'Bearer YOUR_TOKEN'}, // Optional header
      ),
    );
    client.activate();
  }

  // Schedule reconnection
  void _scheduleReconnect() {
    Future.delayed(Duration(milliseconds: reconnectDelay), () {
      print('Attempting to reconnect...');
      _createClient();
    });
  }

  // Perform subscriptions after connection is made
  void _onConnect() {
    subscribers.forEach((destination, callback) {
      subscribe(destination, callback);
    });
  }

  // Subscribe to a topic and provide a callback for messages
  void subscribe(String destination, Function callback) {
    if (client.connected) {
      subscribers[destination] = callback;

      // Subscribe and save the unsubscribe handle
      final subscription = client.subscribe(
        destination: destination,
        callback: (frame) {
          if (callback != null) {
            final payload = json.decode(frame.body!);
            callback(payload);
          }
        },
      );

      subscriptionHandles[destination] = subscription;
      print('Subscribed to $destination');
    } else {
      print('WebSocket client not connected. Unable to subscribe.');
    }
  }

  // Unsubscribe from a topic
  void unsubscribe(String destination) {
    if (subscriptionHandles.containsKey(destination)) {
      subscriptionHandles[destination]?.call(); // Call the unsubscribe function
      subscriptionHandles.remove(destination);
      subscribers.remove(destination);
      print('Unsubscribed from $destination');
    } else {
      print('No subscription found for destination: $destination');
    }
  }

  // Send a message to a topic
  void send(String destination, Map<String, dynamic> body) {
    if (client.connected) {
      // Send message with JSON encoded body
      client.send(destination: destination, body: json.encode(body));
      print('Message sent to $destination: $body');
    } else {
      print('WebSocket client not connected. Unable to send message.');
    }
  }

  // Disconnect from the WebSocket
  void disconnect() {
    if (client != null) {
      client.deactivate();
      connected = false;
      print('Disconnected from WebSocket');
    }
  }
}

final websocketService = WebSocketService();