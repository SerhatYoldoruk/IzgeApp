import 'package:flutter/material.dart';
import 'package:izge_app_frontend/core/constants/app_colors.dart';
import 'package:izge_app_frontend/core/localization/language_controller.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:izge_app_frontend/features/community/presentation/pages/new_post_screen.dart' as izge_new_post;

class DrawingActivity extends StatefulWidget {
  const DrawingActivity({super.key});

  @override
  State<DrawingActivity> createState() => _DrawingActivityState();
}

class _DrawingActivityState extends State<DrawingActivity> {
  List<DrawnLine> lines = [];
  Color selectedColor = Colors.black;
  double selectedWidth = 5.0;
  final GlobalKey _globalKey = GlobalKey();

  final List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  void _onPanStart(DragStartDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    box.globalToLocal(details.globalPosition);
    // AppBar ve SafeArea kaymalarını önlemek için AppBar yüksekliğini düşebiliriz 
    // ama en iyisi _globalKey context'inden RenderBox almaktır.
    RenderBox drawBox = _globalKey.currentContext?.findRenderObject() as RenderBox;
    Offset localPoint = drawBox.globalToLocal(details.globalPosition);
    
    setState(() {
      lines.add(DrawnLine([localPoint], selectedColor, selectedWidth));
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    RenderBox drawBox = _globalKey.currentContext?.findRenderObject() as RenderBox;
    Offset localPoint = drawBox.globalToLocal(details.globalPosition);
    setState(() {
      List<Offset> path = List.from(lines.last.path)..add(localPoint);
      lines.last = DrawnLine(path, selectedColor, selectedWidth);
    });
  }

  void _clearCanvas() {
    setState(() {
      lines.clear();
    });
  }

  Future<String?> _captureImage() async {
    if (lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Önce bir şeyler çizmelisin!'.tr())));
      return null;
    }
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/cizim_${DateTime.now().millisecondsSinceEpoch}.png').create();
        await imagePath.writeAsBytes(pngBytes);
        return imagePath.path;
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kaydedilirken bir hata oluştu.'.tr())));
    }
    return null;
  }

  Future<void> _saveImage() async {
    final path = await _captureImage();
    if (path != null) {
      await Share.shareXFiles(
        [XFile(path)],
        text: 'Harika bir çizim!'.tr(),
      );
    }
  }

  Future<void> _shareToForum() async {
    final path = await _captureImage();
    if (path != null && mounted) {
      // Import the new post screen and navigate to it
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => izge_new_post.NewPostScreen(initialImagePath: path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: lines.isEmpty,
      onPopInvokedWithResult: (didPop, resultObj) async {
        if (didPop) return;
        
        final result = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Çıkış'.tr(), style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
            content: Text('Harika bir çizim yaptın! Kaydetmek ister misin?'.tr(), style: TextStyle(color: AppColors.textPrimary)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'exit'),
                child: Text('Kaydetmeden Çık'.tr(), style: const TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'save'),
                child: Text('Kaydet & Çık'.tr(), style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );

        if (result == 'save') {
          await _saveImage();
          // ignore: use_build_context_synchronously
          if (mounted) Navigator.pop(context);
        } else if (result == 'exit') {
          // ignore: use_build_context_synchronously
          if (mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
        title: Text('Serbest Boyama'.tr(), style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.forum_outlined),
            onPressed: _shareToForum,
            tooltip: 'Forumda Paylaş'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _saveImage,
            tooltip: 'Kaydet / Paylaş'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearCanvas,
            tooltip: 'Temizle'.tr(),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              child: RepaintBoundary(
                key: _globalKey,
                child: ClipRRect(
                  child: CustomPaint(
                    painter: _DrawingPainter(lines: lines),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Renk Seç'.tr(), style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...colors.map((color) => _buildColorChose(color)),
                        // Silgi
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = const Color(0xFFF8F9FA); // Tuval arka plan rengi
                              selectedWidth = 20.0; // Kalın silgi
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surface,
                              border: Border.all(
                                color: selectedColor == const Color(0xFFF8F9FA) ? AppColors.accent : AppColors.border,
                                width: selectedColor == const Color(0xFFF8F9FA) ? 3 : 1,
                              ),
                            ),
                            child: const Icon(Icons.cleaning_services, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          selectedWidth = 5.0; // Kalem kalınlığı
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: isSelected ? 48 : 40,
        height: isSelected ? 48 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
                ]
              : null,
        ),
      ),
    );
  }
}

class DrawnLine {
  final List<Offset> path;
  final Color color;
  final double width;

  DrawnLine(this.path, this.color, this.width);
}

class _DrawingPainter extends CustomPainter {
  final List<DrawnLine> lines;

  _DrawingPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    // Arkaplanı kendi rengine boyayalım
    Paint bgPaint = Paint()..color = const Color(0xFFF8F9FA); // Çok açık gri / kırık beyaz bir tuval
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    for (var line in lines) {
      Paint paint = Paint()
        ..color = line.color == const Color(0xFFF8F9FA) ? const Color(0xFFF8F9FA) : line.color // Eğer silgiyse tuval rengi
        ..strokeCap = StrokeCap.round
        ..strokeWidth = line.width
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < line.path.length - 1; i++) {
        // App bar offset correction workaround if globalToLocal is tricky, 
        // but globalToLocal on the render box usually handles it perfectly if we get the right box.
        // Actually, since we use globalToLocal on the GestureDetector's context, the points are already local.
        canvas.drawLine(line.path[i], line.path[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
