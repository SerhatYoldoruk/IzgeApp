import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:izge_app_frontend/core/services/supabase_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // 1. Initialize Firebase App
      await Firebase.initializeApp();

      // 2. Set background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 3. Initialize Local Notifications for Foreground push
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const InitializationSettings initSettings =
          InitializationSettings(android: androidSettings, iOS: iosSettings);

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          // Handle tap on foreground notification
          _handleNotificationClick(details.payload);
        },
      );

      // 4. Request Permissions & Register Token
      await requestPermissions();
      await updateFcmToken();

      // 5. Listen for token refresh
      _messaging.onTokenRefresh.listen((token) {
        final deviceType = Platform.isAndroid ? 'android' : 'ios';
        SupabaseService.instance.saveDeviceToken(fcmToken: token, deviceType: deviceType);
      });

      // 6. Set foreground message handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 7. Set open app handlers (when notification is clicked)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotificationClick(message.data['payload']);
      });

      // Handle app opened from terminated state
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationClick(initialMessage.data['payload']);
      }

      _initialized = true;
    } catch (e) {
      if (kDebugMode) print('Error initializing NotificationService: $e');
    }
  }

  Future<void> requestPermissions() async {
    // Request permission from OS
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    if (Platform.isAndroid) {
      // Create High Importance channel for local foreground notifications
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'izge_push_channel',
        'İzge Bildirim Kanalı',
        description: 'İzge App bildirimleri için kullanılan varsayılan kanal.',
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> updateFcmToken() async {
    final user = SupabaseService.instance.currentUser;
    if (user == null) return;

    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        final deviceType = Platform.isAndroid ? 'android' : 'ios';
        await SupabaseService.instance.saveDeviceToken(fcmToken: token, deviceType: deviceType);
      }
    } catch (e) {
      if (kDebugMode) print('Failed to get FCM token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'izge_push_channel',
            'İzge Bildirim Kanalı',
            channelDescription: 'İzge App bildirimleri için kullanılan varsayılan kanal.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data['payload'],
      );
    }
  }

  void _handleNotificationClick(String? payload) {
    if (payload == null) return;
    // Custom routing can be implemented here based on the payload structure.
  }
}
