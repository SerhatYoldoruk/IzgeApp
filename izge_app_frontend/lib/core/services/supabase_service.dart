import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:izge_app_frontend/core/models/announcement_model.dart';
import 'package:izge_app_frontend/core/models/chat_model.dart';
import 'package:izge_app_frontend/core/models/event_model.dart';
import 'package:izge_app_frontend/core/models/poll_model.dart';
import 'package:izge_app_frontend/core/models/profile_model.dart';
import 'package:izge_app_frontend/core/models/request_model.dart';
import 'package:izge_app_frontend/features/profile/data/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase Kimlik Doğrulama ve Veritabanı Servis Sınıfı
/// Tüm Supabase işlemleri bu servis üzerinden yapılır
class SupabaseService {
  const SupabaseService();

  /// Singleton instance - uygulamada kullanılacak tek örnek
  static const SupabaseService instance = SupabaseService();

  /// Supabase istemcisine erişim
  SupabaseClient get _client => Supabase.instance.client;

  /// Şu anda oturum açan kullanıcıyı getir (null olabilir)
  User? get currentUser => _client.auth.currentUser;

  /// Oturum açmış bir kullanıcının varlığını kontrol et
  /// Oturum açmamışsa hata fırlatır
  User _requireCurrentUser() {
    final user = currentUser;
    if (user == null) {
      throw StateError('Oturum açılmamış. Bu işlem için kullanıcı gerekli.');
    }
    return user;
  }

  /// Yeni hesap oluştur (kayıt)
  /// E-posta VEYA telefon numarası gereklidir
  /// @param email - E-posta adresi (opsiyonel)
  /// @param phone - Telefon numarası (opsiyonel)
  /// @param password - Şifre (zorunlu)
  /// @param data - Kullanıcı metaverileri (profil adı vb.)
  Future<AuthResponse> signUp({
    String? email,
    String? phone,
    required String password,
    Map<String, dynamic>? data,
  }) {
    // E-posta ile kayıt
    if (email != null && email.isNotEmpty) {
      return _client.auth.signUp(email: email, password: password, data: data);
    }

    // Telefon numarası ile kayıt
    if (phone != null && phone.isNotEmpty) {
      return _client.auth.signUp(phone: phone, password: password, data: data);
    }

    // E-posta veya telefon zorunlu
    throw ArgumentError('Email veya telefon numarası gerekli.');
  }

  /// Oturum aç (giriş yap)
  /// E-posta VEYA telefon numarası ile giriş
  /// @param email - E-posta adresi (opsiyonel)
  /// @param phone - Telefon numarası (opsiyonel)
  /// @param password - Şifre (zorunlu)
  Future<AuthResponse> signIn({
    String? email,
    String? phone,
    required String password,
  }) async {
    AuthResponse response;

    // E-posta ile giriş
    if (email != null && email.isNotEmpty) {
      response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    }
    // Telefon numarası ile giriş
    else if (phone != null && phone.isNotEmpty) {
      response = await _client.auth.signInWithPassword(
        phone: phone,
        password: password,
      );
    }
    // E-posta veya telefon zorunlu
    else {
      throw ArgumentError('Email veya telefon numarası gerekli.');
    }

    // Oturum başarısız mı kontrol et (session null ise hata)
    if (response.session == null) {
      throw StateError('Giriş başarısız. Lütfen bilgilerinizi kontrol edin.');
    }

    return response;
  }

