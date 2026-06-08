import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/features/events/presentation/pages/events_screen.dart';
import 'package:izge_app_frontend/features/news/presentation/pages/news_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donate_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/donation_history_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/help_center_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/membership_help_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/notifications_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/past_requests_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/profile_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/contact_support_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/change_password_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/change_photo_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/rights_obligations_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/how_to_become_member_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/dues_operations_screen.dart';
import 'package:izge_app_frontend/features/profile/presentation/pages/privacy_policy_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveSupportScreen extends StatefulWidget {
  const LiveSupportScreen({super.key});

  @override
  State<LiveSupportScreen> createState() => _LiveSupportScreenState();
}

class _LiveSupportScreenState extends State<LiveSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isTyping = false;
  bool _isListening = false;

  final List<String> _quickReplies = [
    "📍 İletişim Bilgileri",
    "💖 Nasıl Bağış Yaparım?",
    "🤝 Gönüllü Olmak İstiyorum",
    "📅 Yaklaşan Etkinlikler",
    "📰 Son Haberler",
  ];

  // Supabase AI için messages formatı (role: user/model)
  final List<Map<String, dynamic>> _messages = [
    {
      "role": "model",
      "parts": [
        {
          "text":
              "Merhaba! İzge Uygulaması Destek Hattına hoş geldiniz. Ben İzgeBot, size nasıl yardımcı olabilirim?",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speech.initialize();
  }

  Future<void> _sendMessage({String? customText}) async {
    if (_isTyping) return;

    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        "role": "user",
        "parts": [
          {"text": text},
        ],
      });
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      final messagesToSend = _messages
          .skip(1)
          .map((m) => {"role": m["role"], "parts": m["parts"]})
          .toList();

      final response = await Supabase.instance.client.functions.invoke(
        'izgebot',
        body: {'messages': messagesToSend},
      );

      final reply = response.data['reply'] as String;

      setState(() {
        _messages.add({
          "role": "model",
          "parts": [
            {"text": reply},
          ],
        });
      });
      _scrollToBottom();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Bot Hatası: $e');
      }
      setState(() {
        _messages.add({
          "role": "model",
          "parts": [
            {"text": "Bağlantı hatası oluştu. Lütfen tekrar deneyin."},
          ],
        });
      });
      _scrollToBottom();
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _navigateTo(String action) {
    switch (action) {
      case 'GO_TO_DONATE':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DonateScreen()),
        );
        break;
      case 'GO_TO_EVENTS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EventsScreen()),
        );
        break;
      case 'GO_TO_NEWS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewsScreen()),
        );
        break;
      case 'GO_TO_REQUESTS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PastRequestsScreen()),
        );
        break;
      case 'GO_TO_DONATION_HISTORY':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DonationHistoryScreen()),
        );
        break;
      case 'GO_TO_MEMBERSHIP':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MembershipHelpScreen()),
        );
        break;
      case 'GO_TO_HELP':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
        );
        break;
      case 'GO_TO_PROFILE':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
      case 'GO_TO_NOTIFICATIONS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
        break;
      case 'GO_TO_CONTACT':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ContactSupportScreen()),
        );
        break;
      case 'GO_TO_CHANGE_PASSWORD':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
        );
        break;
      case 'GO_TO_EDIT_PROFILE':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditProfileScreen()),
        );
        break;
      case 'GO_TO_CHANGE_PHOTO':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChangePhotoScreen()),
        );
        break;
      case 'GO_TO_RIGHTS_OBLIGATIONS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RightsObligationsScreen()),
        );
        break;
      case 'GO_TO_HOW_TO_BECOME_MEMBER':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HowToBecomeMemberScreen()),
        );
        break;
      case 'GO_TO_DUES_OPERATIONS':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DuesOperationsScreen()),
        );
        break;
      case 'GO_TO_PRIVACY_POLICY':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
        );
        break;
    }
  }

  Map<String, dynamic>? _getActionInfo(String? action) {
    if (action == null) return null;
    const map = {
      'GO_TO_DONATE': {'label': 'Bağış Yap', 'icon': Icons.favorite},
      'GO_TO_EVENTS': {'label': 'Etkinliklere Git', 'icon': Icons.event},
      'GO_TO_NEWS': {'label': 'Haberlere Git', 'icon': Icons.article},
      'GO_TO_REQUESTS': {'label': 'Taleplerime Git', 'icon': Icons.assignment},
      'GO_TO_DONATION_HISTORY': {
        'label': 'Bağış Geçmişim',
        'icon': Icons.history,
      },
      'GO_TO_MEMBERSHIP': {'label': 'Üyelik İşlemleri', 'icon': Icons.badge},
      'GO_TO_HELP': {
        'label': 'Yardım Merkezine Git',
        'icon': Icons.help_outline,
      },
      'GO_TO_PROFILE': {'label': 'Profilime Git', 'icon': Icons.person},
      'GO_TO_NOTIFICATIONS': {
        'label': 'Bildirimlerime Git',
        'icon': Icons.notifications_none,
      },
      'GO_TO_CONTACT': {
        'label': 'İletişime Geç',
        'icon': Icons.contact_support,
      },
      'GO_TO_CHANGE_PASSWORD': {
        'label': 'Şifre Değiştir',
        'icon': Icons.lock_reset,
      },
      'GO_TO_EDIT_PROFILE': {
        'label': 'Profili Düzenle',
        'icon': Icons.edit,
      },
      'GO_TO_CHANGE_PHOTO': {
        'label': 'Fotoğraf Değiştir',
        'icon': Icons.photo_camera,
      },
      'GO_TO_RIGHTS_OBLIGATIONS': {
        'label': 'Haklar & Yükümlülükler',
        'icon': Icons.gavel,
      },
      'GO_TO_HOW_TO_BECOME_MEMBER': {
        'label': 'Nasıl Üye Olunur?',
        'icon': Icons.help_center,
      },
      'GO_TO_DUES_OPERATIONS': {
        'label': 'Aidat İşlemleri',
        'icon': Icons.payments,
      },
      'GO_TO_PRIVACY_POLICY': {
        'label': 'Gizlilik Politikası',
        'icon': Icons.privacy_tip,
      },
    };
    return map[action];
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _messageController.text = val.recognizedWords;
            });
          },
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageContent(Map<String, dynamic> message, bool isMe) {
    String text = "";
    if (message['parts'] != null && message['parts'].isNotEmpty) {
      for (var part in message['parts']) {
        if (part['text'] != null) text += part['text'];
      }
    }

    String? action;
    const actionCodes = [
      'GO_TO_DONATE',
      'GO_TO_EVENTS',
      'GO_TO_NEWS',
      'GO_TO_REQUESTS',
      'GO_TO_DONATION_HISTORY',
      'GO_TO_MEMBERSHIP',
      'GO_TO_HELP',
      'GO_TO_PROFILE',
      'GO_TO_NOTIFICATIONS',
      'GO_TO_CONTACT',
      'GO_TO_CHANGE_PASSWORD',
      'GO_TO_EDIT_PROFILE',
      'GO_TO_CHANGE_PHOTO',
      'GO_TO_RIGHTS_OBLIGATIONS',
      'GO_TO_HOW_TO_BECOME_MEMBER',
      'GO_TO_DUES_OPERATIONS',
      'GO_TO_PRIVACY_POLICY',
    ];
    for (final code in actionCodes) {
      if (text.contains('[ACTION:$code]')) {
        action = code;
        text = text.replaceAll('[ACTION:$code]', '').trim();
        break;
      }
    }

    // Aksiyon etiket ve ikon bilgisi
    final actionInfo = _getActionInfo(action);

    return Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (text.isNotEmpty)
          Text(
            text,
            style: TextStyle(
              color: isMe ? Colors.white : AppColors.textPrimary,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        if (action != null && actionInfo != null)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: ElevatedButton.icon(
              onPressed: () => _navigateTo(action!),
              icon: Icon(actionInfo['icon'] as IconData, size: 18),
              label: Text(actionInfo['label'] as String),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7ADC75),
                foregroundColor: const Color(0xFF003908),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuickReplies() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _quickReplies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final reply = _quickReplies[index];
          return ActionChip(
            label: Text(
              reply,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
            ),
            backgroundColor: AppColors.surfaceElevated,
            side: BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () => _sendMessage(customText: reply),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF7ADC75)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7ADC75), Color(0xFF1A8025)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF7ADC75).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surface,
                child: Icon(
                  Icons.smart_toy,
                  color: Color(0xFF7ADC75),
                  size: 22,
                ),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'İzgeBot Asistan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF7ADC75),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Çevrimiçi (Yapay Zeka)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }

                final message = _messages[index];
                final isMe = message['role'] == 'user';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isMe) const SizedBox(width: 48),
                      if (!isMe)
                        Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.surfaceElevated,
                            child: Icon(
                              Icons.smart_toy,
                              color: Color(0xFF7ADC75),
                              size: 16,
                            ),
                          ),
                        ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? null : AppColors.surfaceElevated,
                            gradient: isMe
                                ? LinearGradient(
                                    colors: [
                                      Color(0xFF22A02E),
                                      Color(0xFF1A8025),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            border: isMe
                                ? null
                                : Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isMe ? 20 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 20),
                            ),
                          ),
                          child: _buildMessageContent(message, isMe),
                        ),
                      ),
                      if (!isMe) const SizedBox(width: 48),
                    ],
                  ),
                );
              },
            ),
          ),

          // Quick Replies
          _buildQuickReplies(),

          // Input Area
          Container(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.fieldBackground,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                        minLines: 1,
                        maxLines: 5,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: "İzgeBot'a yazın...",
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Microphone Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: GestureDetector(
                      onLongPressStart: (_) => _startListening(),
                      onLongPressEnd: (_) => _stopListening(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isListening
                              ? Colors.redAccent
                              : AppColors.surfaceElevated,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: _isListening
                              ? Colors.white
                              : AppColors.textPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7ADC75), Color(0xFF1A8025)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF7ADC75).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => _sendMessage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.surfaceElevated,
              child: Icon(Icons.smart_toy, color: Color(0xFF7ADC75), size: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: const Radius.circular(4),
                bottomRight: const Radius.circular(20),
              ),
            ),
            child: Text(
              "Yazıyor...",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _speech.cancel();
    super.dispose();
  }
}
