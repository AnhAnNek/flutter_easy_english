import 'dart:async';
import 'dart:convert';

import 'package:flutter_easy_english/utils/auth_utils.dart';
import 'package:flutter_easy_english/utils/environment.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:logger/logger.dart';

class WebSocketService {
  // Singleton instance
  static final WebSocketService _instance = WebSocketService._internal();

  // Factory constructor to return the singleton instance
  factory WebSocketService() {
    return _instance;
  }

  // Private constructor for internal use
  WebSocketService._internal();

  // Class properties
  late StompClient client;
  final _logger = Logger();
  final Map<String, Function> subscribers = {};
  String? url;
  int reconnectDelay = 5000; // Reconnect delay in milliseconds
  bool connected = false;
  final Map<String, StompUnsubscribe?> subscriptionHandles = {};
  Function? onConnectedCallback;

  // Connect to the WebSocket server
  void connect(Function onConnected) {
    if (connected) {
      _logger.i('Already connected to WebSocket');
      return;
    }

    url = Environment.wsUrl;
    onConnectedCallback = onConnected;
    _createClient();
  }

  // Create and activate the Stomp client
  void _createClient() async {
    try {
      final token = await AuthUtils.getToken();
      if (token == null || token.isEmpty) {
        _logger.e('Token is null or empty. Cannot connect to WebSocket.');
        return;
      }

      _logger.i('_createClient - Token: $token');
      _logger.i('WebSocket URL: $url');
      client = StompClient(
        config: StompConfig(
          stompConnectHeaders: {
            'Authorization': 'Bearer ${token}',
          },
          webSocketConnectHeaders: {
            'Authorization': 'Bearer ${token}',
          },
          url: url!,
          onConnect: (StompFrame frame) {
            _logger.i('Connected to WebSocket');
            connected = true;
            _onConnect();

            // Execute the onConnected callback if provided
            if (onConnectedCallback != null) {
              onConnectedCallback!();
            }
          },
          onDisconnect: (_) {
            _logger.i('Disconnected from WebSocket');
            connected = false;
            _scheduleReconnect();
          },
          onStompError: (frame) {
            _logger.e('STOMP Error: ${frame.headers["message"]}');
          },
          onWebSocketError: (dynamic error) {
            _logger.e('WebSocket Error: $error');
          },
          onWebSocketDone: () {
            _logger.i('WebSocket connection closed.');
            connected = false;
            _scheduleReconnect();
          },
        ),
      );
      client.activate();
    } catch (e) {
      _logger.e('Failed to connect to WebSocket: $e');
      _scheduleReconnect();
    }
  }

  // Schedule reconnection
  void _scheduleReconnect() {
    Future.delayed(Duration(milliseconds: reconnectDelay), () {
      if (!connected) {
        _logger.i('Attempting to reconnect...');
        _createClient();
      }
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
        headers: {},
        callback: (frame) {
          if (callback != null) {
            final payload = json.decode(frame.body!);
            callback(payload);
          }
        },
      );

      subscriptionHandles[destination] = subscription;
      _logger.i('Subscribed to $destination');
    } else {
      _logger.e('WebSocket client not connected. Unable to subscribe.');
    }
  }

  // Unsubscribe from a topic
  void unsubscribe(String destination) {
    if (subscriptionHandles.containsKey(destination)) {
      subscriptionHandles[destination]?.call(); // Call the unsubscribe function
      subscriptionHandles.remove(destination);
      subscribers.remove(destination);
      _logger.i('Unsubscribed from $destination');
    } else {
      _logger.e('No subscription found for destination: $destination');
    }
  }

  // Send a message to a topic
  void send(String destination, Map<String, dynamic> body) {
    if (client.connected) {
      // Send message with JSON encoded body
      client.send(destination: destination, body: json.encode(body), headers: {});
      _logger.i('Message sent to $destination: $body');
    } else {
      _logger.e('WebSocket client not connected. Unable to send message.');
    }
  }

  // Disconnect from the WebSocket
  void disconnect() {
    if (connected) {
      client.deactivate();
      connected = false;
      _logger.i('Disconnected from WebSocket');
    } else {
      _logger.i('WebSocket is already disconnected.');
    }
  }
}