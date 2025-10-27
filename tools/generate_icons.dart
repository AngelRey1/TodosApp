import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Script para generar iconos de la app
/// Ejecutar con: dart run tools/generate_icons.dart
Future<void> main() async {
  // Asegurar que el directorio existe
  final directory = Directory('assets/images');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  // Generar icono principal (1024x1024)
  await _generateIcon(
    'assets/images/app_icon.png',
    1024,
    Colors.white,
    true,
  );

  // Generar foreground para adaptive icon (432x432)
  await _generateIcon(
    'assets/images/app_icon_foreground.png',
    432,
    Colors.transparent,
    false,
  );

  // Generar splash icon (512x512)
  await _generateIcon(
    'assets/images/splash_icon.png',
    512,
    Colors.transparent,
    false,
  );

  print('✓ Iconos generados exitosamente en assets/images/');
}

Future<void> _generateIcon(
  String path,
  int size,
  Color background,
  bool withBackground,
) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint();

  // Fondo
  if (withBackground) {
    paint.color = background;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      paint,
    );
  }

  // Dibujar checkbox con checkmark (icono de todo list)
  final iconSize = size * 0.6;
  final offset = (size - iconSize) / 2;

  // Checkbox exterior
  paint
    ..color = const Color(0xFF2196F3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = size * 0.08;

  final rect = RRect.fromRectAndRadius(
    Rect.fromLTWH(offset, offset, iconSize, iconSize),
    Radius.circular(size * 0.1),
  );
  canvas.drawRRect(rect, paint);

  // Checkmark
  paint
    ..style = PaintingStyle.stroke
    ..strokeWidth = size * 0.1
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final checkPath = Path();
  final checkSize = iconSize * 0.5;
  final checkOffset = offset + iconSize * 0.25;

  checkPath.moveTo(checkOffset, checkOffset + checkSize * 0.5);
  checkPath.lineTo(
    checkOffset + checkSize * 0.35,
    checkOffset + checkSize * 0.8,
  );
  checkPath.lineTo(
    checkOffset + checkSize * 0.9,
    checkOffset + checkSize * 0.2,
  );

  canvas.drawPath(checkPath, paint);

  // Convertir a imagen
  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final bytes = byteData!.buffer.asUint8List();

  // Guardar archivo
  await File(path).writeAsBytes(bytes);
  print('✓ Generado: $path');
}
