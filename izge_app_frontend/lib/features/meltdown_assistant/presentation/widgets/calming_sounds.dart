import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';

class CalmingSounds extends StatefulWidget {
  const CalmingSounds({super.key});

  @override
  State<CalmingSounds> createState() => _CalmingSoundsState();
}

class _CalmingSoundsState extends State<CalmingSounds> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlaying;
  bool _isPlaying = false;

  // Lütfen bu dosyaları projenizin 'assets/audio/' klasörüne ekleyin 
  // ve pubspec.yaml dosyasında tanımlayın.
  final List<Map<String, String>> _sounds = [
    {
      'title': 'Beyaz Gürültü',
      'icon': 'waves',
      'path': 'audio/white_noise.mp3',
    },
    {
      'title': 'Yağmur Sesi',
      'icon': 'water_drop',
      'path': 'audio/rain.mp3',
    },
    {
      'title': 'Orman Uğultusu',
      'icon': 'forest',
      'path': 'audio/forest.mp3',
    },
    {
      'title': 'Kalp Atışı',
      'icon': 'favorite',
      'path': 'audio/heartbeat.mp3',
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the audio
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseSound(String path) async {
    if (_currentlyPlaying == path && _isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      // Note: If you don't have the assets yet, this will throw an exception in debug.
      // Make sure to add the mp3 files to assets/audio/ directory.
      try {
        await _audioPlayer.play(AssetSource(path.replaceAll('audio/', '')));
        setState(() {
          _currentlyPlaying = path;
          _isPlaying = true;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ses dosyası henüz yüklenmemiş: $path'),
              backgroundColor: Colors.orange,
            )
          );
        }
      }
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'waves': return Icons.waves;
      case 'water_drop': return Icons.water_drop;
      case 'forest': return Icons.forest;
      case 'favorite': return Icons.favorite;
      default: return Icons.music_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(
          'Sakinleştirici Sesler'.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Duyusal aşırı yüklenmeyi azaltmak için arka planda sürekli çalan sakinleştirici sesler.'.tr(),
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        ..._sounds.map((sound) => _buildSoundCard(sound)),
      ],
    );
  }

  Widget _buildSoundCard(Map<String, String> sound) {
    final isThisPlaying = _currentlyPlaying == sound['path'] && _isPlaying;

    return Card(
      color: isThisPlaying ? AppColors.accent.withOpacity(0.1) : AppColors.surface,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isThisPlaying ? AppColors.accent : AppColors.textSecondary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIcon(sound['icon']!),
            color: isThisPlaying ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
        title: Text(
          sound['title']!.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: IconButton(
          onPressed: () => _playPauseSound(sound['path']!),
          icon: Icon(
            isThisPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            size: 40,
            color: isThisPlaying ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
