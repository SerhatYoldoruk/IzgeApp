import 'dart:io';

import 'package:izge_app_frontend/core/models/announcement_model.dart';
import 'package:izge_app_frontend/core/models/chat_model.dart';
import 'package:izge_app_frontend/core/models/event_model.dart';
import 'package:izge_app_frontend/core/models/poll_model.dart';
import 'package:izge_app_frontend/core/models/profile_model.dart';
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
    return _client.auth.signInWithOAuth(OAuthProvider.google);
  }

  /// Şifre sıfırlama bağlantısı gönder
  /// @param email - Kullanıcının kayıtlı e-posta adresi
  Future<void> resetPassword({required String email}) async {
    // Supabase Flutter v2 API: resetPasswordForEmail göndererek e-posta ile sıfırlama bağlantısı yollar
    await _client.auth.resetPasswordForEmail(email);
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
    final list = await _fetchList(
      _client.from('events').select('*').order('event_date'),
    );
    return list.map((e) => EventModel.fromMap(e)).toList();
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

  Future<void> vote({required String pollId, required int optionIndex}) async {
    final user = _requireCurrentUser();
    await _client.from('poll_votes').insert({
      'poll_id': pollId,
      'option_index': optionIndex,
      'user_id': user.id,
    });
  }

  Future<List<Map<String, dynamic>>> getPollResults(String pollId) {
    return _fetchList(
      _client.from('poll_votes').select('option_index').eq('poll_id', pollId),
    );
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

  Future<List<Map<String, dynamic>>> _fetchList(Future<dynamic> query) async {
    final data = await query;
    final rows = (data as List).cast<dynamic>();
    return rows
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList(growable: false);
  }
}
