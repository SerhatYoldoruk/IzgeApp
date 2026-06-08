import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveSupportScreen extends StatefulWidget {
  const LiveSupportScreen({super.key});

  @override
  State<LiveSupportScreen> createState() => _LiveSupportScreenState();
}

class _LiveSupportScreenState extends State<LiveSupportScreen> {
  // 1. MESAJLARI TUTACAK LİSTEMİZ
  // Gemini'nin anlayacağı formatta: [{"role": "user", "parts": [{"text": "merhaba"}]}]
  final List<Map<String, dynamic>> _messages = [];
  
  // 2. KULLANICI GİRİŞİNİ OKUYACAK KONTROLCÜ
  final TextEditingController _messageController = TextEditingController();
  
  // 3. EKRANI OTOMATİK AŞAĞI KAYDIRMAK İÇİN KONTROLCÜ
  final ScrollController _scrollController = ScrollController();
  
  // 4. YAPAY ZEKA DÜŞÜNÜYOR MU? (Yazıyor animasyonu için)
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Ekran açılır açılmaz yapay zekadan gelmiş gibi ilk mesajı listeye ekliyoruz
    _messages.add({
      "role": "model",
      "parts": [{"text": "Merhaba! Ben İzgeBot. Size nasıl yardımcı olabilirim?"}]
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 5. MESAJ GÖNDERME FONKSİYONUMUZ (SİHRİN GERÇEKLEŞTİĞİ YER)
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return; // Boş mesaj atılamasın

    // A) Kullanıcının mesajını listeye ekle ve kutuyu temizle
    setState(() {
      _messages.add({
        "role": "user",
        "parts": [{"text": text}]
      });
      _messageController.clear();
      _isTyping = true; // Bot düşünmeye başladı
    });
    
    _scrollToBottom(); // Mesaj gidince ekranı aşağı kaydır

    try {
      // B) SUPABASE EDGE FUNCTION'I ÇAĞIR ("izgebot" adını verdiğimiz fonksiyon)
      // Listemizdeki tüm geçmişi 'messages' adıyla fonksiyona gönderiyoruz
      final response = await Supabase.instance.client.functions.invoke(
        'izgebot',
        body: {'messages': _messages},
      );

      // C) Fonksiyondan (yani Gemini'den) gelen cevabı al
      final reply = response.data['reply'] as String;
      
      // D) Cevabı listemize ekle
      setState(() {
        _messages.add({
          "role": "model",
          "parts": [{"text": reply}]
        });
      });
      
      _scrollToBottom(); // Cevap gelince ekranı tekrar aşağı kaydır

    } catch (e) {
      // Bir hata olursa arayüzde göster
      setState(() {
        _messages.add({
          "role": "model",
          "parts": [{"text": "Üzgünüm, şu an bağlantı kuramıyorum. Lütfen daha sonra tekrar deneyin. ⚠️"}]
        });
      });
      debugPrint('İzgeBot Hatası: $e');
    } finally {
      // Hata olsa da olmasa da "Yazıyor..." animasyonunu kapat
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _scrollToBottom() {
    // Ekranın en altına yumuşak bir şekilde kayma animasyonu
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Ek Seçenekleri',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.image, color: AppColors.accent),
                ),
                title: Text('Fotoğraf veya Video', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'İzgeBot Asistan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.border,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Text(
              'Yapay Zeka destekli İzgeBot ile görüşüyorsunuz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          
          // 6. MESAJLARIN LİSTELENDİĞİ YER
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                // Eğer son elemana geldiysek ve yapay zeka yazıyorsa, animasyonu göster
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }

                // Normal mesajı al ve kimin yazdığına göre (user veya model) baloncuk oluştur
                final message = _messages[index];
                final isUser = message["role"] == "user";
                final text = message["parts"][0]["text"] as String;

                return isUser ? _buildUserMessage(text) : _buildSupportMessage(text);
              },
            ),
          ),
          
          // Chat Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.fieldBackground,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.add, color: AppColors.textSecondary),
                      onPressed: () => _showAttachmentMenu(context),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.fieldBackground,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        onSubmitted: (_) => _sendMessage(), // Klavyeden yolla tuşuna basılınca
                        decoration: InputDecoration(
                          hintText: 'Mesajınızı yazın...',
                          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A8025),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.send, color: Color(0xFFD3FFC8), size: 20),
                      onPressed: _sendMessage, // Butona basılınca
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

  // BOT MESAJ BALONCUĞU WIDGET'I
  Widget _buildSupportMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF1A8025),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.smart_toy, color: Color(0xFFD3FFC8), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  // KULLANICI MESAJ BALONCUĞU WIDGET'I
  Widget _buildUserMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF1A8025),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFD3FFC8),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // YAZIYOR... ANİMASYON WIDGET'I
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF1A8025),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.smart_toy, color: Color(0xFFD3FFC8), size: 20),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(delay: 0),
                SizedBox(width: 4),
                _TypingDot(delay: 200),
                const SizedBox(width: 4),
                _TypingDot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_controller),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