  /// Google OAuth ile giriş yap
  Future<bool> signInWithGoogle() {
    return _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'izgeapp://login-callback',
    );
  }

  /// Şifre sıfırlama bağlantısı gönder
  /// @param email - Kullanıcının kayıtlı e-posta adresi
  Future<void> resetPassword({required String email}) async {
    // Supabase Flutter v2 API: resetPasswordForEmail göndererek e-posta ile sıfırlama bağlantısı yollar
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Kullanıcının şifresini güncelle
  Future<void> updatePassword(String newPassword) async {
    _requireCurrentUser();
    await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Kullanıcının profil bilgilerini getir
  /// Veritabanında profiles tablosundan kullanıcı ID'sine göre çeker
  Future<ProfileModel> getProfile() async {
    // Oturum açmış kullanıcı var mı kontrol et
    final user = _requireCurrentUser();

    // Kullanıcı profilini getir
    final data = await _client
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single();
    return ProfileModel.fromMap(Map<String, dynamic>.from(data as Map));
  }

  /// Tüm duyuruları getir (sabitlenenleri öncelikli, tarih sırasıyla)
  Future<List<AnnouncementModel>> getAnnouncements() async {
    final list = await _fetchList(
      _client
          .from('announcements')
          .select('*')
          .order('is_pinned', ascending: false) // Sabitlenenler önce
          .order('created_at', ascending: false), // Sonra yeni tarihli
    );
    return list.map((e) => AnnouncementModel.fromMap(e)).toList();
  }

  /// Tüm etkinlikleri getir (etkinlik tarihine göre sıralı)
  Future<List<EventModel>> getEvents() async {
    try {
      final list = await _fetchList(
        _client.from('events').select('*').order('event_date'),
      );
      final dbEvents = list.map((e) => EventModel.fromMap(e)).toList();
      final mockEvents = _getMockEvents();
      
      // Veritabanındaki etkinliklerle çakışmayan mock etkinlikleri ekle
      final mergedEvents = [...dbEvents];
      for (var mock in mockEvents) {
        if (!dbEvents.any((e) => e.title == mock.title || e.id == mock.id)) {
          mergedEvents.add(mock);
        }
      }
      
      // Tarihe göre sırala
      mergedEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));
      return mergedEvents;
    } catch (e) {
      debugPrint("Supabase getEvents Hatası: ${e.toString()}");
      return _getMockEvents();
    }
  }

  List<EventModel> _getMockEvents() {
    return [
      EventModel(
        id: 'mock-1',
        title: 'Engelsiz Sanat Atölyesi',
        description: 'Engelsiz sanat atölyemizde hep birlikte eğlenerek resim yapıyoruz. Katılım ücretsizdir.',
        location: 'Dernek Merkezi',
        eventDate: DateTime(2026, 6, 25, 14, 0),
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDGTs43uEzKfQgQaDQCaRtBQu_Oth0Aus6SBD3WB_IeRinE7kd5inHcu7C37POlGSXRA-wlxEqOdzzFcseR8IVUgkBv4ZKZPoh8V-cRqUVn4b712z65k7Jjps9foZlIzOJwddroLVQiFcaKfoszvnWn8cCFzDPDaot50L45ND8Yppji874rEXsIgCbh8FjQ07ho7D882dVMc8hh3WxOZxVl-Avi8b_1WlICdaRaU5necZ1fhIcKzHoFZZvFHmE1Zf19LO_8fM46yO9R',
        createdAt: DateTime(2026, 6, 20),
      ),
      EventModel(
        id: 'mock-2',
        title: 'Gönüllü Oryantasyonu',
        description: 'Yeni gönüllülerimiz için bilgilendirme ve oryantasyon toplantısı.',
        location: 'Online (Zoom)',
        eventDate: DateTime(2026, 6, 30, 10, 0),
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB0CQ0YKkBelvgVX2mWxOYdHfdv_fVcRylaC3xInAUfWY4AM6MCpHp5nMaKz8-KzctmM-Ei4Ptbtq2TvevAuzj9FZhsNgd99KJy0BJvj8G2-_Ym0SN0KS-y68o9hH6ZPGI1UxxkVY20QKD5hqHfhVg5jl9vsDJSWpi4qAbb1raNZC5RUJMmPw6kR9aHL7w26mP_Cfz8a5GImjEPuDSNXyoETC9-Bft8N4sn90hMeQ_FwKbolUFmGty8J8hEs5iHbCS61AKx6ixtS3D2',
        createdAt: DateTime(2026, 6, 20),
      ),
      EventModel(
        id: 'mock-3',
        title: 'Erişilebilirlik Zirvesi 2023',
        description: 'Engelsiz yaşam teknolojileri ve erişilebilirlik zirvesi.',
        location: 'İstanbul Kültür Merkezi',
        eventDate: DateTime(2023, 5, 15, 10, 0),
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBoCBOPjMbkzEing5qM6DKlzUxW-28zD8K53cSh8_pX3XOBqqSFuFqf91qPL8rJUBStOCgJOU-BJPCYIYowRyg15xL_9W29Fdvr8TPfMLOP9CDGpAl2mJBcejd9FR_SrycHf-R80U8QfB-A7YKyMhRXNA9A_pyHzBA7i7gcGaepCq3CXvZO_V4rd-wYluvWzB1rG1ATJ5jnda_TxHWY559eMQ-caafirhJlupoQ5j5H5oOk42ODKJ_GytC-QLkSMiOLMCJuMAWWdgc6',
        createdAt: DateTime(2023, 5, 10),
      ),
      EventModel(
        id: 'mock-4',
        title: 'Engelsiz Basketbol Turnuvası',
        description: 'Engelsiz basketbol turnuvamızda sporseverleri bir araya getiriyoruz.',
        location: 'Atatürk Spor Kompleksi',
        eventDate: DateTime(2026, 4, 2, 14, 30),
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC1jXOtHy9xj4KDHw0FCQUM2f-m0xEWqic8QsRrs0dY94HNlJSW1QqLW89y-0Z38FpTIAxpDOMGNQIi9D8rFsYwbmUbiiF3iH-zQwrjjZJ3vyjgzBbwmP9Q_rBeg0AyxrAn8f1G3IOPfEHwqBBJK0rDZBjy7Te5A3rMbb5zsKjrDrUMc9ACnFfRuTzQiE9lQm_0q6W4wlRNw6fGx_dTOxf1O6_DCNICJBEMGv_5lSgEx2Zgq9UBCZuwkHPA305NfJCzNWYSt_ST_Rks',
        createdAt: DateTime(2026, 3, 28),
      ),
      EventModel(
        id: 'mock-5',
        title: 'Dijital Okuryazarlık Atölyesi',
        description: 'Temel dijital becerilerin geliştirilmesi hedefleyen online atölye.',
        location: 'Online (Zoom)',
        eventDate: DateTime(2026, 3, 12, 19, 0),
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA5gjjK3hv68CWx42xKMB8Erx0P8soNOPcLd9jTXALxCo_lMMNfJJle967DPuz-3LZR5RGLQAJTwpfx2pVR83m3iSmrE2fxoq5HoI7NZkUV4Mbd1akLnOnQJsMO77jDaiIHTgR8DSQl126ma2D6OmVtoQHihGw4c1CfnXGR3KuMQU3M6J7jBQkr1EbNdGFncnWUGWkDAKlTw6T9A82ajahq98-Q4rQnKwbKFLa2fjffA_XFI9sCXt25wE0jk9Tio_bogTSuUGT6an7g',
        createdAt: DateTime(2026, 3, 5),
      ),
    ];
  }


  /// Tüm etkinlik günlerini getir
  Future<List<Map<String, dynamic>>> getEventDays() {
    return _fetchList(_client.from('event_days').select('*'));
  }

  /// Tüm anketleri getir
  Future<List<PollModel>> getPolls() async {
    final list = await _fetchList(
      _client.from('polls').select('*, poll_options(*)'),
    );
    return list.map((e) => PollModel.fromMap(e)).toList();
  }

  /// Kullanıcının kendi taleplerini getir
  Future<List<RequestModel>> getRequests() async {
    final user = _requireCurrentUser();
    final list = await _fetchList(
      _client
          .from('requests')
          .select('*')
          .eq('user_id', user.id)
          .order('created_at', ascending: false),
    );
    return list.map((e) => RequestModel.fromMap(e)).toList();
  }

  /// Yeni talep oluştur
  Future<RequestModel> createRequest({
    required String title,
    required String description,
    required String requestType,
  }) async {
    final user = _requireCurrentUser();
    final data = await _client.from('requests').insert({
      'user_id': user.id,
      'title': title,
      'description': description,
      'request_type': requestType,
    }).select().single();
    return RequestModel.fromMap(data);
  }

  /// Talep No (kısa ID) ile talep getir
  Future<RequestModel?> getRequestByShortId(String shortId) async {
    final cleanId = shortId.toUpperCase().replaceAll('TLP-', '').trim().toLowerCase();
    if (cleanId.isEmpty) return null;
    
    try {
      final user = _requireCurrentUser();
      final list = await _fetchList(
        _client
            .from('requests')
            .select('*')
            .eq('user_id', user.id)
            .order('created_at', ascending: false),
      );
      final requests = list.map((e) => RequestModel.fromMap(e)).toList();
      // İlk 8 karakter ile eşleşen talebi bul
      for (final req in requests) {
        if (req.id.toLowerCase().startsWith(cleanId)) {
          return req;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> vote({required String pollId, required String optionText}) async {
    final user = _requireCurrentUser();
    
    final optionData = await _client
        .from('poll_options')
        .select('id')
        .eq('poll_id', pollId)
        .eq('option_text', optionText)
        .single();

    await _client.from('poll_votes').insert({
      'poll_id': pollId,
      'option_id': optionData['id'],
      'user_id': user.id,
    });
  }

  Future<List<Map<String, dynamic>>> getPollResults(String pollId) async {
    final votes = await _fetchList(
      _client.from('poll_votes').select('poll_options!inner(option_text)').eq('poll_id', pollId),
    );
    
    return votes.map((v) => {
      'option_text': v['poll_options']['option_text']
    }).toList();
  }

  Future<String?> getUserVote(String pollId) async {
    final user = _requireCurrentUser();
    try {
      final data = await _client
          .from('poll_votes')
          .select('poll_options!inner(option_text)')
          .eq('poll_id', pollId)
          .eq('user_id', user.id)
          .maybeSingle();
      
      if (data != null) {
        return data['poll_options']['option_text'] as String;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ChatRoomModel> getChatRoom() async {
    final user = _requireCurrentUser();
    final data = await _client
        .from('chat_rooms')
        .select('*')
        .eq('user_id', user.id)
        .single();
    return ChatRoomModel.fromMap(Map<String, dynamic>.from(data as Map));
  }

  Future<List<MessageModel>> getMessages(int roomId) async {
    final list = await _fetchList(
      _client
          .from('messages')
          .select('*')
          .eq('room_id', roomId)
          .order('created_at'),
    );
    return list.map((e) => MessageModel.fromMap(e)).toList();
  }

  Future<void> sendMessage({
    required int roomId,
    required String message,
  }) async {
    final user = _requireCurrentUser();
    await _client.from('messages').insert({
      'room_id': roomId,
      'sender_id': user.id,
      'message_text': message,
    });
  }

  RealtimeChannel subscribeToMessages({
    required int roomId,
    required void Function(MessageModel newMessage) onMessage,
  }) {
    final channel = _client.channel('chat-room-$roomId');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'room_id',
        value: roomId,
      ),
      callback: (payload) {
        onMessage(
          MessageModel.fromMap(Map<String, dynamic>.from(payload.newRecord)),
        );
      },
    );

    channel.subscribe();
    return channel;
  }

  Future<String> uploadAvatar({
    required String path,
    required File file,
  }) async {
    await _client.storage.from('avatar').upload(path, file);
    return getAvatarUrl(path);
  }

  String getAvatarUrl(String path) {
    return _client.storage.from('avatar').getPublicUrl(path);
  }

  // =========================================
  // BİLDİRİMLER (NOTIFICATIONS) FONKSİYONLARI
  // =========================================

  /// Kullanıcının tüm bildirimlerini getir
  Future<List<NotificationModel>> getNotifications() async {
    final user = _requireCurrentUser();
    final list = await _fetchList(
      _client
          .from('notifications')
          .select('*')
          .eq('user_id', user.id)
          .order('created_at', ascending: false),
    );
    return list.map((e) => NotificationModel.fromJson(e)).toList();
  }

  /// Okunmamış bildirim sayısını getir
  Future<int> getUnreadNotificationCount() async {
    final user = currentUser;
    if (user == null) return 0;
    
    final data = await _client
        .from('notifications')
        .select('id')
        .eq('user_id', user.id)
        .eq('is_read', false);
    
    // Supabase returns count in the response object
    return data.length; // The length of the returned list corresponds to the count
  }

  /// Tek bir bildirimi okundu olarak işaretle
  Future<void> markNotificationAsRead(int notificationId) async {
    final user = _requireCurrentUser();
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId)
        .eq('user_id', user.id);
  }

  /// Kullanıcının tüm bildirimlerini okundu olarak işaretle
  Future<void> markAllNotificationsAsRead() async {
    final user = _requireCurrentUser();
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', user.id)
        .eq('is_read', false);
  }

  /// Bildirimleri canlı dinle
  RealtimeChannel subscribeToNotifications({
    required void Function(NotificationModel newNotification) onNotification,
  }) {
    final user = _requireCurrentUser();
    final channel = _client.channel('notifications-${user.id}');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'notifications',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'user_id',
        value: user.id,
      ),
      callback: (payload) {
        onNotification(
          NotificationModel.fromJson(Map<String, dynamic>.from(payload.newRecord)),
        );
      },
    );

    channel.subscribe();
    return channel;
  }

  // ==========================================
  // INSTITUTIONS MAP (PLACE REVIEWS)
  // ==========================================

  /// Belirli bir alandaki veya tüm mekan oylarını (review) getirir
  Future<List<Map<String, dynamic>>> getPlaceReviews({List<String>? osmIds}) async {
    var query = _client.from('place_reviews').select();
    if (osmIds != null && osmIds.isNotEmpty) {
      query = query.inFilter('osm_id', osmIds);
    }
    return _fetchList(query);
  }

  /// Bir mekan için oy gönderir veya günceller
  Future<void> submitPlaceReview({
    required String osmId,
    required double rating,
    required bool isAutismFriendly,
    required bool hasWheelchairAccess,
    String? reviewText,
  }) async {
    final user = _requireCurrentUser();
    await _client.from('place_reviews').upsert({
      'osm_id': osmId,
      'user_id': user.id,
      'rating': rating,
      'is_autism_friendly': isAutismFriendly,
      'has_wheelchair_access': hasWheelchairAccess,
      'review_text': reviewText,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'osm_id, user_id');
  }

  Future<List<Map<String, dynamic>>> _fetchList(Future<dynamic> query) async {
    final data = await query;
    final rows = (data as List).cast<dynamic>();
    return rows
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList(growable: false);
  }
}
